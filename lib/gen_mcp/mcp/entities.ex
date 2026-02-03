require GenMCP.JsonDerive, as: JsonDerive

defmodule GenMCP.MCP.Meta do
  use JSV.Schema

  def json_schema do
    %{
      additionalProperties: %{},
      description:
        "See [General Fields](https://modelcontextprotocol.io/specification/2025-11-25/basic#general-fields) for notes on _meta usage.",
      properties: %{progressToken: GenMCP.MCP.ProgressToken},
      type: "object"
    }
  end
end

defmodule GenMCP.MCP.RequestMeta do
  use JSV.Schema

  def json_schema do
    %{
      additionalProperties: %{},
      description:
        "See [General Fields](https://modelcontextprotocol.io/specification/2025-11-25/basic#general-fields) for notes on _meta usage.",
      properties: %{progressToken: GenMCP.MCP.ProgressToken},
      type: "object"
    }
  end
end

defmodule GenMCP.MCP.ListenerRequest do
  @moduledoc """
  Represents a GET request from the StreamableHTTP client.
  """

  defstruct []
  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ModMap do
  defmacro require_all do
    Enum.map(json_schema().definitions, fn {_, mod} ->
      quote do
        require unquote(mod)
      end
    end)
  end

  def json_schema do
    %{
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      definitions: %{
        "Annotations" => GenMCP.MCP.Annotations,
        "AudioContent" => GenMCP.MCP.AudioContent,
        "BlobResourceContents" => GenMCP.MCP.BlobResourceContents,
        "BooleanSchema" => GenMCP.MCP.BooleanSchema,
        "CallToolRequest" => GenMCP.MCP.CallToolRequest,
        "CallToolRequestParams" => GenMCP.MCP.CallToolRequestParams,
        "CallToolResult" => GenMCP.MCP.CallToolResult,
        "CancelTaskRequest" => GenMCP.MCP.CancelTaskRequest,
        "CancelTaskResult" => GenMCP.MCP.CancelTaskResult,
        "CancelledNotification" => GenMCP.MCP.CancelledNotification,
        "CancelledNotificationParams" => GenMCP.MCP.CancelledNotificationParams,
        "ClientCapabilities" => GenMCP.MCP.ClientCapabilities,
        "ContentBlock" => GenMCP.MCP.ContentBlock,
        "CreateMessageRequest" => GenMCP.MCP.CreateMessageRequest,
        "CreateMessageRequestParams" => GenMCP.MCP.CreateMessageRequestParams,
        "CreateMessageResult" => GenMCP.MCP.CreateMessageResult,
        "CreateTaskResult" => GenMCP.MCP.CreateTaskResult,
        "ElicitRequestURLParams" => GenMCP.MCP.ElicitRequestURLParams,
        "ElicitResult" => GenMCP.MCP.ElicitResult,
        "ElicitationCompleteNotification" => GenMCP.MCP.ElicitationCompleteNotification,
        "EmbeddedResource" => GenMCP.MCP.EmbeddedResource,
        "Error" => GenMCP.MCP.Error,
        "GetPromptRequest" => GenMCP.MCP.GetPromptRequest,
        "GetPromptRequestParams" => GenMCP.MCP.GetPromptRequestParams,
        "GetPromptResult" => GenMCP.MCP.GetPromptResult,
        "GetTaskPayloadRequest" => GenMCP.MCP.GetTaskPayloadRequest,
        "GetTaskPayloadResult" => GenMCP.MCP.GetTaskPayloadResult,
        "GetTaskRequest" => GenMCP.MCP.GetTaskRequest,
        "GetTaskResult" => GenMCP.MCP.GetTaskResult,
        "Icon" => GenMCP.MCP.Icon,
        "Icons" => GenMCP.MCP.Icons,
        "ImageContent" => GenMCP.MCP.ImageContent,
        "Implementation" => GenMCP.MCP.Implementation,
        "InitializeRequest" => GenMCP.MCP.InitializeRequest,
        "InitializeRequestParams" => GenMCP.MCP.InitializeRequestParams,
        "InitializeResult" => GenMCP.MCP.InitializeResult,
        "InitializedNotification" => GenMCP.MCP.InitializedNotification,
        "JSONRPCErrorResponse" => GenMCP.MCP.JSONRPCErrorResponse,
        "JSONRPCRequest" => GenMCP.MCP.JSONRPCRequest,
        "JSONRPCResponse" => GenMCP.MCP.JSONRPCResponse,
        "JSONRPCResultResponse" => GenMCP.MCP.JSONRPCResultResponse,
        "ListPromptsRequest" => GenMCP.MCP.ListPromptsRequest,
        "ListPromptsResult" => GenMCP.MCP.ListPromptsResult,
        "ListResourceTemplatesRequest" => GenMCP.MCP.ListResourceTemplatesRequest,
        "ListResourceTemplatesResult" => GenMCP.MCP.ListResourceTemplatesResult,
        "ListResourcesRequest" => GenMCP.MCP.ListResourcesRequest,
        "ListResourcesResult" => GenMCP.MCP.ListResourcesResult,
        "ListTasksRequest" => GenMCP.MCP.ListTasksRequest,
        "ListTasksResult" => GenMCP.MCP.ListTasksResult,
        "ListToolsRequest" => GenMCP.MCP.ListToolsRequest,
        "ListToolsResult" => GenMCP.MCP.ListToolsResult,
        "LoggingLevel" => GenMCP.MCP.LoggingLevel,
        "LoggingMessageNotificationParams" => GenMCP.MCP.LoggingMessageNotificationParams,
        "ModelHint" => GenMCP.MCP.ModelHint,
        "ModelPreferences" => GenMCP.MCP.ModelPreferences,
        "NotificationParams" => GenMCP.MCP.NotificationParams,
        "NumberSchema" => GenMCP.MCP.NumberSchema,
        "PaginatedRequestParams" => GenMCP.MCP.PaginatedRequestParams,
        "PingRequest" => GenMCP.MCP.PingRequest,
        "ProgressNotification" => GenMCP.MCP.ProgressNotification,
        "ProgressNotificationParams" => GenMCP.MCP.ProgressNotificationParams,
        "ProgressToken" => GenMCP.MCP.ProgressToken,
        "Prompt" => GenMCP.MCP.Prompt,
        "PromptArgument" => GenMCP.MCP.PromptArgument,
        "PromptMessage" => GenMCP.MCP.PromptMessage,
        "ReadResourceRequest" => GenMCP.MCP.ReadResourceRequest,
        "ReadResourceRequestParams" => GenMCP.MCP.ReadResourceRequestParams,
        "ReadResourceResult" => GenMCP.MCP.ReadResourceResult,
        "RelatedTaskMetadata" => GenMCP.MCP.RelatedTaskMetadata,
        "RequestId" => GenMCP.MCP.RequestId,
        "RequestParams" => GenMCP.MCP.RequestParams,
        "Resource" => GenMCP.MCP.Resource,
        "ResourceLink" => GenMCP.MCP.ResourceLink,
        "ResourceTemplate" => GenMCP.MCP.ResourceTemplate,
        "ResourceUpdatedNotification" => GenMCP.MCP.ResourceUpdatedNotification,
        "ResourceUpdatedNotificationParams" => GenMCP.MCP.ResourceUpdatedNotificationParams,
        "Result" => GenMCP.MCP.Result,
        "Role" => GenMCP.MCP.Role,
        "RootsListChangedNotification" => GenMCP.MCP.RootsListChangedNotification,
        "SamplingMessage" => GenMCP.MCP.SamplingMessage,
        "SamplingMessageContentBlock" => GenMCP.MCP.SamplingMessageContentBlock,
        "ServerCapabilities" => GenMCP.MCP.ServerCapabilities,
        "StringSchema" => GenMCP.MCP.StringSchema,
        "SubscribeRequest" => GenMCP.MCP.SubscribeRequest,
        "SubscribeRequestParams" => GenMCP.MCP.SubscribeRequestParams,
        "Task" => GenMCP.MCP.Task,
        "TaskMetadata" => GenMCP.MCP.TaskMetadata,
        "TaskStatus" => GenMCP.MCP.TaskStatus,
        "TaskStatusNotification" => GenMCP.MCP.TaskStatusNotification,
        "TaskStatusNotificationParams" => GenMCP.MCP.TaskStatusNotificationParams,
        "TextContent" => GenMCP.MCP.TextContent,
        "TextResourceContents" => GenMCP.MCP.TextResourceContents,
        "Tool" => GenMCP.MCP.Tool,
        "ToolAnnotations" => GenMCP.MCP.ToolAnnotations,
        "ToolChoice" => GenMCP.MCP.ToolChoice,
        "ToolExecution" => GenMCP.MCP.ToolExecution,
        "ToolResultContent" => GenMCP.MCP.ToolResultContent,
        "ToolUseContent" => GenMCP.MCP.ToolUseContent,
        "URLElicitationRequiredError" => GenMCP.MCP.URLElicitationRequiredError,
        "UnsubscribeRequest" => GenMCP.MCP.UnsubscribeRequest,
        "UnsubscribeRequestParams" => GenMCP.MCP.UnsubscribeRequestParams
      }
    }
  end
end

defmodule GenMCP.MCP.Annotations do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Optional annotations for the client. The client can use annotations to
    inform how objects are used or displayed
    """,
    properties: %{
      audience: %{
        description: ~SD"""
        Describes who the intended audience of this object or data is.

        It can include multiple entries to indicate content useful for
        multiple audiences (e.g., `["user", "assistant"]`).
        """,
        items: GenMCP.MCP.Role,
        type: "array"
      },
      lastModified:
        string(
          description: ~SD"""
          The moment the resource was last modified, as an ISO 8601 formatted
          string.

          Should be an ISO 8601 formatted string (e.g., "2025-01-12T15:00:58Z").

          Examples: last activity timestamp in an open file, timestamp when the
          resource was attached, etc.
          """
        ),
      priority: %{
        description: ~SD"""
        Describes how important this data is for operating the server.

        A value of 1 means "most important," and indicates that the data is
        effectively required, while 0 means "least important," and indicates
        that the data is entirely optional.
        """,
        maximum: 1,
        minimum: 0,
        type: "number"
      }
    },
    title: "MCP:Annotations",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.AudioContent do
  use JSV.Schema

  JsonDerive.auto(%{type: "audio"}, [:data, :mimeType])

  @skip_keys [:type]

  defschema %{
    description: "Audio provided to or from an LLM.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      data: string_of("byte", description: "The base64-encoded audio data."),
      mimeType:
        string(
          description: ~SD"""
          The MIME type of the audio. Different providers may support different
          audio types.
          """
        ),
      type: const("audio")
    },
    required: [:data, :mimeType, :type],
    title: "MCP:AudioContent",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.BlobResourceContents do
  use JSV.Schema

  JsonDerive.auto(%{}, [:blob, :uri])

  defschema %{
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      blob:
        string_of("byte",
          description: ~SD"""
          A base64-encoded string representing the binary data of the item.
          """
        ),
      mimeType: string(description: "The MIME type of this resource, if known."),
      uri: uri(description: "The URI of this resource.")
    },
    required: [:blob, :uri],
    title: "MCP:BlobResourceContents",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.BooleanSchema do
  use JSV.Schema

  JsonDerive.auto(%{}, [:type])

  defschema %{
    properties: %{
      default: boolean(),
      description: string(),
      title: string(),
      type: const("boolean")
    },
    required: [:type],
    title: "MCP:BooleanSchema",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CallToolRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tools/call", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Used by the client to invoke a tool provided by the server.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tools/call"),
      params: GenMCP.MCP.CallToolRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:CallToolRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CallToolRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name])

  defschema %{
    description: "Parameters for a `tools/call` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      arguments: %{
        additionalProperties: %{},
        description: "Arguments to use for the tool call.",
        type: "object"
      },
      name: string(description: "The name of the tool."),
      task: GenMCP.MCP.TaskMetadata
    },
    required: [:name],
    title: "MCP:CallToolRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CallToolResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:content])

  defschema %{
    description: "The server's response to a tool call.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      content: %{
        description: ~SD"""
        A list of content objects that represent the unstructured result of
        the tool call.
        """,
        items: GenMCP.MCP.ContentBlock,
        type: "array"
      },
      isError:
        boolean(
          description: ~SD"""
          Whether the tool call ended in an error.

          If not set, this is assumed to be false (the call was successful).

          Any errors that originate from the tool SHOULD be reported inside the
          result object, with `isError` set to true, _not_ as an MCP
          protocol-level error response. Otherwise, the LLM would not be able to
          see that an error occurred and self-correct.

          However, any errors in _finding_ the tool, an error indicating that
          the server does not support tool calls, or any other exceptional
          conditions, should be reported as an MCP error response.
          """
        ),
      structuredContent: %{
        additionalProperties: %{},
        description: ~SD"""
        An optional JSON object that represents the structured result of the
        tool call.
        """,
        type: "object"
      }
    },
    required: [:content],
    title: "MCP:CallToolResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CancelTaskRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tasks/cancel", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: "A request to cancel a task.",
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tasks/cancel"),
      params: %{
        properties: %{
          taskId: string(description: "The task identifier to cancel.")
        },
        required: ["taskId"],
        type: "object"
      }
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:CancelTaskRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CancelTaskResult do
  use JSV.Schema

  def json_schema do
    %{
      allOf: [GenMCP.MCP.Result, GenMCP.MCP.Task],
      description: "The response to a tasks/cancel request.",
      title: "MCP:CancelTaskResult"
    }
  end
end

defmodule GenMCP.MCP.CancelledNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/cancelled", jsonrpc: "2.0"}, [:params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    This notification can be sent by either side to indicate that it is
    cancelling a previously-issued request.

    The request SHOULD still be in-flight, but due to communication
    latency, it is always possible that this notification MAY arrive after
    the request has already finished.

    This notification indicates that the result will be unused, so any
    associated processing SHOULD cease.

    A client MUST NOT attempt to cancel its `initialize` request.

    For task cancellation, use the `tasks/cancel` request instead of this
    notification.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/cancelled"),
      params: GenMCP.MCP.CancelledNotificationParams
    },
    required: [:jsonrpc, :method, :params],
    title: "MCP:CancelledNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CancelledNotificationParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Parameters for a `notifications/cancelled` notification.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      reason:
        string(
          description: ~SD"""
          An optional string describing the reason for the cancellation. This
          MAY be logged or presented to the user.
          """
        ),
      requestId: GenMCP.MCP.RequestId
    },
    title: "MCP:CancelledNotificationParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ClientCapabilities do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Capabilities a client may support. Known capabilities are defined
    here, in this schema, but this is not a closed set: any client can
    define its own, additional capabilities.
    """,
    properties: %{
      elicitation: %{
        description: ~SD"""
        Present if the client supports elicitation from the server.
        """,
        properties: %{
          form: %{additionalProperties: true, properties: %{}, type: "object"},
          url: %{additionalProperties: true, properties: %{}, type: "object"}
        },
        type: "object"
      },
      experimental: %{
        additionalProperties: %{
          additionalProperties: true,
          properties: %{},
          type: "object"
        },
        description: ~SD"""
        Experimental, non-standard capabilities that the client supports.
        """,
        type: "object"
      },
      roots: %{
        description: "Present if the client supports listing roots.",
        properties: %{
          listChanged:
            boolean(
              description: ~SD"""
              Whether the client supports notifications for changes to the roots
              list.
              """
            )
        },
        type: "object"
      },
      sampling: %{
        description: ~SD"""
        Present if the client supports sampling from an LLM.
        """,
        properties: %{
          context: %{
            additionalProperties: true,
            description: ~SD"""
            Whether the client supports context inclusion via includeContext
            parameter. If not declared, servers SHOULD only use `includeContext:
            "none"` (or omit it).
            """,
            properties: %{},
            type: "object"
          },
          tools: %{
            additionalProperties: true,
            description: ~SD"""
            Whether the client supports tool use via tools and toolChoice
            parameters.
            """,
            properties: %{},
            type: "object"
          }
        },
        type: "object"
      },
      tasks: %{
        description: ~SD"""
        Present if the client supports task-augmented requests.
        """,
        properties: %{
          cancel: %{
            additionalProperties: true,
            description: "Whether this client supports tasks/cancel.",
            properties: %{},
            type: "object"
          },
          list: %{
            additionalProperties: true,
            description: "Whether this client supports tasks/list.",
            properties: %{},
            type: "object"
          },
          requests: %{
            description: ~SD"""
            Specifies which request types can be augmented with tasks.
            """,
            properties: %{
              elicitation: %{
                description: "Task support for elicitation-related requests.",
                properties: %{
                  create: %{
                    additionalProperties: true,
                    description: ~SD"""
                    Whether the client supports task-augmented elicitation/create
                    requests.
                    """,
                    properties: %{},
                    type: "object"
                  }
                },
                type: "object"
              },
              sampling: %{
                description: "Task support for sampling-related requests.",
                properties: %{
                  createMessage: %{
                    additionalProperties: true,
                    description: ~SD"""
                    Whether the client supports task-augmented sampling/createMessage
                    requests.
                    """,
                    properties: %{},
                    type: "object"
                  }
                },
                type: "object"
              }
            },
            type: "object"
          }
        },
        type: "object"
      }
    },
    title: "MCP:ClientCapabilities",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ContentBlock do
  use JSV.Schema

  def json_schema do
    %{
      anyOf: [
        GenMCP.MCP.TextContent,
        GenMCP.MCP.ImageContent,
        GenMCP.MCP.AudioContent,
        GenMCP.MCP.ResourceLink,
        GenMCP.MCP.EmbeddedResource
      ],
      title: "MCP:ContentBlock"
    }
  end
end

defmodule GenMCP.MCP.CreateMessageRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "sampling/createMessage", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    A request from the server to sample an LLM via the client. The client
    has full discretion over which model to select. The client should also
    inform the user before beginning sampling, to allow them to inspect
    the request (human in the loop) and decide whether to approve it.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("sampling/createMessage"),
      params: GenMCP.MCP.CreateMessageRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:CreateMessageRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CreateMessageRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:maxTokens, :messages])

  defschema %{
    description: "Parameters for a `sampling/createMessage` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      includeContext: string_enum_to_atom([:allServers, :none, :thisServer]),
      maxTokens:
        integer(
          description: ~SD"""
          The requested maximum number of tokens to sample (to prevent runaway
          completions).

          The client MAY choose to sample fewer tokens than the requested
          maximum.
          """
        ),
      messages: array_of(GenMCP.MCP.SamplingMessage),
      metadata: %{
        additionalProperties: true,
        description: ~SD"""
        Optional metadata to pass through to the LLM provider. The format of
        this metadata is provider-specific.
        """,
        properties: %{},
        type: "object"
      },
      modelPreferences: GenMCP.MCP.ModelPreferences,
      stopSequences: array_of(string()),
      systemPrompt:
        string(
          description: ~SD"""
          An optional system prompt the server wants to use for sampling. The
          client MAY modify or omit this prompt.
          """
        ),
      task: GenMCP.MCP.TaskMetadata,
      temperature: number(),
      toolChoice: GenMCP.MCP.ToolChoice,
      tools: %{
        description: ~SD"""
        Tools that the model may use during generation. The client MUST return
        an error if this field is provided but
        ClientCapabilities.sampling.tools is not declared.
        """,
        items: GenMCP.MCP.Tool,
        type: "array"
      }
    },
    required: [:maxTokens, :messages],
    title: "MCP:CreateMessageRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CreateMessageResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:content, :model, :role])

  defschema %{
    description: ~SD"""
    The client's response to a sampling/createMessage request from the
    server. The client should inform the user before returning the sampled
    message, to allow them to inspect the response (human in the loop) and
    decide whether to allow the server to see it.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      content: %{
        anyOf: [
          GenMCP.MCP.TextContent,
          GenMCP.MCP.ImageContent,
          GenMCP.MCP.AudioContent,
          GenMCP.MCP.ToolUseContent,
          GenMCP.MCP.ToolResultContent,
          array_of(GenMCP.MCP.SamplingMessageContentBlock)
        ]
      },
      model: string(description: "The name of the model that generated the message."),
      role: GenMCP.MCP.Role,
      stopReason:
        string(
          description: ~SD"""
          The reason why sampling stopped, if known.

          Standard values: - "endTurn": Natural end of the assistant's turn -
          "stopSequence": A stop sequence was encountered - "maxTokens": Maximum
          token limit was reached - "toolUse": The model wants to use one or
          more tools

          This field is an open string to allow for provider-specific stop
          reasons.
          """
        )
    },
    required: [:content, :model, :role],
    title: "MCP:CreateMessageResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.CreateTaskResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:task])

  defschema %{
    description: "A response to a task-augmented request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      task: GenMCP.MCP.Task
    },
    required: [:task],
    title: "MCP:CreateTaskResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ElicitRequestURLParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:elicitationId, :message, :mode, :url])

  defschema %{
    description: ~SD"""
    The parameters for a request to elicit information from the user via a
    URL in the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      elicitationId:
        string(
          description: ~SD"""
          The ID of the elicitation, which must be unique within the context of
          the server. The client MUST treat this ID as an opaque value.
          """
        ),
      message:
        string(
          description: ~SD"""
          The message to present to the user explaining why the interaction is
          needed.
          """
        ),
      mode: const("url"),
      task: GenMCP.MCP.TaskMetadata,
      url: uri(description: "The URL that the user should navigate to.")
    },
    required: [:elicitationId, :message, :mode, :url],
    title: "MCP:ElicitRequestURLParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ElicitResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:action])

  defschema %{
    description: "The client's response to an elicitation request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      action: string_enum_to_atom([:accept, :cancel, :decline]),
      content: %{
        additionalProperties: %{
          anyOf: [array_of(string()), %{type: ["string", "integer", "boolean"]}]
        },
        description: ~SD"""
        The submitted form data, only present when action is "accept" and mode
        was "form". Contains values matching the requested schema. Omitted for
        out-of-band mode responses.
        """,
        type: "object"
      }
    },
    required: [:action],
    title: "MCP:ElicitResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ElicitationCompleteNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/elicitation/complete", jsonrpc: "2.0"}, [:params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    An optional notification from the server to the client, informing it
    of a completion of a out-of-band elicitation request.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/elicitation/complete"),
      params: %{
        properties: %{
          elicitationId: string(description: "The ID of the elicitation that completed.")
        },
        required: ["elicitationId"],
        type: "object"
      }
    },
    required: [:jsonrpc, :method, :params],
    title: "MCP:ElicitationCompleteNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.EmbeddedResource do
  use JSV.Schema

  JsonDerive.auto(%{type: "resource"}, [:resource])

  @skip_keys [:type]

  defschema %{
    description: ~SD"""
    The contents of a resource, embedded into a prompt or tool call
    result.

    It is up to the client how best to render embedded resources for the
    benefit of the LLM and/or the user.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      resource: %{
        anyOf: [GenMCP.MCP.TextResourceContents, GenMCP.MCP.BlobResourceContents]
      },
      type: const("resource")
    },
    required: [:resource, :type],
    title: "MCP:EmbeddedResource",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Error do
  use JSV.Schema

  JsonDerive.auto(%{}, [:code, :message])

  defschema %{
    properties: %{
      code: integer(description: "The error type that occurred."),
      data: %{
        description: ~SD"""
        Additional information about the error. The value of this member is
        defined by the sender (e.g. detailed error information, nested errors
        etc.).
        """
      },
      message:
        string(
          description: ~SD"""
          A short description of the error. The message SHOULD be limited to a
          concise single sentence.
          """
        )
    },
    required: [:code, :message],
    title: "MCP:Error",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetPromptRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "prompts/get", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Used by the client to get a prompt provided by the server.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("prompts/get"),
      params: GenMCP.MCP.GetPromptRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:GetPromptRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetPromptRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name])

  defschema %{
    description: "Parameters for a `prompts/get` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      arguments: %{
        additionalProperties: string(),
        description: "Arguments to use for templating the prompt.",
        type: "object"
      },
      name: string(description: "The name of the prompt or prompt template.")
    },
    required: [:name],
    title: "MCP:GetPromptRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetPromptResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:messages])

  defschema %{
    description: ~SD"""
    The server's response to a prompts/get request from the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      description: string(description: "An optional description for the prompt."),
      messages: array_of(GenMCP.MCP.PromptMessage)
    },
    required: [:messages],
    title: "MCP:GetPromptResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetTaskPayloadRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tasks/result", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    A request to retrieve the result of a completed task.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tasks/result"),
      params: %{
        properties: %{
          taskId: string(description: "The task identifier to retrieve results for.")
        },
        required: ["taskId"],
        type: "object"
      }
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:GetTaskPayloadRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetTaskPayloadResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    additionalProperties: %{},
    description: ~SD"""
    The response to a tasks/result request. The structure matches the
    result type of the original request. For example, a tools/call task
    would return the CallToolResult structure.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      }
    },
    title: "MCP:GetTaskPayloadResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetTaskRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tasks/get", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: "A request to retrieve the state of a task.",
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tasks/get"),
      params: %{
        properties: %{
          taskId: string(description: "The task identifier to query.")
        },
        required: ["taskId"],
        type: "object"
      }
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:GetTaskRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.GetTaskResult do
  use JSV.Schema

  def json_schema do
    %{
      allOf: [GenMCP.MCP.Result, GenMCP.MCP.Task],
      description: "The response to a tasks/get request.",
      title: "MCP:GetTaskResult"
    }
  end
end

defmodule GenMCP.MCP.Icon do
  use JSV.Schema

  JsonDerive.auto(%{}, [:src])

  defschema %{
    description: ~SD"""
    An optionally-sized icon that can be displayed in a user interface.
    """,
    properties: %{
      mimeType:
        string(
          description: ~SD"""
          Optional MIME type override if the source MIME type is missing or
          generic. For example: `"image/png"`, `"image/jpeg"`, or
          `"image/svg+xml"`.
          """
        ),
      sizes: %{
        description: ~SD"""
        Optional array of strings that specify sizes at which the icon can be
        used. Each string should be in WxH format (e.g., `"48x48"`, `"96x96"`)
        or `"any"` for scalable formats like SVG.

        If not provided, the client should assume that the icon can be used at
        any size.
        """,
        items: string(),
        type: "array"
      },
      src:
        uri(
          description: ~SD"""
          A standard URI pointing to an icon resource. May be an HTTP/HTTPS URL
          or a `data:` URI with Base64-encoded image data.

          Consumers SHOULD takes steps to ensure URLs serving icons are from the
          same domain as the client/server or a trusted domain.

          Consumers SHOULD take appropriate precautions when consuming SVGs as
          they can contain executable JavaScript.
          """
        ),
      theme: string_enum_to_atom([:dark, :light])
    },
    required: [:src],
    title: "MCP:Icon",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Icons do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: "Base interface to add `icons` property.",
    properties: %{
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      }
    },
    title: "MCP:Icons",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ImageContent do
  use JSV.Schema

  JsonDerive.auto(%{type: "image"}, [:data, :mimeType])

  @skip_keys [:type]

  defschema %{
    description: "An image provided to or from an LLM.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      data: string_of("byte", description: "The base64-encoded image data."),
      mimeType:
        string(
          description: ~SD"""
          The MIME type of the image. Different providers may support different
          image types.
          """
        ),
      type: const("image")
    },
    required: [:data, :mimeType, :type],
    title: "MCP:ImageContent",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Implementation do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name, :version])

  defschema %{
    description: "Describes the MCP implementation.",
    properties: %{
      description:
        string(
          description: ~SD"""
          An optional human-readable description of what this implementation
          does.

          This can be used by clients or servers to provide context about their
          purpose and capabilities. For example, a server might describe the
          types of resources or tools it provides, while a client might describe
          its intended use case.
          """
        ),
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        ),
      version: string(),
      websiteUrl:
        uri(
          description: ~SD"""
          An optional URL of the website for this implementation.
          """
        )
    },
    required: [:name, :version],
    title: "MCP:Implementation",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.InitializeRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "initialize", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    This request is sent from the client to the server when it first
    connects, asking it to begin initialization.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("initialize"),
      params: GenMCP.MCP.InitializeRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:InitializeRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.InitializeRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:capabilities, :clientInfo, :protocolVersion])

  defschema %{
    description: "Parameters for an `initialize` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      capabilities: GenMCP.MCP.ClientCapabilities,
      clientInfo: GenMCP.MCP.Implementation,
      protocolVersion:
        string(
          description: ~SD"""
          The latest version of the Model Context Protocol that the client
          supports. The client MAY decide to support older versions as well.
          """
        )
    },
    required: [:capabilities, :clientInfo, :protocolVersion],
    title: "MCP:InitializeRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.InitializeResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:capabilities, :protocolVersion, :serverInfo])

  defschema %{
    description: ~SD"""
    After receiving an initialize request from the client, the server
    sends this response.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      capabilities: GenMCP.MCP.ServerCapabilities,
      instructions:
        string(
          description: ~SD"""
          Instructions describing how to use the server and its features.

          This can be used by clients to improve the LLM's understanding of
          available tools, resources, etc. It can be thought of like a "hint" to
          the model. For example, this information MAY be added to the system
          prompt.
          """
        ),
      protocolVersion:
        string(
          description: ~SD"""
          The version of the Model Context Protocol that the server wants to
          use. This may not match the version that the client requested. If the
          client cannot support this version, it MUST disconnect.
          """
        ),
      serverInfo: GenMCP.MCP.Implementation
    },
    required: [:capabilities, :protocolVersion, :serverInfo],
    title: "MCP:InitializeResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.InitializedNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/initialized", jsonrpc: "2.0"}, [])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    This notification is sent from the client to the server after
    initialization has finished.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/initialized"),
      params: GenMCP.MCP.NotificationParams
    },
    required: [:jsonrpc, :method],
    title: "MCP:InitializedNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.JSONRPCErrorResponse do
  use JSV.Schema

  JsonDerive.auto(%{}, [:error, :id, :jsonrpc])

  defschema %{
    description: ~SD"""
    A response to a request that indicates an error occurred.
    """,
    properties: %{
      error: GenMCP.MCP.Error,
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0")
    },
    required: [:error, :jsonrpc],
    title: "MCP:JSONRPCErrorResponse",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.JSONRPCRequest do
  use JSV.Schema

  JsonDerive.auto(%{}, [:id, :jsonrpc, :method])

  defschema %{
    description: "A request that expects a response.",
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: string(),
      params: %{additionalProperties: %{}, type: "object"}
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:JSONRPCRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.JSONRPCResponse do
  use JSV.Schema

  def json_schema do
    %{
      anyOf: [GenMCP.MCP.JSONRPCResultResponse, GenMCP.MCP.JSONRPCErrorResponse],
      description: ~SD"""
      A response to a request, containing either the result or error.
      """,
      title: "MCP:JSONRPCResponse"
    }
  end
end

defmodule GenMCP.MCP.JSONRPCResultResponse do
  use JSV.Schema

  JsonDerive.auto(%{}, [:id, :jsonrpc, :result])

  defschema %{
    description: "A successful (non-error) response to a request.",
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      result: GenMCP.MCP.Result
    },
    required: [:id, :jsonrpc, :result],
    title: "MCP:JSONRPCResultResponse",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListPromptsRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "prompts/list", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request a list of prompts and prompt templates
    the server has.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("prompts/list"),
      params: GenMCP.MCP.PaginatedRequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:ListPromptsRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListPromptsResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:prompts])

  defschema %{
    description: ~SD"""
    The server's response to a prompts/list request from the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      nextCursor:
        string(
          description: ~SD"""
          An opaque token representing the pagination position after the last
          returned result. If present, there may be more results available.
          """
        ),
      prompts: array_of(GenMCP.MCP.Prompt)
    },
    required: [:prompts],
    title: "MCP:ListPromptsResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListResourceTemplatesRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "resources/templates/list", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request a list of resource templates the
    server has.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("resources/templates/list"),
      params: GenMCP.MCP.PaginatedRequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:ListResourceTemplatesRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListResourceTemplatesResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:resourceTemplates])

  defschema %{
    description: ~SD"""
    The server's response to a resources/templates/list request from the
    client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      nextCursor:
        string(
          description: ~SD"""
          An opaque token representing the pagination position after the last
          returned result. If present, there may be more results available.
          """
        ),
      resourceTemplates: array_of(GenMCP.MCP.ResourceTemplate)
    },
    required: [:resourceTemplates],
    title: "MCP:ListResourceTemplatesResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListResourcesRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "resources/list", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request a list of resources the server has.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("resources/list"),
      params: GenMCP.MCP.PaginatedRequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:ListResourcesRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListResourcesResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:resources])

  defschema %{
    description: ~SD"""
    The server's response to a resources/list request from the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      nextCursor:
        string(
          description: ~SD"""
          An opaque token representing the pagination position after the last
          returned result. If present, there may be more results available.
          """
        ),
      resources: array_of(GenMCP.MCP.Resource)
    },
    required: [:resources],
    title: "MCP:ListResourcesResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListTasksRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tasks/list", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: "A request to retrieve a list of tasks.",
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tasks/list"),
      params: GenMCP.MCP.PaginatedRequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:ListTasksRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListTasksResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:tasks])

  defschema %{
    description: "The response to a tasks/list request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      nextCursor:
        string(
          description: ~SD"""
          An opaque token representing the pagination position after the last
          returned result. If present, there may be more results available.
          """
        ),
      tasks: array_of(GenMCP.MCP.Task)
    },
    required: [:tasks],
    title: "MCP:ListTasksResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListToolsRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "tools/list", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request a list of tools the server has.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("tools/list"),
      params: GenMCP.MCP.PaginatedRequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:ListToolsRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ListToolsResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:tools])

  defschema %{
    description: ~SD"""
    The server's response to a tools/list request from the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      nextCursor:
        string(
          description: ~SD"""
          An opaque token representing the pagination position after the last
          returned result. If present, there may be more results available.
          """
        ),
      tools: array_of(GenMCP.MCP.Tool)
    },
    required: [:tools],
    title: "MCP:ListToolsResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.LoggingLevel do
  use JSV.Schema

  def json_schema do
    string_enum_to_atom([:alert, :critical, :debug, :emergency, :error, :info, :notice, :warning])
  end
end

defmodule GenMCP.MCP.LoggingMessageNotificationParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:data, :level])

  defschema %{
    description: ~SD"""
    Parameters for a `notifications/message` notification.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      data: %{
        description: ~SD"""
        The data to be logged, such as a string message or an object. Any JSON
        serializable type is allowed here.
        """
      },
      level: GenMCP.MCP.LoggingLevel,
      logger:
        string(
          description: ~SD"""
          An optional name of the logger issuing this message.
          """
        )
    },
    required: [:data, :level],
    title: "MCP:LoggingMessageNotificationParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ModelHint do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Hints to use for model selection.

    Keys not declared here are currently left unspecified by the spec and
    are up to the client to interpret.
    """,
    properties: %{
      name:
        string(
          description: ~SD"""
          A hint for a model name.

          The client SHOULD treat this as a substring of a model name; for
          example: - `claude-3-5-sonnet` should match
          `claude-3-5-sonnet-20241022` - `sonnet` should match
          `claude-3-5-sonnet-20241022`, `claude-3-sonnet-20240229`, etc. -
          `claude` should match any Claude model

          The client MAY also map the string to a different provider's model
          name or a different model family, as long as it fills a similar niche;
          for example: - `gemini-1.5-flash` could match
          `claude-3-haiku-20240307`
          """
        )
    },
    title: "MCP:ModelHint",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ModelPreferences do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    The server's preferences for model selection, requested of the client
    during sampling.

    Because LLMs can vary along multiple dimensions, choosing the "best"
    model is rarely straightforward. Different models excel in different
    areas—some are faster but less capable, others are more capable but
    more expensive, and so on. This interface allows servers to express
    their priorities across multiple dimensions to help clients make an
    appropriate selection for their use case.

    These preferences are always advisory. The client MAY ignore them. It
    is also up to the client to decide how to interpret these preferences
    and how to balance them against other considerations.
    """,
    properties: %{
      costPriority: %{
        description: ~SD"""
        How much to prioritize cost when selecting a model. A value of 0 means
        cost is not important, while a value of 1 means cost is the most
        important factor.
        """,
        maximum: 1,
        minimum: 0,
        type: "number"
      },
      hints: %{
        description: ~SD"""
        Optional hints to use for model selection.

        If multiple hints are specified, the client MUST evaluate them in
        order (such that the first match is taken).

        The client SHOULD prioritize these hints over the numeric priorities,
        but MAY still use the priorities to select from ambiguous matches.
        """,
        items: GenMCP.MCP.ModelHint,
        type: "array"
      },
      intelligencePriority: %{
        description: ~SD"""
        How much to prioritize intelligence and capabilities when selecting a
        model. A value of 0 means intelligence is not important, while a value
        of 1 means intelligence is the most important factor.
        """,
        maximum: 1,
        minimum: 0,
        type: "number"
      },
      speedPriority: %{
        description: ~SD"""
        How much to prioritize sampling speed (latency) when selecting a
        model. A value of 0 means speed is not important, while a value of 1
        means speed is the most important factor.
        """,
        maximum: 1,
        minimum: 0,
        type: "number"
      }
    },
    title: "MCP:ModelPreferences",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.NotificationParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      }
    },
    title: "MCP:NotificationParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.NumberSchema do
  use JSV.Schema

  JsonDerive.auto(%{}, [:type])

  defschema %{
    properties: %{
      default: integer(),
      description: string(),
      maximum: integer(),
      minimum: integer(),
      title: string(),
      type: string_enum_to_atom([:integer, :number])
    },
    required: [:type],
    title: "MCP:NumberSchema",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.PaginatedRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: "Common parameters for paginated requests.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      cursor:
        string(
          description: ~SD"""
          An opaque token representing the current pagination position. If
          provided, the server should return results starting after this cursor.
          """
        )
    },
    title: "MCP:PaginatedRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.PingRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "ping", jsonrpc: "2.0"}, [:id])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    A ping, issued by either the server or the client, to check that the
    other party is still alive. The receiver must promptly respond, or
    else may be disconnected.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("ping"),
      params: GenMCP.MCP.RequestParams
    },
    required: [:id, :jsonrpc, :method],
    title: "MCP:PingRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ProgressNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/progress", jsonrpc: "2.0"}, [:params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    An out-of-band notification used to inform the receiver of a progress
    update for a long-running request.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/progress"),
      params: GenMCP.MCP.ProgressNotificationParams
    },
    required: [:jsonrpc, :method, :params],
    title: "MCP:ProgressNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ProgressNotificationParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:progress, :progressToken])

  defschema %{
    description: ~SD"""
    Parameters for a `notifications/progress` notification.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      message:
        string(
          description: ~SD"""
          An optional message describing the current progress.
          """
        ),
      progress:
        number(
          description: ~SD"""
          The progress thus far. This should increase every time progress is
          made, even if the total is unknown.
          """
        ),
      progressToken: GenMCP.MCP.ProgressToken,
      total:
        number(
          description: ~SD"""
          Total number of items to process (or total progress required), if
          known.
          """
        )
    },
    required: [:progress, :progressToken],
    title: "MCP:ProgressNotificationParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ProgressToken do
  use JSV.Schema

  def json_schema do
    %{
      description: ~SD"""
      A progress token, used to associate progress notifications with the
      original request.
      """,
      title: "MCP:ProgressToken",
      type: ["string", "integer"]
    }
  end
end

defmodule GenMCP.MCP.Prompt do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name])

  defschema %{
    description: ~SD"""
    A prompt or prompt template that the server offers.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      arguments: %{
        description: ~SD"""
        A list of arguments to use for templating the prompt.
        """,
        items: GenMCP.MCP.PromptArgument,
        type: "array"
      },
      description:
        string(
          description: ~SD"""
          An optional description of what this prompt provides
          """
        ),
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        )
    },
    required: [:name],
    title: "MCP:Prompt",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.PromptArgument do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name])

  defschema %{
    description: "Describes an argument that a prompt can accept.",
    properties: %{
      description: string(description: "A human-readable description of the argument."),
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      required: boolean(description: "Whether this argument must be provided."),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        )
    },
    required: [:name],
    title: "MCP:PromptArgument",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.PromptMessage do
  use JSV.Schema

  JsonDerive.auto(%{}, [:content, :role])

  defschema %{
    description: ~SD"""
    Describes a message returned as part of a prompt.

    This is similar to `SamplingMessage`, but also supports the embedding
    of resources from the MCP server.
    """,
    properties: %{content: GenMCP.MCP.ContentBlock, role: GenMCP.MCP.Role},
    required: [:content, :role],
    title: "MCP:PromptMessage",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ReadResourceRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "resources/read", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to the server, to read a specific resource URI.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("resources/read"),
      params: GenMCP.MCP.ReadResourceRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:ReadResourceRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ReadResourceRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:uri])

  defschema %{
    description: "Parameters for a `resources/read` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      uri:
        uri(
          description: ~SD"""
          The URI of the resource. The URI can use any protocol; it is up to the
          server how to interpret it.
          """
        )
    },
    required: [:uri],
    title: "MCP:ReadResourceRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ReadResourceResult do
  use JSV.Schema

  JsonDerive.auto(%{}, [:contents])

  defschema %{
    description: ~SD"""
    The server's response to a resources/read request from the client.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      contents:
        array_of(%{anyOf: [GenMCP.MCP.TextResourceContents, GenMCP.MCP.BlobResourceContents]})
    },
    required: [:contents],
    title: "MCP:ReadResourceResult",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.RelatedTaskMetadata do
  use JSV.Schema

  JsonDerive.auto(%{}, [:taskId])

  defschema %{
    description: ~SD"""
    Metadata for associating messages with a task. Include this in the
    `_meta` field under the key `io.modelcontextprotocol/related-task`.
    """,
    properties: %{
      taskId:
        string(
          description: ~SD"""
          The task identifier this message is associated with.
          """
        )
    },
    required: [:taskId],
    title: "MCP:RelatedTaskMetadata",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.RequestId do
  use JSV.Schema

  def json_schema do
    %{
      description: ~SD"""
      A uniquely identifying ID for a request in JSON-RPC.
      """,
      title: "MCP:RequestId",
      type: ["string", "integer"]
    }
  end
end

defmodule GenMCP.MCP.RequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: "Common params for any request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      }
    },
    title: "MCP:RequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Resource do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name, :uri])

  defschema %{
    description: ~SD"""
    A known resource that the server is capable of reading.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      description:
        string(
          description: ~SD"""
          A description of what this resource represents.

          This can be used by clients to improve the LLM's understanding of
          available resources. It can be thought of like a "hint" to the model.
          """
        ),
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      mimeType: string(description: "The MIME type of this resource, if known."),
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      size:
        integer(
          description: ~SD"""
          The size of the raw resource content, in bytes (i.e., before base64
          encoding or any tokenization), if known.

          This can be used by Hosts to display file sizes and estimate context
          window usage.
          """
        ),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        ),
      uri: uri(description: "The URI of this resource.")
    },
    required: [:name, :uri],
    title: "MCP:Resource",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ResourceLink do
  use JSV.Schema

  JsonDerive.auto(%{type: "resource_link"}, [:name, :uri])

  @skip_keys [:type]

  defschema %{
    description: ~SD"""
    A resource that the server is capable of reading, included in a prompt
    or tool call result.

    Note: resource links returned by tools are not guaranteed to appear in
    the results of `resources/list` requests.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      description:
        string(
          description: ~SD"""
          A description of what this resource represents.

          This can be used by clients to improve the LLM's understanding of
          available resources. It can be thought of like a "hint" to the model.
          """
        ),
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      mimeType: string(description: "The MIME type of this resource, if known."),
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      size:
        integer(
          description: ~SD"""
          The size of the raw resource content, in bytes (i.e., before base64
          encoding or any tokenization), if known.

          This can be used by Hosts to display file sizes and estimate context
          window usage.
          """
        ),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        ),
      type: const("resource_link"),
      uri: uri(description: "The URI of this resource.")
    },
    required: [:name, :type, :uri],
    title: "MCP:ResourceLink",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ResourceTemplate do
  use JSV.Schema

  JsonDerive.auto(%{}, [:name, :uriTemplate])

  defschema %{
    description: ~SD"""
    A template description for resources available on the server.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      description:
        string(
          description: ~SD"""
          A description of what this template is for.

          This can be used by clients to improve the LLM's understanding of
          available resources. It can be thought of like a "hint" to the model.
          """
        ),
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      mimeType:
        string(
          description: ~SD"""
          The MIME type for all resources that match this template. This should
          only be included if all resources matching this template have the same
          type.
          """
        ),
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        ),
      uriTemplate:
        string_of("uri-template",
          description: ~SD"""
          A URI template (according to RFC 6570) that can be used to construct
          resource URIs.
          """
        )
    },
    required: [:name, :uriTemplate],
    title: "MCP:ResourceTemplate",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ResourceUpdatedNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/resources/updated", jsonrpc: "2.0"}, [:params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    A notification from the server to the client, informing it that a
    resource has changed and may need to be read again. This should only
    be sent if the client previously sent a resources/subscribe request.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/resources/updated"),
      params: GenMCP.MCP.ResourceUpdatedNotificationParams
    },
    required: [:jsonrpc, :method, :params],
    title: "MCP:ResourceUpdatedNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ResourceUpdatedNotificationParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:uri])

  defschema %{
    description: ~SD"""
    Parameters for a `notifications/resources/updated` notification.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      uri:
        uri(
          description: ~SD"""
          The URI of the resource that has been updated. This might be a
          sub-resource of the one that the client actually subscribed to.
          """
        )
    },
    required: [:uri],
    title: "MCP:ResourceUpdatedNotificationParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Result do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    additionalProperties: %{},
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      }
    },
    title: "MCP:Result",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Role do
  use JSV.Schema

  def json_schema do
    string_enum_to_atom([:assistant, :user])
  end
end

defmodule GenMCP.MCP.RootsListChangedNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/roots/list_changed", jsonrpc: "2.0"}, [])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    A notification from the client to the server, informing it that the
    list of roots has changed. This notification should be sent whenever
    the client adds, removes, or modifies any root. The server should then
    request an updated list of roots using the ListRootsRequest.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/roots/list_changed"),
      params: GenMCP.MCP.NotificationParams
    },
    required: [:jsonrpc, :method],
    title: "MCP:RootsListChangedNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.SamplingMessage do
  use JSV.Schema

  JsonDerive.auto(%{}, [:content, :role])

  defschema %{
    description: ~SD"""
    Describes a message issued to or received from an LLM API.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      content: %{
        anyOf: [
          GenMCP.MCP.TextContent,
          GenMCP.MCP.ImageContent,
          GenMCP.MCP.AudioContent,
          GenMCP.MCP.ToolUseContent,
          GenMCP.MCP.ToolResultContent,
          array_of(GenMCP.MCP.SamplingMessageContentBlock)
        ]
      },
      role: GenMCP.MCP.Role
    },
    required: [:content, :role],
    title: "MCP:SamplingMessage",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.SamplingMessageContentBlock do
  use JSV.Schema

  def json_schema do
    %{
      anyOf: [
        GenMCP.MCP.TextContent,
        GenMCP.MCP.ImageContent,
        GenMCP.MCP.AudioContent,
        GenMCP.MCP.ToolUseContent,
        GenMCP.MCP.ToolResultContent
      ],
      title: "MCP:SamplingMessageContentBlock"
    }
  end
end

defmodule GenMCP.MCP.ServerCapabilities do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Capabilities that a server may support. Known capabilities are defined
    here, in this schema, but this is not a closed set: any server can
    define its own, additional capabilities.
    """,
    properties: %{
      completions: %{
        additionalProperties: true,
        description: ~SD"""
        Present if the server supports argument autocompletion suggestions.
        """,
        properties: %{},
        type: "object"
      },
      experimental: %{
        additionalProperties: %{
          additionalProperties: true,
          properties: %{},
          type: "object"
        },
        description: ~SD"""
        Experimental, non-standard capabilities that the server supports.
        """,
        type: "object"
      },
      logging: %{
        additionalProperties: true,
        description: ~SD"""
        Present if the server supports sending log messages to the client.
        """,
        properties: %{},
        type: "object"
      },
      prompts: %{
        description: "Present if the server offers any prompt templates.",
        properties: %{
          listChanged:
            boolean(
              description: ~SD"""
              Whether this server supports notifications for changes to the prompt
              list.
              """
            )
        },
        type: "object"
      },
      resources: %{
        description: ~SD"""
        Present if the server offers any resources to read.
        """,
        properties: %{
          listChanged:
            boolean(
              description: ~SD"""
              Whether this server supports notifications for changes to the resource
              list.
              """
            ),
          subscribe:
            boolean(
              description: ~SD"""
              Whether this server supports subscribing to resource updates.
              """
            )
        },
        type: "object"
      },
      tasks: %{
        description: ~SD"""
        Present if the server supports task-augmented requests.
        """,
        properties: %{
          cancel: %{
            additionalProperties: true,
            description: "Whether this server supports tasks/cancel.",
            properties: %{},
            type: "object"
          },
          list: %{
            additionalProperties: true,
            description: "Whether this server supports tasks/list.",
            properties: %{},
            type: "object"
          },
          requests: %{
            description: ~SD"""
            Specifies which request types can be augmented with tasks.
            """,
            properties: %{
              tools: %{
                description: "Task support for tool-related requests.",
                properties: %{
                  call: %{
                    additionalProperties: true,
                    description: ~SD"""
                    Whether the server supports task-augmented tools/call requests.
                    """,
                    properties: %{},
                    type: "object"
                  }
                },
                type: "object"
              }
            },
            type: "object"
          }
        },
        type: "object"
      },
      tools: %{
        description: "Present if the server offers any tools to call.",
        properties: %{
          listChanged:
            boolean(
              description: ~SD"""
              Whether this server supports notifications for changes to the tool
              list.
              """
            )
        },
        type: "object"
      }
    },
    title: "MCP:ServerCapabilities",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.StringSchema do
  use JSV.Schema

  JsonDerive.auto(%{}, [:type])

  defschema %{
    properties: %{
      default: string(),
      description: string(),
      format: string_enum_to_atom([:date, :"date-time", :email, :uri]),
      maxLength: integer(),
      minLength: integer(),
      title: string(),
      type: const("string")
    },
    required: [:type],
    title: "MCP:StringSchema",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.SubscribeRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "resources/subscribe", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request resources/updated notifications from
    the server whenever a particular resource changes.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("resources/subscribe"),
      params: GenMCP.MCP.SubscribeRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:SubscribeRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.SubscribeRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:uri])

  defschema %{
    description: "Parameters for a `resources/subscribe` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      uri:
        uri(
          description: ~SD"""
          The URI of the resource. The URI can use any protocol; it is up to the
          server how to interpret it.
          """
        )
    },
    required: [:uri],
    title: "MCP:SubscribeRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Task do
  use JSV.Schema

  JsonDerive.auto(%{}, [:createdAt, :lastUpdatedAt, :status, :taskId, :ttl])

  defschema %{
    description: "Data associated with a task.",
    properties: %{
      createdAt: string(description: "ISO 8601 timestamp when the task was created."),
      lastUpdatedAt: string(description: "ISO 8601 timestamp when the task was last updated."),
      pollInterval: integer(description: "Suggested polling interval in milliseconds."),
      status: GenMCP.MCP.TaskStatus,
      statusMessage:
        string(
          description: ~SD"""
          Optional human-readable message describing the current task state.
          This can provide context for any status, including: - Reasons for
          "cancelled" status - Summaries for "completed" status - Diagnostic
          information for "failed" status (e.g., error details, what went wrong)
          """
        ),
      taskId: string(description: "The task identifier."),
      ttl:
        integer(
          description: ~SD"""
          Actual retention duration from creation in milliseconds, null for
          unlimited.
          """
        )
    },
    required: [:createdAt, :lastUpdatedAt, :status, :taskId, :ttl],
    title: "MCP:Task",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.TaskMetadata do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Metadata for augmenting a request with task execution. Include this in
    the `task` field of the request parameters.
    """,
    properties: %{
      ttl:
        integer(
          description: ~SD"""
          Requested duration in milliseconds to retain task from creation.
          """
        )
    },
    title: "MCP:TaskMetadata",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.TaskStatus do
  use JSV.Schema

  def json_schema do
    string_enum_to_atom([:cancelled, :completed, :failed, :input_required, :working])
  end
end

defmodule GenMCP.MCP.TaskStatusNotification do
  use JSV.Schema

  JsonDerive.auto(%{method: "notifications/tasks/status", jsonrpc: "2.0"}, [:params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    An optional notification from the receiver to the requestor, informing
    them that a task's status has changed. Receivers are not required to
    send these notifications.
    """,
    properties: %{
      jsonrpc: const("2.0"),
      method: const("notifications/tasks/status"),
      params: GenMCP.MCP.TaskStatusNotificationParams
    },
    required: [:jsonrpc, :method, :params],
    title: "MCP:TaskStatusNotification",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.TaskStatusNotificationParams do
  use JSV.Schema

  def json_schema do
    %{
      allOf: [GenMCP.MCP.NotificationParams, GenMCP.MCP.Task],
      description: ~SD"""
      Parameters for a `notifications/tasks/status` notification.
      """,
      title: "MCP:TaskStatusNotificationParams"
    }
  end
end

defmodule GenMCP.MCP.TextContent do
  use JSV.Schema

  JsonDerive.auto(%{type: "text"}, [:text])

  @skip_keys [:type]

  defschema %{
    description: "Text provided to or from an LLM.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.Annotations,
      text: string(description: "The text content of the message."),
      type: const("text")
    },
    required: [:text, :type],
    title: "MCP:TextContent",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.TextResourceContents do
  use JSV.Schema

  JsonDerive.auto(%{}, [:text, :uri])

  defschema %{
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      mimeType: string(description: "The MIME type of this resource, if known."),
      text:
        string(
          description: ~SD"""
          The text of the item. This must only be set if the item can actually
          be represented as text (not binary data).
          """
        ),
      uri: uri(description: "The URI of this resource.")
    },
    required: [:text, :uri],
    title: "MCP:TextResourceContents",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.Tool do
  use JSV.Schema

  JsonDerive.auto(%{}, [:inputSchema, :name])

  defschema %{
    description: "Definition for a tool the client can call.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      annotations: GenMCP.MCP.ToolAnnotations,
      description:
        string(
          description: ~SD"""
          A human-readable description of the tool.

          This can be used by clients to improve the LLM's understanding of
          available tools. It can be thought of like a "hint" to the model.
          """
        ),
      execution: GenMCP.MCP.ToolExecution,
      icons: %{
        description: ~SD"""
        Optional set of sized icons that the client can display in a user
        interface.

        Clients that support rendering icons MUST support at least the
        following MIME types: - `image/png` - PNG images (safe, universal
        compatibility) - `image/jpeg` (and `image/jpg`) - JPEG images (safe,
        universal compatibility)

        Clients that support rendering icons SHOULD also support: -
        `image/svg+xml` - SVG images (scalable but requires security
        precautions) - `image/webp` - WebP images (modern, efficient format)
        """,
        items: GenMCP.MCP.Icon,
        type: "array"
      },
      inputSchema: %{
        description: ~SD"""
        A JSON Schema object defining the expected parameters for the tool.
        """,
        properties: %{
          "$schema": string(),
          properties: %{
            additionalProperties: %{
              additionalProperties: true,
              properties: %{},
              type: "object"
            },
            type: "object"
          },
          required: array_of(string()),
          type: const("object")
        },
        required: ["type"],
        type: "object"
      },
      name:
        string(
          description: ~SD"""
          Intended for programmatic or logical use, but used as a display name
          in past specs or fallback (if title isn't present).
          """
        ),
      outputSchema: %{
        description: ~SD"""
        An optional JSON Schema object defining the structure of the tool's
        output returned in the structuredContent field of a CallToolResult.

        Defaults to JSON Schema 2020-12 when no explicit $schema is provided.
        Currently restricted to type: "object" at the root level.
        """,
        properties: %{
          "$schema": string(),
          properties: %{
            additionalProperties: %{
              additionalProperties: true,
              properties: %{},
              type: "object"
            },
            type: "object"
          },
          required: array_of(string()),
          type: const("object")
        },
        required: ["type"],
        type: "object"
      },
      title:
        string(
          description: ~SD"""
          Intended for UI and end-user contexts — optimized to be human-readable
          and easily understood, even by those unfamiliar with domain-specific
          terminology.

          If not provided, the name should be used for display (except for Tool,
          where `annotations.title` should be given precedence over using
          `name`, if present).
          """
        )
    },
    required: [:inputSchema, :name],
    title: "MCP:Tool",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ToolAnnotations do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Additional properties describing a Tool to clients.

    NOTE: all properties in ToolAnnotations are **hints**. They are not
    guaranteed to provide a faithful description of tool behavior
    (including descriptive properties like `title`).

    Clients should never make tool use decisions based on ToolAnnotations
    received from untrusted servers.
    """,
    properties: %{
      destructiveHint:
        boolean(
          description: ~SD"""
          If true, the tool may perform destructive updates to its environment.
          If false, the tool performs only additive updates.

          (This property is meaningful only when `readOnlyHint == false`)

          Default: true
          """
        ),
      idempotentHint:
        boolean(
          description: ~SD"""
          If true, calling the tool repeatedly with the same arguments will have
          no additional effect on its environment.

          (This property is meaningful only when `readOnlyHint == false`)

          Default: false
          """
        ),
      openWorldHint:
        boolean(
          description: ~SD"""
          If true, this tool may interact with an "open world" of external
          entities. If false, the tool's domain of interaction is closed. For
          example, the world of a web search tool is open, whereas that of a
          memory tool is not.

          Default: true
          """
        ),
      readOnlyHint:
        boolean(
          description: ~SD"""
          If true, the tool does not modify its environment.

          Default: false
          """
        ),
      title: string(description: "A human-readable title for the tool.")
    },
    title: "MCP:ToolAnnotations",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ToolChoice do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: ~SD"""
    Controls tool selection behavior for sampling requests.
    """,
    properties: %{mode: string_enum_to_atom([:auto, :none, :required])},
    title: "MCP:ToolChoice",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ToolExecution do
  use JSV.Schema

  JsonDerive.auto(%{}, [])

  defschema %{
    description: "Execution-related properties for a tool.",
    properties: %{
      taskSupport: string_enum_to_atom([:forbidden, :optional, :required])
    },
    title: "MCP:ToolExecution",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ToolResultContent do
  use JSV.Schema

  JsonDerive.auto(%{type: "tool_result"}, [:content, :toolUseId])

  @skip_keys [:type]

  defschema %{
    description: ~SD"""
    The result of a tool use, provided by the user back to the assistant.
    """,
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        Optional metadata about the tool result. Clients SHOULD preserve this
        field when including tool results in subsequent sampling requests to
        enable caching optimizations.

        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      content: %{
        description: ~SD"""
        The unstructured result content of the tool use.

        This has the same format as CallToolResult.content and can include
        text, images, audio, resource links, and embedded resources.
        """,
        items: GenMCP.MCP.ContentBlock,
        type: "array"
      },
      isError:
        boolean(
          description: ~SD"""
          Whether the tool use resulted in an error.

          If true, the content typically describes the error that occurred.
          Default: false
          """
        ),
      structuredContent: %{
        additionalProperties: %{},
        description: ~SD"""
        An optional structured result object.

        If the tool defined an outputSchema, this SHOULD conform to that
        schema.
        """,
        type: "object"
      },
      toolUseId:
        string(
          description: ~SD"""
          The ID of the tool use this result corresponds to.

          This MUST match the ID from a previous ToolUseContent.
          """
        ),
      type: const("tool_result")
    },
    required: [:content, :toolUseId, :type],
    title: "MCP:ToolResultContent",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.ToolUseContent do
  use JSV.Schema

  JsonDerive.auto(%{type: "tool_use"}, [:id, :input, :name])

  @skip_keys [:type]

  defschema %{
    description: "A request from the assistant to call a tool.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        Optional metadata about the tool use. Clients SHOULD preserve this
        field when including tool uses in subsequent sampling requests to
        enable caching optimizations.

        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        type: "object"
      },
      id:
        string(
          description: ~SD"""
          A unique identifier for this tool use.

          This ID is used to match tool results to their corresponding tool
          uses.
          """
        ),
      input: %{
        additionalProperties: %{},
        description: ~SD"""
        The arguments to pass to the tool, conforming to the tool's input
        schema.
        """,
        type: "object"
      },
      name: string(description: "The name of the tool to call."),
      type: const("tool_use")
    },
    required: [:id, :input, :name, :type],
    title: "MCP:ToolUseContent",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.URLElicitationRequiredError do
  use JSV.Schema

  JsonDerive.auto(%{}, [:error, :jsonrpc])

  defschema %{
    description: ~SD"""
    An error response that indicates that the server requires the client
    to provide additional information via an elicitation request.
    """,
    properties: %{
      error: %{
        allOf: [
          GenMCP.MCP.Error,
          %{
            properties: %{
              code: const(-32_042),
              data: %{
                additionalProperties: %{},
                properties: %{
                  elicitations: array_of(GenMCP.MCP.ElicitRequestURLParams)
                },
                required: ["elicitations"],
                type: "object"
              }
            },
            required: ["code", "data"],
            type: "object"
          }
        ]
      },
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0")
    },
    required: [:error, :jsonrpc],
    title: "MCP:URLElicitationRequiredError",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.UnsubscribeRequest do
  use JSV.Schema

  JsonDerive.auto(%{method: "resources/unsubscribe", jsonrpc: "2.0"}, [:id, :params])

  @skip_keys [:method, :jsonrpc]

  defschema %{
    description: ~SD"""
    Sent from the client to request cancellation of resources/updated
    notifications from the server. This should follow a previous
    resources/subscribe request.
    """,
    properties: %{
      id: GenMCP.MCP.RequestId,
      jsonrpc: const("2.0"),
      method: const("resources/unsubscribe"),
      params: GenMCP.MCP.UnsubscribeRequestParams
    },
    required: [:id, :jsonrpc, :method, :params],
    title: "MCP:UnsubscribeRequest",
    type: "object"
  }

  @type t :: %__MODULE__{}
end

defmodule GenMCP.MCP.UnsubscribeRequestParams do
  use JSV.Schema

  JsonDerive.auto(%{}, [:uri])

  defschema %{
    description: "Parameters for a `resources/unsubscribe` request.",
    properties: %{
      _meta: %{
        additionalProperties: %{},
        description: ~SD"""
        See [General fields:
        `_meta`](/specification/2025-11-25/basic/index#meta) for notes on
        `_meta` usage.
        """,
        properties: %{progressToken: GenMCP.MCP.ProgressToken},
        type: "object"
      },
      uri:
        uri(
          description: ~SD"""
          The URI of the resource. The URI can use any protocol; it is up to the
          server how to interpret it.
          """
        )
    },
    required: [:uri],
    title: "MCP:UnsubscribeRequestParams",
    type: "object"
  }

  @type t :: %__MODULE__{}
end
