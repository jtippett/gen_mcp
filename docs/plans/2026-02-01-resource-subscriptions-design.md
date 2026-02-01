# Resource Subscriptions Design

## Overview

Implement MCP resource subscriptions per the [2025-11-25 spec](https://modelcontextprotocol.io/specification/2025-11-25/server/resources). Clients can subscribe to resource URIs and receive `notifications/resources/updated` when resources change.

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Trigger mechanism | Application calls `GenMCP.notify_resource_updated/2` | Explicit, matches project style, no magic |
| Subscription state | In Suite's State struct | Matches `trackers` pattern, session-scoped |
| Session identification | By session_id | Matches `Mux.request/3` pattern |
| No listener behavior | Drop silently | Fire-and-forget, matches `Channel.send_progress/4` |
| URI matching | Exact match only | Simpler, spec-compliant |

## Implementation

### 1. New Notification Entity

`lib/gen_mcp/mcp/entities.ex`:

```elixir
defmodule GenMCP.MCP.ResourceUpdatedNotification do
  use JSV.Schema

  defschema %{
    description: "Notification that a subscribed resource has changed.",
    properties: %{
      method: const("notifications/resources/updated"),
      params: %{
        properties: %{
          uri: uri(description: "The URI of the resource that changed.")
        },
        required: ["uri"],
        type: "object"
      }
    },
    required: [:method, :params],
    title: "MCP:ResourceUpdatedNotification",
    type: "object"
  }
end
```

### 2. Enable Validation

`lib/gen_mcp/validator.ex` - uncomment lines 17-18:

```elixir
GenMCP.MCP.SubscribeRequest,
GenMCP.MCP.UnsubscribeRequest,
```

### 3. Suite State

Add `subscribed_uris` field to State struct, initialized as `MapSet.new()`.

### 4. Request Handlers

`lib/gen_mcp/suite.ex`:

```elixir
def handle_request(%MCP.SubscribeRequest{} = req, _channel, state) do
  uri = req.params.uri
  subscribed_uris = MapSet.put(state.subscribed_uris, uri)
  {:reply, {:result, %MCP.Result{}}, %{state | subscribed_uris: subscribed_uris}}
end

def handle_request(%MCP.UnsubscribeRequest{} = req, _channel, state) do
  uri = req.params.uri
  subscribed_uris = MapSet.delete(state.subscribed_uris, uri)
  {:reply, {:result, %MCP.Result{}}, %{state | subscribed_uris: subscribed_uris}}
end
```

### 5. Public API

`lib/gen_mcp.ex`:

```elixir
@spec notify_resource_updated(session_id :: String.t(), uri :: String.t()) ::
        {:ok, :notified | :not_subscribed | :no_listener}
        | {:error, {:session_not_found, String.t()}}
def notify_resource_updated(session_id, uri)
```

Routes through `Mux.call_session/3` → `Session.handle_call/3` → `Suite.notify_resource_updated/2`.

### 6. Notification Logic

`lib/gen_mcp/suite.ex`:

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

### 7. Capabilities

Update `capabilities/1` to advertise `resources: %{subscribe: true}` when resources are available.

## Files Changed

| File | Action |
|------|--------|
| `lib/gen_mcp/mcp/entities.ex` | Add `ResourceUpdatedNotification` |
| `lib/gen_mcp/validator.ex` | Uncomment subscribe/unsubscribe |
| `lib/gen_mcp/suite.ex` | State field, handlers, notification logic, capabilities |
| `lib/gen_mcp/mux/session.ex` | Route notify call |
| `lib/gen_mcp.ex` | Public API function |
| `test/gen_mcp/suite_test.exs` | Unit tests for handlers |
| `test/gen_mcp/suite_subscription_test.exs` | New file for notification tests |
| `test/gen_mcp/streamable_http_test.exs` | Integration test |

## Testing

**Unit tests:**
- Subscribe adds URI to set
- Unsubscribe removes URI
- Duplicate subscribe is idempotent
- Unsubscribe non-existent URI is no-op

**Notification tests:**
- Returns `{:ok, :notified}` when subscribed with listener
- Returns `{:ok, :not_subscribed}` when not subscribed
- Returns `{:ok, :no_listener}` when listener closed
- Returns `{:error, {:session_not_found, _}}` for invalid session

**Integration test:**
- Full flow: initialize → subscribe → trigger → verify SSE event
