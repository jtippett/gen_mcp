defmodule GenMCP.SuiteSubscriptionTest do
  use ExUnit.Case, async: true

  import GenMCP.Test.Helpers
  import Mox

  alias GenMCP.MCP
  alias GenMCP.Mux.Channel
  alias GenMCP.Suite

  setup :verify_on_exit!

  # For integration tests that need a real session process
  @moduletag :capture_log

  @server_info [
    server_name: "Test Server",
    server_version: "0"
  ]

  defp init_session(server_opts \\ []) do
    assert {:ok, state} = Suite.init("some-session-id", Keyword.merge(@server_info, server_opts))

    init_req = %MCP.InitializeRequest{
      id: "setup-init-1",
      params: %MCP.InitializeRequestParams{
        capabilities: %MCP.ClientCapabilities{},
        clientInfo: %{name: "test", version: "1.0.0"},
        protocolVersion: "2025-06-18"
      }
    }

    assert {:reply, {:result, _result}, state} =
             Suite.handle_request(init_req, build_channel(), state)

    client_init_notif = %MCP.InitializedNotification{
      method: "notifications/initialized",
      params: %{}
    }

    assert {:noreply, state} = Suite.handle_notification(client_init_notif, state)
    state
  end

  defp subscribe(state, uri) do
    req = %MCP.SubscribeRequest{id: 1, params: %{uri: uri}}
    {:reply, {:result, _}, state} = Suite.handle_request(req, build_channel(), state)
    state
  end

  defp with_open_listener(state) do
    # Simulate opening a listener channel by setting sc_channel to an open channel
    channel = %Channel{
      client: self(),
      progress_token: nil,
      status: :stream,
      assigns: %{}
    }

    %{state | sc_channel: channel}
  end

  describe "notify_resource_updated/2" do
    test "returns {:ok, :notified} when subscribed with open listener" do
      state =
        init_session()
        |> subscribe("file:///test.txt")
        |> with_open_listener()

      assert {:ok, :notified} = Suite.notify_resource_updated("file:///test.txt", state)

      # Verify notification was sent
      assert_receive {:"$gen_mcp", :notification, notification}
      assert %MCP.ResourceUpdatedNotification{params: %{uri: "file:///test.txt"}} = notification
    end

    test "returns {:ok, :not_subscribed} when not subscribed" do
      state = with_open_listener(init_session())

      assert {:ok, :not_subscribed} = Suite.notify_resource_updated("file:///test.txt", state)
      refute_receive {:"$gen_mcp", :notification, _}
    end

    test "returns {:ok, :no_listener} when subscribed but listener closed" do
      state = subscribe(init_session(), "file:///test.txt")

      # sc_channel defaults to :request status (not :stream) and is closed after init
      state = %{state | sc_channel: Channel.as_closed(state.sc_channel)}

      assert {:ok, :no_listener} = Suite.notify_resource_updated("file:///test.txt", state)
      refute_receive {:"$gen_mcp", :notification, _}
    end
  end
end
