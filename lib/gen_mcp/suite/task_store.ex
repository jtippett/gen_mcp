defmodule GenMCP.Suite.TaskStore do
  @moduledoc """
  Behaviour for task persistence backends.

  Tasks enable durable request tracking where clients can disconnect
  and reconnect to poll results. The default implementation uses ETS.

  ## Configuration

      use GenMCP.Suite,
        task_store: {GenMCP.Suite.TaskStore.ETS, ttl: :timer.hours(1)}

  ## Custom Implementation

      defmodule MyApp.RedisTaskStore do
        @behaviour GenMCP.Suite.TaskStore

        @impl true
        def init(opts) do
          {:ok, %{conn: opts[:connection]}}
        end

        # ... implement other callbacks
      end
  """

  @type task_id :: String.t()
  @type session_id :: String.t()
  @type status :: :pending | :running | :completed | :failed | :cancelled

  @type task :: %{
          id: task_id(),
          session_id: session_id(),
          status: status(),
          result: term() | nil,
          error: term() | nil,
          metadata: map(),
          created_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @type state :: term()

  @doc """
  Initializes the task store with the given options.

  Returns `{:ok, state}` on success or `{:error, reason}` on failure.
  """
  @callback init(opts :: keyword()) :: {:ok, state()} | {:error, term()}

  @doc """
  Creates a new task for a session.

  The task is created with `:pending` status. Returns the created task
  and updated state on success.
  """
  @callback create(session_id(), task_id(), metadata :: map(), state()) ::
              {:ok, task(), state()} | {:error, term()}

  @doc """
  Retrieves a task by its ID.

  Returns `{:ok, task, state}` if found, or `{:error, :not_found}` if
  the task does not exist.
  """
  @callback get(task_id(), state()) ::
              {:ok, task(), state()} | {:error, :not_found}

  @doc """
  Updates a task with the given fields.

  The `updates` map may contain any task fields except `:id` and
  `:session_id`. The `:updated_at` timestamp is automatically set.

  Returns `{:ok, updated_task, state}` on success.
  """
  @callback update(task_id(), updates :: map(), state()) ::
              {:ok, task(), state()} | {:error, :not_found | term()}

  @doc """
  Deletes a task by its ID.

  Returns `{:ok, state}` on success. Deleting a non-existent task
  should succeed silently.
  """
  @callback delete(task_id(), state()) :: {:ok, state()} | {:error, term()}

  @doc """
  Lists all tasks for a given session.

  Returns `{:ok, tasks, state}` where `tasks` is a list of task maps.
  """
  @callback list(session_id(), state()) :: {:ok, [task()], state()}
end
