defmodule GenMCP do
  @moduledoc """
  The main behaviour for MCP servers.

  Implement this behaviour to create a custom MCP server. If you are looking for a high-level framework to build tools and resources, see `GenMCP.Suite`.

  ## Example

      defmodule MyServer do
        @behaviour GenMCP

        alias GenMCP.MCP

        @impl true
        def init(_session_id, _opts) do
          {:ok, %{}}
        end

        @impl true
        def handle_request(%MCP.InitializeRequest{} = req, _channel, state) do
          # Protocol version check omitted for brevity
          result = MCP.intialize_result(
            capabilities: MCP.capabilities(tools: true),
            server_info: MCP.server_info(name: "My Server", version: "1.0.0")
          )
          {:reply, {:result, result}, state}
        end

        def handle_request(%MCP.ListToolsRequest{}, _channel, state) do
          result = MCP.list_tools_result([
            %MCP.Tool{
              name: "hello",
              description: "Say hello",
              inputSchema: %{
                type: "object",
                properties: %{
                  name: %{type: "string"}
                }
              }
            }
          ])
          {:reply, {:result, result}, state}
        end

        @impl true
        def handle_notification(%MCP.InitializedNotification{}, state) do
          {:noreply, state}
        end

        def handle_notification(_notif, state) do
          {:noreply, state}
        end

        @impl true
        def handle_info(_msg, state) do
          {:noreply, state}
        end
      end
  """

  alias GenMCP.MCP
  alias GenMCP.MCP.ModMap
  alias GenMCP.Mux.Channel
  alias GenMCP.Suite.SessionController

  require ModMap

  ModMap.require_all()

  @doc """
  Returns the supported protocol versions.
  """
  def supported_protocol_versions do
    ["2025-06-18", "2025-11-25"]
  end

  @type state :: term
  @type session_id :: String.t()
  @type request ::
          MCP.InitializeRequest.t()
          | MCP.ListToolsRequest.t()
          | MCP.CallToolRequest.t()
          | MCP.ListResourcesRequest.t()
          | MCP.ReadResourceRequest.t()
          | MCP.ListResourceTemplatesRequest.t()
          | MCP.ListPromptsRequest.t()
          | MCP.GetPromptRequest.t()
          | MCP.PingRequest.t()

  @type result ::
          MCP.InitializeResult.t()
          | MCP.ListToolsResult.t()
          | MCP.CallToolResult.t()
          | MCP.ListResourcesResult.t()
          | MCP.ReadResourceResult.t()
          | MCP.ListResourceTemplatesResult.t()
          | MCP.ListPromptsResult.t()
          | MCP.GetPromptResult.t()

  @type notification ::
          MCP.InitializedNotification.t()
          | MCP.CancelledNotification.t()
          | MCP.RootsListChangedNotification.t()
          | MCP.ProgressNotification.t()

  @type server_reply :: {:result, result} | :stream | {:error, term}
  @type server_reply_nostream :: {:result, result} | :stream | {:error, term}

  @doc """
  Initializes the server state.

  Called when a new MCP session is established.
  """
  @callback init(session_id, init_arg :: term) :: {:ok, state} | {:stop, term}

  @doc """
  Handles an incoming MCP request and returns a result or stop the server.
  """
  @callback handle_request(request, Channel.t(), state) ::
              {:reply, server_reply, state}
              | {:stop, reason :: term, server_reply_nostream, state}

  @doc """
  Handles an incoming MCP notification.

  Notifications are one-way messages that do not expect a response.
  """
  @callback handle_notification(notification, state) :: {:noreply, state}

  @doc """
  Handles process messages.

  Invoked when the server process receives a message that is not an MCP request
  or notification.
  """
  @callback handle_info(term, state) :: {:noreply, state} | {:stop, reason :: term, state}

  @doc """
  This callback is called during session initialization when a
  non-initialization request (such as a call tool request) is received and there
  is no current OTP process tied to the session id.

  > #### This is a raw callback {: .warning}
  >
  > The call is made from the HTTP transport process, giving raw initialization
  > args for the server. It is called _before_ the `c:init/2` callback is called
  > and there is no possibility to return a new state or arg.
  >
  > The returned data will be passed to the `c:session_restore/3` callback after
  > server process initialization.
  """
  @callback session_fetch(session_id, channel :: Channel.t(), init_arg :: term) ::
              {:ok, SessionController.restore_data()} | {:error, :not_found}

  @doc """
  Called when a session is restored by the `GenMCP.Suite.SessionController`
  implementation.

  Your server `c:init/2` callback will have been called before, but there will
  be no call of `c:handle_request/3` with an initialization request.

  The next call will be either another request or a notification.
  """
  @callback session_restore(SessionController.restore_data(), channel :: Channel.t(), state) ::
              {:noreply, state} | {:stop, reason :: term, state}

  @doc """
  Called when a session is deleted by the client.

  Return value is not checked, and the server is shut down immediately.
  """
  @callback session_delete(state) :: term

  @doc """
  Called when a session times out.
  """
  @callback session_timeout(state) :: term

  @optional_callbacks session_restore: 3, session_delete: 1, session_timeout: 1

  @doc """
  The gen_mcp application uses telemetry events to publish various application
  lifecycle events. This can be used to log only what is important to you.

  The telemetry logger will log all telemetry events by default, at various log
  levels (debug, info, warning, error , _etc._).

  Two filters are supported:

  * `:min_log_level` - For instance if `:error` is given, the default logger
    will not log events for which it uses the lower levels. This allows you to
    still have logs for errors, without cluttering info and debug logs.
  * `:prefixes` - A list of event prefixes (which are a list too) to match. The
    logger will only log events whose prefixes match one of the the given
    prefixes. For instance, `[[:gen_mcp, :cluster], [:gen_mcp, :session]]` will
    only log events related to the cluster and sessions.

  Both filters are compatible.

  See `GenMCP.TelemetryLogger` for a list of all emitted events.
  """
  def attach_default_logger(filters \\ []) do
    GenMCP.TelemetryLogger.attach(filters)
  end

  @doc """
  Notifies subscribed clients that a resource has been updated.

  This function should be called when a resource that clients may have subscribed
  to has changed. The server will send a `notifications/resources/updated`
  notification to the client if:

  1. The URI is in the client's subscribed set
  2. The session has an active listener (channel is not closed)

  ## Parameters

  - `session_id` - The session identifier
  - `uri` - The URI of the resource that was updated

  ## Returns

  - `{:ok, :notified}` - The notification was sent successfully
  - `{:ok, :not_subscribed}` - The URI is not in the client's subscribed set
  - `{:ok, :no_listener}` - The session's channel is closed
  - `{:error, {:session_not_found, session_id}}` - The session does not exist
  """
  @spec notify_resource_updated(session_id :: String.t(), uri :: String.t()) ::
          {:ok, :notified | :not_subscribed | :no_listener}
          | {:error, {:session_not_found, String.t()}}
  def notify_resource_updated(session_id, uri) do
    GenMCP.Mux.call_session(session_id, {:notify_resource_updated, uri})
  end

  @doc """
  Pushes a channel event to a connected MCP client.

  Channel events use the `notifications/claude/channel` method from the
  experimental Claude Code channels protocol. Unlike resource notifications,
  channel events do not require the client to subscribe — they are pushed
  unconditionally to any session with an active listener.

  The event arrives in the client as a `<channel source="server-name" ...>` tag
  where `content` becomes the tag body and each `meta` entry becomes a tag
  attribute.

  ## Parameters

  - `session_id` - The session identifier
  - `content` - The event body (string)
  - `meta` - Optional metadata map. Each key/value becomes an attribute on
    the `<channel>` tag. Keys must be identifiers (letters, digits, underscores).

  ## Returns

  - `{:ok, :notified}` - The notification was sent successfully
  - `{:ok, :no_listener}` - The session's channel is closed
  - `{:error, {:session_not_found, session_id}}` - The session does not exist
  """
  @spec notify_channel(session_id :: String.t(), content :: String.t(), meta :: map()) ::
          {:ok, :notified | :no_listener}
          | {:error, {:session_not_found, String.t()}}
  def notify_channel(session_id, content, meta \\ %{}) do
    GenMCP.Mux.call_session(session_id, {:notify_channel, content, meta})
  end

  @doc """
  Completes a task with a result or error.

  This function is used to mark a task as completed (with a result) or failed
  (with an error). The task must have been previously created in the task store.

  ## Parameters

  - `session_id` - The session identifier
  - `task_id` - The task identifier to complete
  - `outcome` - Either `{:ok, result}` to mark as completed, or `{:error, reason}` to mark as failed

  ## Returns

  - `:ok` - The task was successfully completed/failed
  - `{:error, :not_found}` - The task does not exist
  - `{:error, :no_task_store}` - No task store is configured for this session
  - `{:error, {:session_not_found, session_id}}` - The session does not exist
  """
  @spec complete_task(
          session_id :: String.t(),
          task_id :: String.t(),
          outcome :: {:ok, term()} | {:error, term()}
        ) ::
          :ok | {:error, term()}
  def complete_task(session_id, task_id, outcome) do
    GenMCP.Mux.call_session(session_id, {:complete_task, task_id, outcome})
  end

  @doc """
  Requests user input from the client via elicitation.

  The client must support elicitation (check client_capabilities.elicitation).
  This is a server-to-client request - the server asks the client to prompt
  the user for information.

  ## Parameters

  - `channel` - The channel to send the request on
  - `params` - Elicitation parameters. Can be either:
    - Form params: `%{mode: "form", message: "...", requestedSchema: %{...}}`
    - URL params: `%{mode: "url", url: "https://...", message: "..."}`

  ## Returns

  - `{:ok, %ElicitResult{}}` - User response
  - `{:error, :not_supported}` - Client doesn't support elicitation
  - `{:error, :timeout}` - Request timed out
  - `{:error, reason}` - Other error

  ## Example

      case GenMCP.elicit(channel, %{
        mode: "form",
        message: "Please enter your API key",
        requestedSchema: %{
          type: "object",
          properties: %{
            api_key: %{type: "string", title: "API Key"}
          }
        }
      }) do
        {:ok, %{action: :accept, content: content}} ->
          # Use the input
        {:ok, %{action: :decline}} ->
          {:error, "User declined"}
        {:error, reason} ->
          {:error, reason}
      end
  """
  @spec elicit(channel :: Channel.t(), params :: map()) ::
          {:ok, MCP.ElicitResult.t()} | {:error, term()}
  def elicit(channel, params) do
    GenMCP.Suite.elicit(channel, params)
  end

  @doc """
  Returns the session ID of the current process, or `nil` if the calling
  process is not a session.

  This is useful inside `c:GenMCP.Suite.SessionController` callbacks
  (e.g. `handle_info/3`) or any code running inside the session process where
  the session ID was not explicitly passed.
  """
  @spec current_session_id() :: String.t() | nil
  def current_session_id do
    case Registry.keys(GenMCP.Mux.registry(), self()) do
      [session_id] -> session_id
      _ -> nil
    end
  end
end
