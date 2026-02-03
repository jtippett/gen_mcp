defmodule GenMCP.Suite.TaskStore.ETSTest do
  use ExUnit.Case, async: true

  alias GenMCP.Suite.TaskStore.ETS

  setup do
    {:ok, state} = ETS.init([])
    {:ok, state: state}
  end

  describe "init/1" do
    test "creates ETS table with default TTL" do
      {:ok, state} = ETS.init([])

      assert is_reference(state.table)
      assert state.ttl == :timer.hours(1)
    end

    test "accepts custom TTL" do
      {:ok, state} = ETS.init(ttl: :timer.minutes(30))

      assert state.ttl == :timer.minutes(30)
    end
  end

  describe "create/4" do
    test "creates task with pending status", %{state: state} do
      session_id = "session-123"
      task_id = "task-456"
      metadata = %{"operation" => "process_file"}

      {:ok, task, _state} = ETS.create(session_id, task_id, metadata, state)

      assert task.id == task_id
      assert task.session_id == session_id
      assert task.status == :pending
      assert task.result == nil
      assert task.error == nil
      assert task.metadata == metadata
      assert %DateTime{} = task.created_at
      assert %DateTime{} = task.updated_at
      assert task.created_at == task.updated_at
    end

    test "stores task in ETS table", %{state: state} do
      session_id = "session-123"
      task_id = "task-456"

      {:ok, task, state} = ETS.create(session_id, task_id, %{}, state)

      [{^task_id, stored_task}] = :ets.lookup(state.table, task_id)
      assert stored_task == task
    end
  end

  describe "get/2" do
    test "returns task if exists", %{state: state} do
      {:ok, created_task, state} = ETS.create("session-1", "task-1", %{}, state)

      {:ok, retrieved_task, _state} = ETS.get("task-1", state)

      assert retrieved_task == created_task
    end

    test "returns error if not found", %{state: state} do
      result = ETS.get("nonexistent-task", state)

      assert result == {:error, :not_found}
    end
  end

  describe "update/3" do
    test "updates task fields", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)

      # Small delay to ensure updated_at changes
      Process.sleep(1)

      {:ok, updated_task, _state} =
        ETS.update("task-1", %{status: :running, result: "partial"}, state)

      assert updated_task.status == :running
      assert updated_task.result == "partial"
      assert DateTime.compare(updated_task.updated_at, updated_task.created_at) == :gt
    end

    test "preserves unmodified fields", %{state: state} do
      {:ok, original_task, state} = ETS.create("session-1", "task-1", %{"key" => "value"}, state)

      {:ok, updated_task, _state} = ETS.update("task-1", %{status: :completed}, state)

      assert updated_task.id == original_task.id
      assert updated_task.session_id == original_task.session_id
      assert updated_task.metadata == original_task.metadata
      assert updated_task.created_at == original_task.created_at
    end

    test "returns error if not found", %{state: state} do
      result = ETS.update("nonexistent-task", %{status: :running}, state)

      assert result == {:error, :not_found}
    end

    test "can update error field on failure", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)

      {:ok, updated_task, _state} =
        ETS.update("task-1", %{status: :failed, error: "Something went wrong"}, state)

      assert updated_task.status == :failed
      assert updated_task.error == "Something went wrong"
    end
  end

  describe "delete/2" do
    test "removes task from store", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)

      {:ok, state} = ETS.delete("task-1", state)

      assert ETS.get("task-1", state) == {:error, :not_found}
    end

    test "succeeds even if task does not exist", %{state: state} do
      {:ok, _state} = ETS.delete("nonexistent-task", state)
    end
  end

  describe "list/2" do
    test "returns tasks for session", %{state: state} do
      {:ok, task1, state} = ETS.create("session-1", "task-1", %{}, state)
      {:ok, task2, state} = ETS.create("session-1", "task-2", %{}, state)
      {:ok, _task3, state} = ETS.create("session-2", "task-3", %{}, state)

      {:ok, tasks, _state} = ETS.list("session-1", state)

      assert length(tasks) == 2
      task_ids = Enum.map(tasks, & &1.id) |> Enum.sort()
      assert task_ids == ["task-1", "task-2"]
      assert Enum.all?(tasks, fn t -> t in [task1, task2] end)
    end

    test "returns empty list for session with no tasks", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)

      {:ok, tasks, _state} = ETS.list("session-2", state)

      assert tasks == []
    end

    test "returns empty list when store is empty", %{state: state} do
      {:ok, tasks, _state} = ETS.list("session-1", state)

      assert tasks == []
    end
  end
end
