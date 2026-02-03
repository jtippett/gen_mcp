defmodule GenMCP.SuiteSubscriptionTest do
  use ExUnit.Case, async: true

  import GenMCP.Test.Helpers

  alias GenMCP.MCP
  alias GenMCP.Suite

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
      params: %{}
    }

    assert {:noreply, state} = Suite.handle_notification(client_init_notif, state)
    state
  end

  describe "subscribe/unsubscribe requests" do
    test "subscribe adds URI to subscribed set" do
      state = init_session()

      subscribe_req = %MCP.SubscribeRequest{
        id: 1,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req, build_channel(), state)

      assert MapSet.member?(state.subscribed_uris, "file:///readme.txt")
    end

    test "unsubscribe removes URI from subscribed set" do
      state = init_session()

      # First subscribe
      subscribe_req = %MCP.SubscribeRequest{
        id: 1,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req, build_channel(), state)

      assert MapSet.member?(state.subscribed_uris, "file:///readme.txt")

      # Then unsubscribe
      unsubscribe_req = %MCP.UnsubscribeRequest{
        id: 2,
        params: %MCP.UnsubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(unsubscribe_req, build_channel(), state)

      refute MapSet.member?(state.subscribed_uris, "file:///readme.txt")
    end

    test "subscribe is idempotent (adding same URI twice results in size 1)" do
      state = init_session()

      subscribe_req = %MCP.SubscribeRequest{
        id: 1,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      # Subscribe first time
      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req, build_channel(), state)

      assert MapSet.size(state.subscribed_uris) == 1

      # Subscribe second time with same URI
      subscribe_req2 = %MCP.SubscribeRequest{
        id: 2,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req2, build_channel(), state)

      # Size should still be 1
      assert MapSet.size(state.subscribed_uris) == 1
    end

    test "unsubscribe non-existent URI is no-op" do
      state = init_session()
      initial_uris = state.subscribed_uris

      unsubscribe_req = %MCP.UnsubscribeRequest{
        id: 1,
        params: %MCP.UnsubscribeRequestParams{uri: "file:///nonexistent.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(unsubscribe_req, build_channel(), state)

      # State should be unchanged
      assert state.subscribed_uris == initial_uris
    end

    test "ping returns empty result" do
      state = init_session()

      ping_req = %MCP.PingRequest{id: 1}

      assert {:reply, {:result, %MCP.Result{}}, _state} =
               Suite.handle_request(ping_req, build_channel(), state)
    end
  end

  describe "notify_resource_updated" do
    test "returns {:ok, :notified} when subscribed with active listener" do
      state = init_session()

      # Subscribe to a URI
      subscribe_req = %MCP.SubscribeRequest{
        id: 1,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req, build_channel(), state)

      # Notify about resource update
      result = Suite.notify_resource_updated("file:///readme.txt", state)

      assert {:ok, :notified} = result

      # Verify that the notification was sent
      assert_receive {:"$gen_mcp", :notification, %MCP.ResourceUpdatedNotification{} = notif}
      assert notif.params.uri == "file:///readme.txt"
    end

    test "returns {:ok, :not_subscribed} when URI not subscribed" do
      state = init_session()

      result = Suite.notify_resource_updated("file:///unsubscribed.txt", state)

      assert {:ok, :not_subscribed} = result
    end

    test "returns {:ok, :no_listener} when channel closed" do
      state = init_session()

      # Subscribe to a URI
      subscribe_req = %MCP.SubscribeRequest{
        id: 1,
        params: %MCP.SubscribeRequestParams{uri: "file:///readme.txt"}
      }

      assert {:reply, {:result, %MCP.Result{}}, state} =
               Suite.handle_request(subscribe_req, build_channel(), state)

      # Close the channel by setting status to closed
      closed_channel = %{state.sc_channel | status: :closed}
      state = %{state | sc_channel: closed_channel}

      # Notify about resource update
      result = Suite.notify_resource_updated("file:///readme.txt", state)

      assert {:ok, :no_listener} = result
    end
  end
end
