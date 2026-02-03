defmodule GenMCP.Suite.TaskStore.ETS do
  @moduledoc """
  Default ETS-based TaskStore implementation.

  This implementation stores tasks in an ETS table with public read
  concurrency enabled. Tasks are keyed by their task ID.

  ## Options

    * `:ttl` - Time-to-live for tasks in milliseconds. Defaults to 1 hour.
      Note: TTL cleanup is not automatically performed by this module.
      You may implement periodic cleanup using the `created_at` or
      `updated_at` timestamps.

  ## Example

      # In your Suite configuration
      use GenMCP.Suite,
        task_store: {GenMCP.Suite.TaskStore.ETS, ttl: :timer.hours(2)}

  """

  @behaviour GenMCP.Suite.TaskStore

  @default_ttl to_timeout(hour: 1)

  @impl true
  def init(opts) do
    ttl = Keyword.get(opts, :ttl, @default_ttl)
    table = :ets.new(__MODULE__, [:set, :public, read_concurrency: true])
    {:ok, %{table: table, ttl: ttl}}
  end

  @impl true
  def create(session_id, task_id, metadata, state) do
    now = DateTime.utc_now()

    task = %{
      id: task_id,
      session_id: session_id,
      status: :pending,
      result: nil,
      error: nil,
      metadata: metadata,
      created_at: now,
      updated_at: now
    }

    true = :ets.insert(state.table, {task_id, task})
    {:ok, task, state}
  end

  @impl true
  def get(task_id, state) do
    case :ets.lookup(state.table, task_id) do
      [{^task_id, task}] -> {:ok, task, state}
      [] -> {:error, :not_found}
    end
  end

  @impl true
  def update(task_id, updates, state) do
    case :ets.lookup(state.table, task_id) do
      [{^task_id, task}] ->
        updated_task =
          task
          |> Map.merge(updates)
          |> Map.put(:updated_at, DateTime.utc_now())

        true = :ets.insert(state.table, {task_id, updated_task})
        {:ok, updated_task, state}

      [] ->
        {:error, :not_found}
    end
  end

  @impl true
  def delete(task_id, state) do
    true = :ets.delete(state.table, task_id)
    {:ok, state}
  end

  @impl true
  def list(session_id, state) do
    tasks =
      :ets.foldl(
        fn {_id, task}, acc ->
          if task.session_id == session_id do
            [task | acc]
          else
            acc
          end
        end,
        [],
        state.table
      )

    {:ok, tasks, state}
  end
end
