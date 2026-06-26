defmodule GenMCP.SuiteSubscriptionTest do
  use ExUnit.Case, async: true

  import GenMCP.Test.Helpers
  import Mox

  alias GenMCP.MCP
  alias GenMCP.Mux.Channel
  alias GenMCP.Suite
  alias GenMCP.Support.ResourceRepoMock

  setup :verify_on_exit!

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

    client_init_notif = %MCP.InitializedNotification{params: %{}}

    assert {:noreply, state} = Suite.handle_notification(client_init_notif, state)
    state
  end

  defp subscribe(state, uri) do
    req = %MCP.SubscribeRequest{id: 1, params: %{uri: uri}}
    {:reply, {:result, _}, state} = Suite.handle_request(req, build_channel(), state)
    state
  end

  # An open listener channel whose client is the test process, so pushed
  # notifications arrive in this process's mailbox.
  defp with_open_listener(state) do
    %{state | sc_channel: %{build_channel() | status: :stream}}
  end

  describe "resource subscription capability" do
    test "advertises subscribe capability when resources are available" do
      stub(ResourceRepoMock, :prefix, fn :test_repo -> "file:///" end)

      {:ok, state} =
        Suite.init(
          "some-session-id",
          Keyword.merge(@server_info, resources: [{ResourceRepoMock, :test_repo}])
        )

      init_req = %MCP.InitializeRequest{
        id: 1,
        params: %MCP.InitializeRequestParams{
          capabilities: %MCP.ClientCapabilities{},
          clientInfo: %{name: "test", version: "1.0.0"},
          protocolVersion: "2025-06-18"
        }
      }

      assert {:reply, {:result, result}, _state} =
               Suite.handle_request(init_req, build_channel(), state)

      assert %MCP.InitializeResult{
               capabilities: %MCP.ServerCapabilities{resources: %{subscribe: true}}
             } = result
    end
  end

  describe "subscribe/unsubscribe handlers" do
    test "subscribe adds URI to subscribed set" do
      state = init_session()
      req = %MCP.SubscribeRequest{id: 1, params: %{uri: "file:///test.txt"}}

      assert {:reply, {:result, %MCP.Result{}}, new_state} =
               Suite.handle_request(req, build_channel(), state)

      assert MapSet.member?(new_state.subscribed_uris, "file:///test.txt")
    end

    test "unsubscribe removes URI from subscribed set" do
      state = subscribe(init_session(), "file:///test.txt")
      req = %MCP.UnsubscribeRequest{id: 2, params: %{uri: "file:///test.txt"}}

      assert {:reply, {:result, %MCP.Result{}}, new_state} =
               Suite.handle_request(req, build_channel(), state)

      refute MapSet.member?(new_state.subscribed_uris, "file:///test.txt")
    end

    test "duplicate subscribe is idempotent" do
      state = subscribe(init_session(), "file:///test.txt")
      req = %MCP.SubscribeRequest{id: 2, params: %{uri: "file:///test.txt"}}

      {:reply, {:result, %MCP.Result{}}, new_state} =
        Suite.handle_request(req, build_channel(), state)

      assert MapSet.member?(new_state.subscribed_uris, "file:///test.txt")
      assert MapSet.size(new_state.subscribed_uris) == 1
    end

    test "unsubscribe non-existent URI is a no-op" do
      state = init_session()
      req = %MCP.UnsubscribeRequest{id: 1, params: %{uri: "file:///not-subscribed.txt"}}

      assert {:reply, {:result, %MCP.Result{}}, new_state} =
               Suite.handle_request(req, build_channel(), state)

      assert MapSet.size(new_state.subscribed_uris) == 0
    end
  end

  describe "notify_resource_updated/2" do
    test "returns {:ok, :notified} when subscribed with open listener" do
      state =
        init_session()
        |> subscribe("file:///test.txt")
        |> with_open_listener()

      assert {:ok, :notified} = Suite.notify_resource_updated("file:///test.txt", state)

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
      state = %{state | sc_channel: Channel.as_closed(state.sc_channel)}

      assert {:ok, :no_listener} = Suite.notify_resource_updated("file:///test.txt", state)
      refute_receive {:"$gen_mcp", :notification, _}
    end
  end
end
