defmodule GenMCP.SuiteTasksTest do
  use ExUnit.Case, async: true

  import GenMCP.Test.Helpers

  alias GenMCP.MCP
  alias GenMCP.Suite
  alias GenMCP.Suite.TaskStore.ETS, as: ETSTaskStore

  @server_info [
    server_name: "Test Server",
    server_version: "0"
  ]

  defp init_session(server_opts \\ []) do
    # Default to using task store
    opts =
      @server_info
      |> Keyword.merge(task_store: {ETSTaskStore, []})
      |> Keyword.merge(server_opts)

    assert {:ok, state} = Suite.init("some-session-id", opts)

    init_req = %MCP.InitializeRequest{
      id: "setup-init-1",
      params: %MCP.InitializeRequestParams{
        capabilities: %MCP.ClientCapabilities{},
        clientInfo: %{name: "test", version: "1.0.0"},
        protocolVersion: "2025-11-25"
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

  describe "capabilities" do
    test "advertises tasks capability when task_store is configured" do
      opts =
        @server_info
        |> Keyword.merge(task_store: {ETSTaskStore, []})

      assert {:ok, state} = Suite.init("session-1", opts)

      init_req = %MCP.InitializeRequest{
        id: "init-1",
        params: %MCP.InitializeRequestParams{
          capabilities: %MCP.ClientCapabilities{},
          clientInfo: %{name: "test", version: "1.0.0"},
          protocolVersion: "2025-11-25"
        }
      }

      assert {:reply, {:result, result}, _state} =
               Suite.handle_request(init_req, build_channel(), state)

      # tasks capability is an empty map (object) when enabled
      assert result.capabilities.tasks == %{}
    end

    test "does not advertise tasks capability when task_store is nil" do
      opts = @server_info

      assert {:ok, state} = Suite.init("session-2", opts)

      init_req = %MCP.InitializeRequest{
        id: "init-1",
        params: %MCP.InitializeRequestParams{
          capabilities: %MCP.ClientCapabilities{},
          clientInfo: %{name: "test", version: "1.0.0"},
          protocolVersion: "2025-11-25"
        }
      }

      assert {:reply, {:result, result}, _state} =
               Suite.handle_request(init_req, build_channel(), state)

      # tasks capability is nil when not enabled
      assert result.capabilities.tasks == nil
    end
  end

  describe "tasks/list request" do
    test "returns empty list when no tasks exist" do
      state = init_session()

      list_req = %MCP.ListTasksRequest{id: 1}

      assert {:reply, {:result, %MCP.ListTasksResult{} = result}, _state} =
               Suite.handle_request(list_req, build_channel(), state)

      assert result.tasks == []
    end

    test "returns tasks for the session" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      list_req = %MCP.ListTasksRequest{id: 1}

      assert {:reply, {:result, %MCP.ListTasksResult{} = result}, _state} =
               Suite.handle_request(list_req, build_channel(), state)

      assert length(result.tasks) == 1
      [task] = result.tasks
      assert task.taskId == "task-1"
      assert task.status == :pending
    end
  end

  describe "tasks/get request" do
    test "returns task when found" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      get_req = %MCP.GetTaskRequest{
        id: 1,
        params: %{taskId: "task-1"}
      }

      assert {:reply, {:result, task}, _state} =
               Suite.handle_request(get_req, build_channel(), state)

      assert task.taskId == "task-1"
      assert task.status == :pending
    end

    test "returns error when task not found" do
      state = init_session()

      get_req = %MCP.GetTaskRequest{
        id: 1,
        params: %{taskId: "nonexistent"}
      }

      assert {:reply, {:error, :invalid_params, "Task not found"}, _state} =
               Suite.handle_request(get_req, build_channel(), state)
    end
  end

  describe "tasks/cancel request" do
    test "cancels task and returns updated task" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      cancel_req = %MCP.CancelTaskRequest{
        id: 1,
        params: %{taskId: "task-1"}
      }

      assert {:reply, {:result, task}, state} =
               Suite.handle_request(cancel_req, build_channel(), state)

      assert task.taskId == "task-1"
      assert task.status == :cancelled

      # Verify task is actually cancelled in store
      {:ok, stored_task, _} = state.task_store.get("task-1", state.task_store_state)
      assert stored_task.status == :cancelled
    end

    test "returns error when task not found" do
      state = init_session()

      cancel_req = %MCP.CancelTaskRequest{
        id: 1,
        params: %{taskId: "nonexistent"}
      }

      assert {:reply, {:error, :invalid_params, "Task not found"}, _state} =
               Suite.handle_request(cancel_req, build_channel(), state)
    end
  end

  describe "complete_task" do
    test "completes task with success result" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      assert {:ok, state} = Suite.complete_task("task-1", {:ok, %{answer: 42}}, state)

      # Verify task is completed in store
      {:ok, stored_task, _} = state.task_store.get("task-1", state.task_store_state)
      assert stored_task.status == :completed
      assert stored_task.result == %{answer: 42}

      # Verify notification was sent
      assert_receive {:"$gen_mcp", :notification, %MCP.TaskStatusNotification{} = notif}
      assert notif.params.taskId == "task-1"
      assert notif.params.status == :completed
    end

    test "completes task with error result" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      assert {:ok, state} = Suite.complete_task("task-1", {:error, "something went wrong"}, state)

      # Verify task is failed in store
      {:ok, stored_task, _} = state.task_store.get("task-1", state.task_store_state)
      assert stored_task.status == :failed
      assert stored_task.error == "something went wrong"

      # Verify notification was sent
      assert_receive {:"$gen_mcp", :notification, %MCP.TaskStatusNotification{} = notif}
      assert notif.params.taskId == "task-1"
      assert notif.params.status == :failed
    end

    test "returns error when task not found" do
      state = init_session()

      assert {:error, :not_found} =
               Suite.complete_task("nonexistent", {:ok, "result"}, state)
    end

    test "returns error when no task store configured" do
      state = init_session(task_store: nil)

      assert {:error, :no_task_store} =
               Suite.complete_task("task-1", {:ok, "result"}, state)
    end

    test "does not send notification when channel is closed" do
      state = init_session()

      # Create a task directly in the store
      {:ok, _task, task_store_state} =
        state.task_store.create(state.session_id, "task-1", %{}, state.task_store_state)

      state = %{state | task_store_state: task_store_state}

      # Close the channel
      closed_channel = %{state.sc_channel | status: :closed}
      state = %{state | sc_channel: closed_channel}

      assert {:ok, _state} = Suite.complete_task("task-1", {:ok, "result"}, state)

      # Verify no notification was sent
      refute_receive {:"$gen_mcp", :notification, _}
    end
  end
end
