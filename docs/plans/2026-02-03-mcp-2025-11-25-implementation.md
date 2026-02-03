# MCP 2025-11-25 Upgrade Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Upgrade gen_mcp from MCP spec 2025-06-18 to 2025-11-25 with full feature parity.

**Architecture:** Schema-first approach - update entity generation, then implement features incrementally. Each feature is self-contained with its own tests. TaskStore uses a behaviour pattern matching SessionController.

**Tech Stack:** Elixir, Phoenix, JSV (JSON Schema Validation), ETS for default TaskStore.

---

## Task 1: Update Schema Reference

**Files:**
- Modify: `mix.exs:76-85`

**Step 1: Update the mcp_schemas function**

```elixir
defp mcp_schemas do
  {:modelcontextprotocol,
   git: "https://github.com/modelcontextprotocol/modelcontextprotocol.git",
   sparse: "schema/2025-11-25",
   ref: "2025-11-25",
   only: [:dev, :test],
   compile: false,
   runtime: false,
   app: false}
end
```

**Step 2: Fetch new dependencies**

Run: `mix deps.get`
Expected: Successfully fetches new schema version

**Step 3: Commit**

```bash
git add mix.exs
git commit -m "$(cat <<'EOF'
chore: Update MCP schema reference to 2025-11-25

Upgrade from 2025-06-18 to 2025-11-25 spec version.
EOF
)"
```

---

## Task 2: Update Generator for New Schema Structure

**Files:**
- Modify: `tools/gen-rpc-schemas.exs:101-104`
- Modify: `tools/gen-rpc-schemas.exs:543-581` (prelude)

**Step 1: Update schema path**

Change line 103 from:
```elixir
"deps/modelcontextprotocol/schema/2025-06-18/schema.json"
```
to:
```elixir
"deps/modelcontextprotocol/schema/2025-11-25/schema.json"
```

**Step 2: Update prelude spec links**

In the `prelude` function, update the spec version references from `2025-06-18` to `2025-11-25`:
- Line ~554: Update Meta module description link
- Line ~567: Update RequestMeta module description link

**Step 3: Verify generator runs**

Run: `just gen-entities`
Expected: May fail with unknown schema names - that's expected for next task

**Step 4: Commit**

```bash
git add tools/gen-rpc-schemas.exs
git commit -m "$(cat <<'EOF'
chore: Update generator for 2025-11-25 schema path
EOF
)"
```

---

## Task 3: Add New Entity Configurations to Generator

**Files:**
- Modify: `tools/gen-rpc-schemas.exs:146-449` (module_config function)

**Step 1: Add new entity configurations**

Add the following cases to the `module_config/1` function (alphabetically):

```elixir
# New in 2025-11-25:

:CancelTaskRequest ->
  [rpc_request: true]

:CancelTaskRequestParams ->
  [rpc_request_params: true]

:CancelTaskResult ->
  []

:CreateTaskResult ->
  []

:ElicitRequest ->
  [rpc_request: true]

:ElicitRequestFormParams ->
  []

:ElicitRequestParams ->
  [rpc_request_params: true]

:ElicitRequestURLParams ->
  []

:ElicitResult ->
  []

:ElicitationCompleteNotification ->
  []

:GetTaskPayloadRequest ->
  [rpc_request: true]

:GetTaskPayloadRequestParams ->
  [rpc_request_params: true]

:GetTaskPayloadResult ->
  []

:GetTaskRequest ->
  [rpc_request: true]

:GetTaskRequestParams ->
  [rpc_request_params: true]

:GetTaskResult ->
  []

:Icon ->
  []

:Icons ->
  []

:JSONRPCErrorResponse ->
  []

:JSONRPCResultResponse ->
  []

:LegacyTitledEnumSchema ->
  :nogen

:ListTasksRequest ->
  [rpc_request: true]

:ListTasksRequestParams ->
  [rpc_request_params: true]

:ListTasksResult ->
  []

:LoggingMessageNotificationParams ->
  []

:MultiSelectEnumSchema ->
  :nogen

:NotificationParams ->
  :nogen

:PaginatedRequestParams ->
  :nogen

:PingRequest ->
  [rpc_request: true]

:PingRequestParams ->
  [rpc_request_params: true]

:ProgressNotificationParams ->
  []

:ResourceUpdatedNotification ->
  []

:ResourceUpdatedNotificationParams ->
  []

:SingleSelectEnumSchema ->
  :nogen

:Task ->
  []

:TaskMetadata ->
  []

:TaskResolvedNotification ->
  []

:TaskResolvedNotificationParams ->
  []

:TaskStatusNotification ->
  []

:TaskStatusNotificationParams ->
  []

:ToolChoice ->
  []

:ToolChoiceAuto ->
  []

:ToolChoiceNone ->
  []

:ToolChoiceTool ->
  []

:ToolResultContent ->
  [content_block: true]

:ToolUseContent ->
  [content_block: true]
```

**Step 2: Update existing configs that changed**

Update these existing entries:

```elixir
# Changed from :nogen to generated:
:CreateMessageRequest ->
  [rpc_request: true]

:CreateMessageRequestParams ->
  [rpc_request_params: true]

:CreateMessageResult ->
  []

:ElicitRequest ->
  [rpc_request: true]

:ElicitResult ->
  []

:EnumSchema ->
  []

:NumberSchema ->
  []

:StringSchema ->
  []
```

**Step 3: Commit**

```bash
git add tools/gen-rpc-schemas.exs
git commit -m "$(cat <<'EOF'
feat: Add entity configurations for 2025-11-25 spec

Includes Tasks, Icons, Elicitation, Sampling tools, and new content types.
EOF
)"
```

---

## Task 4: Update Sub-Schema Swapping

**Files:**
- Modify: `tools/gen-rpc-schemas.exs:523-541` (swap_sub_schemas function)

**Step 1: Add new sub-schema swaps**

The new spec has decoupled params. Add to `swap_sub_schemas/1`:

```elixir
defp swap_sub_schemas(confmap) do
  confmap
  # Existing swaps
  |> swap_sub_schema(:InitializeRequest, [:properties, :params], :InitializeRequestParams)
  |> swap_sub_schema(:CallToolRequest, [:properties, :params], :CallToolRequestParams)
  |> swap_sub_schema(:ListResourcesRequest, [:properties, :params], :ListResourcesRequestParams)
  |> swap_sub_schema(:ListResourceTemplatesRequest, [:properties, :params], :ListResourceTemplatesRequestParams)
  |> swap_sub_schema(:ReadResourceRequest, [:properties, :params], :ReadResourceRequestParams)
  |> swap_sub_schema(:ListPromptsRequest, [:properties, :params], :ListPromptsRequestParams)
  |> swap_sub_schema(:GetPromptRequest, [:properties, :params], :GetPromptRequestParams)
  |> swap_sub_schema(:CancelledNotification, [:properties, :params], :CancelledNotificationParams)
  # New in 2025-11-25
  |> swap_sub_schema(:PingRequest, [:properties, :params], :PingRequestParams)
  |> swap_sub_schema(:CreateMessageRequest, [:properties, :params], :CreateMessageRequestParams)
  |> swap_sub_schema(:ElicitRequest, [:properties, :params], :ElicitRequestParams)
  |> swap_sub_schema(:ListTasksRequest, [:properties, :params], :ListTasksRequestParams)
  |> swap_sub_schema(:GetTaskRequest, [:properties, :params], :GetTaskRequestParams)
  |> swap_sub_schema(:GetTaskPayloadRequest, [:properties, :params], :GetTaskPayloadRequestParams)
  |> swap_sub_schema(:CancelTaskRequest, [:properties, :params], :CancelTaskRequestParams)
end
```

**Step 2: Commit**

```bash
git add tools/gen-rpc-schemas.exs
git commit -m "$(cat <<'EOF'
feat: Add sub-schema swaps for new 2025-11-25 request types
EOF
)"
```

---

## Task 5: Generate New Entities

**Files:**
- Regenerate: `lib/gen_mcp/mcp/entities.ex`

**Step 1: Run the generator**

Run: `just gen-entities`
Expected: Generates new entities.ex with all 2025-11-25 types

**Step 2: Verify compilation**

Run: `mix compile`
Expected: Compiles successfully (may have warnings, that's OK)

**Step 3: Run existing tests**

Run: `mix test --no-start`
Expected: Some tests may fail due to schema changes - note which ones

**Step 4: Commit generated entities**

```bash
git add lib/gen_mcp/mcp/entities.ex
git commit -m "$(cat <<'EOF'
feat: Regenerate entities for MCP 2025-11-25 spec

Generated from official schema with new types for Tasks, Icons,
Elicitation, and Sampling tool support.
EOF
)"
```

---

## Task 6: Update Protocol Version Support

**Files:**
- Modify: `lib/gen_mcp/suite.ex` (find @supported_protocol_versions)

**Step 1: Find and update protocol versions**

Search for `@supported_protocol_versions` and add `"2025-11-25"`:

```elixir
@supported_protocol_versions ["2025-06-18", "2025-11-25"]
```

**Step 2: Verify tests pass**

Run: `mix test --no-start`
Expected: Tests should pass or have specific failures to address

**Step 3: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Add 2025-11-25 to supported protocol versions
EOF
)"
```

---

## Task 7: Enable Subscribe/Unsubscribe in Validator

**Files:**
- Modify: `lib/gen_mcp/validator.ex:10-25`

**Step 1: Enable subscribe requests**

Uncomment and add to validable list:

```elixir
validable = [
  request: [
    GenMCP.MCP.InitializeRequest,
    GenMCP.MCP.PingRequest,  # Enable ping
    GenMCP.MCP.ListResourcesRequest,
    GenMCP.MCP.ListResourceTemplatesRequest,
    GenMCP.MCP.ReadResourceRequest,
    GenMCP.MCP.SubscribeRequest,    # Enable
    GenMCP.MCP.UnsubscribeRequest,  # Enable
    GenMCP.MCP.ListPromptsRequest,
    GenMCP.MCP.GetPromptRequest,
    GenMCP.MCP.ListToolsRequest,
    GenMCP.MCP.CallToolRequest
  ],
  notification: [
    GenMCP.MCP.CancelledNotification,
    GenMCP.MCP.InitializedNotification,
    GenMCP.MCP.ProgressNotification,
    GenMCP.MCP.RootsListChangedNotification
  ]
]
```

**Step 2: Compile and test**

Run: `mix compile && mix test --no-start`
Expected: Compiles, tests pass

**Step 3: Commit**

```bash
git add lib/gen_mcp/validator.ex
git commit -m "$(cat <<'EOF'
feat: Enable Subscribe/Unsubscribe and Ping in validator
EOF
)"
```

---

## Task 8: Add Subscription State to Suite

**Files:**
- Modify: `lib/gen_mcp/suite.ex` (State struct)

**Step 1: Find State struct definition**

Search for `defstruct` in suite.ex and add `subscribed_uris`:

```elixir
defstruct [
  # ... existing fields ...
  subscribed_uris: nil
]
```

**Step 2: Initialize in state creation**

Find where State is initialized and add:

```elixir
subscribed_uris: MapSet.new()
```

**Step 3: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Add subscribed_uris field to Suite state
EOF
)"
```

---

## Task 9: Implement Subscribe/Unsubscribe Handlers

**Files:**
- Modify: `lib/gen_mcp/suite.ex` (add handle_request clauses)

**Step 1: Add Subscribe handler**

Add after other handle_request clauses:

```elixir
def handle_request(%MCP.SubscribeRequest{} = req, _channel, state) do
  uri = req.params.uri
  subscribed_uris = MapSet.put(state.subscribed_uris, uri)
  {:reply, {:result, %MCP.Result{}}, %{state | subscribed_uris: subscribed_uris}}
end
```

**Step 2: Add Unsubscribe handler**

```elixir
def handle_request(%MCP.UnsubscribeRequest{} = req, _channel, state) do
  uri = req.params.uri
  subscribed_uris = MapSet.delete(state.subscribed_uris, uri)
  {:reply, {:result, %MCP.Result{}}, %{state | subscribed_uris: subscribed_uris}}
end
```

**Step 3: Add Ping handler**

```elixir
def handle_request(%MCP.PingRequest{}, _channel, state) do
  {:reply, {:result, %MCP.Result{}}, state}
end
```

**Step 4: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Implement Subscribe, Unsubscribe, and Ping handlers
EOF
)"
```

---

## Task 10: Write Subscription Tests

**Files:**
- Create: `test/gen_mcp/suite_subscription_test.exs`

**Step 1: Write the test file**

```elixir
defmodule GenMCP.SuiteSubscriptionTest do
  use ExUnit.Case, async: true

  alias GenMCP.MCP
  alias GenMCP.Suite

  # Use test helpers from existing test support
  import GenMCP.Test.SuiteHelpers

  describe "subscribe/unsubscribe" do
    test "subscribe adds URI to subscribed set" do
      state = initial_state()
      req = %MCP.SubscribeRequest{
        id: "1",
        params: %{uri: "file:///test.txt"}
      }

      {:reply, {:result, %MCP.Result{}}, new_state} =
        Suite.handle_request(req, test_channel(), state)

      assert MapSet.member?(new_state.subscribed_uris, "file:///test.txt")
    end

    test "unsubscribe removes URI from subscribed set" do
      state = initial_state()
      state = %{state | subscribed_uris: MapSet.new(["file:///test.txt"])}

      req = %MCP.UnsubscribeRequest{
        id: "1",
        params: %{uri: "file:///test.txt"}
      }

      {:reply, {:result, %MCP.Result{}}, new_state} =
        Suite.handle_request(req, test_channel(), state)

      refute MapSet.member?(new_state.subscribed_uris, "file:///test.txt")
    end

    test "subscribe is idempotent" do
      state = initial_state()
      state = %{state | subscribed_uris: MapSet.new(["file:///test.txt"])}

      req = %MCP.SubscribeRequest{
        id: "1",
        params: %{uri: "file:///test.txt"}
      }

      {:reply, {:result, %MCP.Result{}}, new_state} =
        Suite.handle_request(req, test_channel(), state)

      assert MapSet.size(new_state.subscribed_uris) == 1
    end

    test "unsubscribe non-existent URI is no-op" do
      state = initial_state()

      req = %MCP.UnsubscribeRequest{
        id: "1",
        params: %{uri: "file:///nonexistent.txt"}
      }

      {:reply, {:result, %MCP.Result{}}, new_state} =
        Suite.handle_request(req, test_channel(), state)

      assert MapSet.size(new_state.subscribed_uris) == 0
    end
  end

  describe "ping" do
    test "ping returns empty result" do
      state = initial_state()
      req = %MCP.PingRequest{id: "1", params: %{}}

      {:reply, {:result, %MCP.Result{}}, ^state} =
        Suite.handle_request(req, test_channel(), state)
    end
  end
end
```

**Step 2: Create test helpers if needed**

Check if `GenMCP.Test.SuiteHelpers` exists. If not, create minimal helpers:

```elixir
# In test/support/suite_helpers.ex
defmodule GenMCP.Test.SuiteHelpers do
  def initial_state do
    # Return minimal valid Suite state
    %GenMCP.Suite.State{
      subscribed_uris: MapSet.new()
      # ... other required fields
    }
  end

  def test_channel do
    %GenMCP.Mux.Channel{
      session_id: "test-session",
      client: self(),
      status: :stream
    }
  end
end
```

**Step 3: Run tests**

Run: `mix test test/gen_mcp/suite_subscription_test.exs --no-start`
Expected: Tests pass

**Step 4: Commit**

```bash
git add test/gen_mcp/suite_subscription_test.exs test/support/
git commit -m "$(cat <<'EOF'
test: Add subscription and ping handler tests
EOF
)"
```

---

## Task 11: Add notify_resource_updated Public API

**Files:**
- Modify: `lib/gen_mcp.ex`
- Modify: `lib/gen_mcp/suite.ex`
- Modify: `lib/gen_mcp/mux/session.ex`

**Step 1: Add public API function to GenMCP module**

```elixir
@doc """
Notifies subscribed clients that a resource has been updated.

Returns:
- `{:ok, :notified}` - notification sent successfully
- `{:ok, :not_subscribed}` - URI not in subscription set
- `{:ok, :no_listener}` - no active listener channel
- `{:error, {:session_not_found, session_id}}` - invalid session
"""
@spec notify_resource_updated(session_id :: String.t(), uri :: String.t()) ::
      {:ok, :notified | :not_subscribed | :no_listener} |
      {:error, {:session_not_found, String.t()}}
def notify_resource_updated(session_id, uri) do
  Mux.call_session(session_id, {:notify_resource_updated, uri})
end
```

**Step 2: Route in Mux.Session**

Add clause in session's handle_call:

```elixir
def handle_call({:"$gen_mcp", {:notify_resource_updated, uri}}, _from, state) do
  result = state.server_mod.notify_resource_updated(uri, state.server_state)
  {:reply, result, state}
end
```

**Step 3: Implement in Suite**

```elixir
def notify_resource_updated(uri, state) do
  cond do
    uri not in state.subscribed_uris ->
      {:ok, :not_subscribed}

    state.sc_channel.status == :closed ->
      {:ok, :no_listener}

    true ->
      notification = %MCP.ResourceUpdatedNotification{
        method: "notifications/resources/updated",
        params: %{uri: uri}
      }
      send(state.sc_channel.client, {:"$gen_mcp", :notification, notification})
      {:ok, :notified}
  end
end
```

**Step 4: Commit**

```bash
git add lib/gen_mcp.ex lib/gen_mcp/suite.ex lib/gen_mcp/mux/session.ex
git commit -m "$(cat <<'EOF'
feat: Add notify_resource_updated public API
EOF
)"
```

---

## Task 12: Update Capabilities for Subscriptions

**Files:**
- Modify: `lib/gen_mcp/suite.ex` (capabilities function)

**Step 1: Update capabilities to advertise subscribe support**

Find the `capabilities/1` function and update resources capability:

```elixir
defp capabilities(state) do
  base = %{}

  base = if map_size(state.tools_map) > 0 do
    Map.put(base, :tools, %{})
  else
    base
  end

  base = if map_size(state.resource_repos) > 0 do
    Map.put(base, :resources, %{subscribe: true})  # Add subscribe: true
  else
    base
  end

  # ... rest of capabilities
end
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Advertise resource subscription capability
EOF
)"
```

---

## Task 13: Write Notification Tests

**Files:**
- Modify: `test/gen_mcp/suite_subscription_test.exs`

**Step 1: Add notification tests**

```elixir
describe "notify_resource_updated" do
  test "returns {:ok, :notified} when subscribed with listener" do
    state = initial_state()
    state = %{state |
      subscribed_uris: MapSet.new(["file:///test.txt"]),
      sc_channel: %{status: :stream, client: self()}
    }

    assert {:ok, :notified} = Suite.notify_resource_updated("file:///test.txt", state)

    assert_receive {:"$gen_mcp", :notification, %MCP.ResourceUpdatedNotification{
      params: %{uri: "file:///test.txt"}
    }}
  end

  test "returns {:ok, :not_subscribed} when URI not subscribed" do
    state = initial_state()
    state = %{state | sc_channel: %{status: :stream, client: self()}}

    assert {:ok, :not_subscribed} = Suite.notify_resource_updated("file:///other.txt", state)

    refute_receive {:"$gen_mcp", :notification, _}
  end

  test "returns {:ok, :no_listener} when channel closed" do
    state = initial_state()
    state = %{state |
      subscribed_uris: MapSet.new(["file:///test.txt"]),
      sc_channel: %{status: :closed, client: nil}
    }

    assert {:ok, :no_listener} = Suite.notify_resource_updated("file:///test.txt", state)
  end
end
```

**Step 2: Run tests**

Run: `mix test test/gen_mcp/suite_subscription_test.exs --no-start`
Expected: All tests pass

**Step 3: Commit**

```bash
git add test/gen_mcp/suite_subscription_test.exs
git commit -m "$(cat <<'EOF'
test: Add resource notification tests
EOF
)"
```

---

## Task 14: Create TaskStore Behaviour

**Files:**
- Create: `lib/gen_mcp/suite/task_store.ex`

**Step 1: Write the behaviour module**

```elixir
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
          # Initialize Redis connection
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

  @doc "Initialize the task store with configuration options."
  @callback init(opts :: keyword()) :: {:ok, state()} | {:error, term()}

  @doc "Create a new task."
  @callback create(session_id(), task_id(), metadata :: map(), state()) ::
              {:ok, task(), state()} | {:error, term()}

  @doc "Get a task by ID."
  @callback get(task_id(), state()) ::
              {:ok, task(), state()} | {:error, :not_found}

  @doc "Update task fields."
  @callback update(task_id(), updates :: map(), state()) ::
              {:ok, task(), state()} | {:error, :not_found | term()}

  @doc "Delete a task."
  @callback delete(task_id(), state()) :: {:ok, state()} | {:error, term()}

  @doc "List all tasks for a session."
  @callback list(session_id(), state()) :: {:ok, [task()], state()}
end
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/suite/task_store.ex
git commit -m "$(cat <<'EOF'
feat: Add TaskStore behaviour for durable task tracking
EOF
)"
```

---

## Task 15: Implement ETS TaskStore

**Files:**
- Create: `lib/gen_mcp/suite/task_store/ets.ex`

**Step 1: Write the ETS implementation**

```elixir
defmodule GenMCP.Suite.TaskStore.ETS do
  @moduledoc """
  Default ETS-based TaskStore implementation.

  Tasks are stored in an ETS table with configurable TTL.
  A periodic cleanup process removes expired tasks.

  ## Options

  - `:ttl` - Time-to-live for tasks in milliseconds (default: 1 hour)
  - `:cleanup_interval` - Interval between cleanup runs (default: 5 minutes)
  """

  @behaviour GenMCP.Suite.TaskStore

  @default_ttl :timer.hours(1)
  @default_cleanup_interval :timer.minutes(5)

  @impl true
  def init(opts) do
    ttl = Keyword.get(opts, :ttl, @default_ttl)
    cleanup_interval = Keyword.get(opts, :cleanup_interval, @default_cleanup_interval)

    table = :ets.new(__MODULE__, [:set, :public, read_concurrency: true])

    # Schedule periodic cleanup
    if cleanup_interval > 0 do
      Process.send_after(self(), {:task_store_cleanup, table, ttl}, cleanup_interval)
    end

    {:ok, %{table: table, ttl: ttl, cleanup_interval: cleanup_interval}}
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
          if task.session_id == session_id, do: [task | acc], else: acc
        end,
        [],
        state.table
      )

    {:ok, tasks, state}
  end

  @doc false
  def handle_cleanup(table, ttl) do
    now = DateTime.utc_now()
    cutoff = DateTime.add(now, -ttl, :millisecond)

    :ets.foldl(
      fn {id, task}, acc ->
        if DateTime.compare(task.updated_at, cutoff) == :lt do
          :ets.delete(table, id)
        end
        acc
      end,
      nil,
      table
    )

    :ok
  end
end
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/suite/task_store/ets.ex
git commit -m "$(cat <<'EOF'
feat: Add ETS-based TaskStore implementation
EOF
)"
```

---

## Task 16: Write TaskStore Tests

**Files:**
- Create: `test/gen_mcp/task_store/ets_test.exs`

**Step 1: Write tests**

```elixir
defmodule GenMCP.Suite.TaskStore.ETSTest do
  use ExUnit.Case, async: true

  alias GenMCP.Suite.TaskStore.ETS

  setup do
    {:ok, state} = ETS.init(ttl: :timer.hours(1), cleanup_interval: 0)
    {:ok, state: state}
  end

  describe "create/4" do
    test "creates a task with pending status", %{state: state} do
      {:ok, task, _state} = ETS.create("session-1", "task-1", %{foo: "bar"}, state)

      assert task.id == "task-1"
      assert task.session_id == "session-1"
      assert task.status == :pending
      assert task.metadata == %{foo: "bar"}
      assert task.result == nil
      assert task.error == nil
    end
  end

  describe "get/2" do
    test "returns task if exists", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)
      {:ok, task, _state} = ETS.get("task-1", state)

      assert task.id == "task-1"
    end

    test "returns error if not found", %{state: state} do
      assert {:error, :not_found} = ETS.get("nonexistent", state)
    end
  end

  describe "update/3" do
    test "updates task fields", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)

      {:ok, task, _state} = ETS.update("task-1", %{status: :completed, result: "done"}, state)

      assert task.status == :completed
      assert task.result == "done"
    end

    test "returns error if not found", %{state: state} do
      assert {:error, :not_found} = ETS.update("nonexistent", %{}, state)
    end
  end

  describe "delete/2" do
    test "removes task", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)
      {:ok, state} = ETS.delete("task-1", state)

      assert {:error, :not_found} = ETS.get("task-1", state)
    end
  end

  describe "list/2" do
    test "returns tasks for session", %{state: state} do
      {:ok, _task, state} = ETS.create("session-1", "task-1", %{}, state)
      {:ok, _task, state} = ETS.create("session-1", "task-2", %{}, state)
      {:ok, _task, state} = ETS.create("session-2", "task-3", %{}, state)

      {:ok, tasks, _state} = ETS.list("session-1", state)

      assert length(tasks) == 2
      assert Enum.all?(tasks, &(&1.session_id == "session-1"))
    end
  end
end
```

**Step 2: Run tests**

Run: `mix test test/gen_mcp/task_store/ets_test.exs --no-start`
Expected: All tests pass

**Step 3: Commit**

```bash
git add test/gen_mcp/task_store/ets_test.exs
git commit -m "$(cat <<'EOF'
test: Add ETS TaskStore tests
EOF
)"
```

---

## Task 17: Enable Task Requests in Validator

**Files:**
- Modify: `lib/gen_mcp/validator.ex`

**Step 1: Add task-related requests to validable list**

```elixir
validable = [
  request: [
    # ... existing requests ...
    GenMCP.MCP.ListTasksRequest,
    GenMCP.MCP.GetTaskRequest,
    GenMCP.MCP.GetTaskPayloadRequest,
    GenMCP.MCP.CancelTaskRequest
  ],
  notification: [
    # ... existing notifications ...
  ]
]
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/validator.ex
git commit -m "$(cat <<'EOF'
feat: Enable Task requests in validator
EOF
)"
```

---

## Task 18: Integrate TaskStore into Suite

**Files:**
- Modify: `lib/gen_mcp/suite.ex`

**Step 1: Add task_store to Suite options**

Find the NimbleOptions schema and add:

```elixir
task_store: [
  type: {:tuple, [:atom, :keyword_list]},
  default: {GenMCP.Suite.TaskStore.ETS, []},
  doc: "Task store module and options for durable task tracking"
]
```

**Step 2: Add task_store_state to State struct**

```elixir
defstruct [
  # ... existing fields ...
  task_store: nil,
  task_store_state: nil
]
```

**Step 3: Initialize task store in init**

```elixir
{task_store_mod, task_store_opts} = opts[:task_store]
{:ok, task_store_state} = task_store_mod.init(task_store_opts)

%State{
  # ... existing fields ...
  task_store: task_store_mod,
  task_store_state: task_store_state
}
```

**Step 4: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Integrate TaskStore into Suite initialization
EOF
)"
```

---

## Task 19: Implement Task Request Handlers

**Files:**
- Modify: `lib/gen_mcp/suite.ex`

**Step 1: Add ListTasksRequest handler**

```elixir
def handle_request(%MCP.ListTasksRequest{}, channel, state) do
  {:ok, tasks, task_store_state} =
    state.task_store.list(channel.session_id, state.task_store_state)

  result = %MCP.ListTasksResult{
    tasks: Enum.map(tasks, &task_to_mcp/1)
  }

  {:reply, {:result, result}, %{state | task_store_state: task_store_state}}
end
```

**Step 2: Add GetTaskRequest handler**

```elixir
def handle_request(%MCP.GetTaskRequest{} = req, _channel, state) do
  case state.task_store.get(req.params.id, state.task_store_state) do
    {:ok, task, task_store_state} ->
      result = %MCP.GetTaskResult{task: task_to_mcp(task)}
      {:reply, {:result, result}, %{state | task_store_state: task_store_state}}

    {:error, :not_found} ->
      {:reply, {:error, :invalid_params, "Task not found"}, state}
  end
end
```

**Step 3: Add CancelTaskRequest handler**

```elixir
def handle_request(%MCP.CancelTaskRequest{} = req, _channel, state) do
  case state.task_store.update(req.params.id, %{status: :cancelled}, state.task_store_state) do
    {:ok, _task, task_store_state} ->
      {:reply, {:result, %MCP.CancelTaskResult{}}, %{state | task_store_state: task_store_state}}

    {:error, :not_found} ->
      {:reply, {:error, :invalid_params, "Task not found"}, state}
  end
end
```

**Step 4: Add helper function**

```elixir
defp task_to_mcp(task) do
  %MCP.Task{
    id: task.id,
    status: task.status,
    metadata: task.metadata
  }
end
```

**Step 5: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Implement Task request handlers
EOF
)"
```

---

## Task 20: Add complete_task Public API

**Files:**
- Modify: `lib/gen_mcp.ex`
- Modify: `lib/gen_mcp/suite.ex`
- Modify: `lib/gen_mcp/mux/session.ex`

**Step 1: Add public API function**

In `lib/gen_mcp.ex`:

```elixir
@doc """
Completes a task with a result or error.

Called by async tools when work is done.
"""
@spec complete_task(session_id :: String.t(), task_id :: String.t(), outcome :: {:ok, term()} | {:error, term()}) ::
      :ok | {:error, term()}
def complete_task(session_id, task_id, outcome) do
  Mux.call_session(session_id, {:complete_task, task_id, outcome})
end
```

**Step 2: Route in Session**

```elixir
def handle_call({:"$gen_mcp", {:complete_task, task_id, outcome}}, _from, state) do
  result = state.server_mod.complete_task(task_id, outcome, state.server_state)
  {:reply, result, state}
end
```

**Step 3: Implement in Suite**

```elixir
def complete_task(task_id, outcome, state) do
  updates = case outcome do
    {:ok, result} -> %{status: :completed, result: result}
    {:error, error} -> %{status: :failed, error: error}
  end

  case state.task_store.update(task_id, updates, state.task_store_state) do
    {:ok, task, _task_store_state} ->
      # Send notification if listener active
      if state.sc_channel.status == :stream do
        notification = %MCP.TaskStatusNotification{
          method: "notifications/tasks/status",
          params: %{id: task.id, status: task.status}
        }
        send(state.sc_channel.client, {:"$gen_mcp", :notification, notification})
      end
      :ok

    {:error, reason} ->
      {:error, reason}
  end
end
```

**Step 4: Commit**

```bash
git add lib/gen_mcp.ex lib/gen_mcp/suite.ex lib/gen_mcp/mux/session.ex
git commit -m "$(cat <<'EOF'
feat: Add complete_task public API
EOF
)"
```

---

## Task 21: Update Capabilities for Tasks

**Files:**
- Modify: `lib/gen_mcp/suite.ex`

**Step 1: Add tasks to capabilities**

```elixir
defp capabilities(state) do
  base = %{}

  # ... existing capability checks ...

  # Add tasks capability if task store is configured
  base = if state.task_store do
    Map.put(base, :tasks, %{supported: true})
  else
    base
  end

  base
end
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Advertise tasks capability
EOF
)"
```

---

## Task 22: Write Task Handler Tests

**Files:**
- Create: `test/gen_mcp/suite_tasks_test.exs`

**Step 1: Write tests**

```elixir
defmodule GenMCP.SuiteTasksTest do
  use ExUnit.Case, async: true

  alias GenMCP.MCP
  alias GenMCP.Suite

  import GenMCP.Test.SuiteHelpers

  describe "task handlers" do
    test "list_tasks returns tasks for session" do
      state = initial_state_with_tasks()
      req = %MCP.ListTasksRequest{id: "1", params: %{}}

      {:reply, {:result, %MCP.ListTasksResult{tasks: tasks}}, _state} =
        Suite.handle_request(req, test_channel(), state)

      assert is_list(tasks)
    end

    test "get_task returns task by id" do
      state = initial_state_with_tasks()
      # First create a task
      {:ok, task, task_store_state} =
        state.task_store.create("test-session", "task-1", %{}, state.task_store_state)
      state = %{state | task_store_state: task_store_state}

      req = %MCP.GetTaskRequest{id: "1", params: %{id: "task-1"}}

      {:reply, {:result, %MCP.GetTaskResult{task: mcp_task}}, _state} =
        Suite.handle_request(req, test_channel(), state)

      assert mcp_task.id == "task-1"
    end

    test "get_task returns error for unknown task" do
      state = initial_state_with_tasks()
      req = %MCP.GetTaskRequest{id: "1", params: %{id: "unknown"}}

      {:reply, {:error, :invalid_params, _msg}, _state} =
        Suite.handle_request(req, test_channel(), state)
    end

    test "cancel_task updates task status" do
      state = initial_state_with_tasks()
      {:ok, _task, task_store_state} =
        state.task_store.create("test-session", "task-1", %{}, state.task_store_state)
      state = %{state | task_store_state: task_store_state}

      req = %MCP.CancelTaskRequest{id: "1", params: %{id: "task-1"}}

      {:reply, {:result, %MCP.CancelTaskResult{}}, state} =
        Suite.handle_request(req, test_channel(), state)

      {:ok, task, _} = state.task_store.get("task-1", state.task_store_state)
      assert task.status == :cancelled
    end
  end

  describe "complete_task" do
    test "marks task as completed with result" do
      state = initial_state_with_tasks()
      {:ok, _task, task_store_state} =
        state.task_store.create("test-session", "task-1", %{}, state.task_store_state)
      state = %{state | task_store_state: task_store_state}

      assert :ok = Suite.complete_task("task-1", {:ok, "result"}, state)
    end

    test "marks task as failed with error" do
      state = initial_state_with_tasks()
      {:ok, _task, task_store_state} =
        state.task_store.create("test-session", "task-1", %{}, state.task_store_state)
      state = %{state | task_store_state: task_store_state}

      assert :ok = Suite.complete_task("task-1", {:error, "failed"}, state)
    end
  end
end
```

**Step 2: Run tests**

Run: `mix test test/gen_mcp/suite_tasks_test.exs --no-start`
Expected: Tests pass

**Step 3: Commit**

```bash
git add test/gen_mcp/suite_tasks_test.exs
git commit -m "$(cat <<'EOF'
test: Add Task handler tests
EOF
)"
```

---

## Task 23: Enable Elicitation in Validator

**Files:**
- Modify: `lib/gen_mcp/validator.ex`

**Step 1: Add elicitation request to validable**

```elixir
validable = [
  request: [
    # ... existing requests ...
    GenMCP.MCP.ElicitRequest
  ],
  notification: [
    # ... existing ...
    GenMCP.MCP.ElicitationCompleteNotification
  ]
]
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/validator.ex
git commit -m "$(cat <<'EOF'
feat: Enable ElicitRequest in validator
EOF
)"
```

---

## Task 24: Add elicit Public API

**Files:**
- Modify: `lib/gen_mcp.ex`
- Modify: `lib/gen_mcp/suite.ex`

**Step 1: Add elicit function to GenMCP**

```elixir
@doc """
Requests user input from the client via elicitation.

The client must support elicitation (check client_capabilities.elicitation).

## Parameters

- `channel` - The channel to send the request on
- `params` - Elicitation parameters including message and requestedSchema

## Returns

- `{:ok, %ElicitResult{}}` - User response
- `{:error, :not_supported}` - Client doesn't support elicitation
- `{:error, reason}` - Other error
"""
@spec elicit(channel :: Mux.Channel.t(), params :: map()) ::
      {:ok, MCP.ElicitResult.t()} | {:error, term()}
def elicit(channel, params) do
  Suite.elicit(channel, params)
end
```

**Step 2: Implement in Suite**

```elixir
def elicit(channel, params) do
  # Check if client supports elicitation
  # This would need access to client capabilities from state
  # For now, send the request and let client handle unsupported case

  request = %MCP.ElicitRequest{
    id: generate_request_id(),
    method: "elicit",
    params: params
  }

  # Send request and await response
  # This requires a request/response correlation mechanism
  send_request_and_await(channel, request)
end

defp generate_request_id do
  :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)
end
```

**Step 3: Commit**

```bash
git add lib/gen_mcp.ex lib/gen_mcp/suite.ex
git commit -m "$(cat <<'EOF'
feat: Add elicit public API for user input requests
EOF
)"
```

---

## Task 25: Enable Sampling in Validator

**Files:**
- Modify: `lib/gen_mcp/validator.ex`

**Step 1: Add CreateMessageRequest to validable**

```elixir
validable = [
  request: [
    # ... existing requests ...
    GenMCP.MCP.CreateMessageRequest
  ],
  # ...
]
```

**Step 2: Commit**

```bash
git add lib/gen_mcp/validator.ex
git commit -m "$(cat <<'EOF'
feat: Enable CreateMessageRequest (sampling) in validator
EOF
)"
```

---

## Task 26: Run Full Test Suite

**Files:** None (verification step)

**Step 1: Run all tests**

Run: `mix test --no-start`
Expected: All tests pass

**Step 2: Run static analysis**

Run: `mix dialyzer`
Expected: No errors (warnings OK)

**Step 3: Run credo**

Run: `mix credo`
Expected: No errors

**Step 4: If all pass, commit any fixes**

```bash
git add -A
git commit -m "$(cat <<'EOF'
fix: Address test and static analysis issues
EOF
)"
```

---

## Task 27: Update Documentation

**Files:**
- Modify: `guides/002.using-mcp-suite.md`

**Step 1: Document new features**

Add sections for:
- Resource subscriptions
- Tasks
- Elicitation
- New capabilities

**Step 2: Commit**

```bash
git add guides/
git commit -m "$(cat <<'EOF'
docs: Document 2025-11-25 features

- Resource subscriptions
- Tasks (experimental)
- Elicitation support
- Sampling with tools
EOF
)"
```

---

## Task 28: Integration Test

**Files:**
- Modify: `test/gen_mcp/streamable_http_test.exs`

**Step 1: Add integration test for subscription flow**

```elixir
describe "resource subscriptions" do
  test "full subscribe -> notify -> receive flow" do
    # Initialize session
    # Subscribe to resource
    # Trigger notification
    # Verify SSE event received
  end
end
```

**Step 2: Add integration test for tasks flow**

```elixir
describe "tasks" do
  test "full create -> poll -> complete flow" do
    # Start task-enabled request
    # Poll task status
    # Complete task
    # Verify result
  end
end
```

**Step 3: Run integration tests**

Run: `mix test test/gen_mcp/streamable_http_test.exs --no-start`
Expected: All tests pass

**Step 4: Commit**

```bash
git add test/gen_mcp/streamable_http_test.exs
git commit -m "$(cat <<'EOF'
test: Add integration tests for subscriptions and tasks
EOF
)"
```

---

## Task 29: Final Verification

**Step 1: Run full check suite**

Run: `just check`
Expected: All checks pass

**Step 2: Verify git status is clean**

Run: `git status`
Expected: Clean working tree

**Step 3: Review all commits**

Run: `git log --oneline feature/mcp-2025-11-25-upgrade`
Expected: Clear commit history showing incremental progress

---

## Summary

This plan implements:

1. **Schema update** (Tasks 1-6) - Update to 2025-11-25 spec
2. **Resource subscriptions** (Tasks 7-13) - Subscribe/unsubscribe handlers and notifications
3. **Tasks** (Tasks 14-22) - TaskStore behaviour, ETS implementation, handlers
4. **Elicitation** (Tasks 23-24) - Enable elicit API
5. **Sampling** (Task 25) - Enable CreateMessageRequest with tools
6. **Testing & docs** (Tasks 26-29) - Full test coverage and documentation

Each task is atomic and commits independently. Tests are written before or alongside implementation.
