import 'package:finch_doc/mcp/mc_base.dart';

// ── Handler type aliases ───────────────────────────────────────────────────────

typedef ToolHandler = Future<CallToolResult> Function(CallToolRequest request);
typedef ResourceHandler = Future<ReadResourceResult> Function(
    ReadResourceRequest request);
typedef PromptHandler = Future<GetPromptResult> Function(
    GetPromptRequest request);
typedef MethodHandler = Future<MC> Function(Map<String, Object?> payload);

// ── Internal registration entries ─────────────────────────────────────────────

class _ToolEntry {
  final Tool tool;
  final ToolHandler handler;
  _ToolEntry(this.tool, this.handler);
}

class _ResourceEntry {
  final Resource resource;
  final ResourceHandler handler;
  _ResourceEntry(this.resource, this.handler);
}

class _PromptEntry {
  final Prompt prompt;
  final PromptHandler handler;
  _PromptEntry(this.prompt, this.handler);
}

// ── McpBuilder ─────────────────────────────────────────────────────────────────

/// Declarative MCP capability builder.
///
/// Use inside [McpController.configure] to register tools, resources,
/// prompts, resource templates, and custom method handlers — all in one
/// place, without boilerplate.
///
/// ```dart
/// @override
/// void configure(McpBuilder mcp) {
///   mcp.tool(
///     name: 'search',
///     description: 'Search the documentation',
///     handler: (req) async {
///       final query = req.params.arguments?['query'] as String? ?? '';
///       return CallToolResult(content: [TextContent(text: '...')]);
///     },
///   );
///
///   mcp.resource(
///     name: 'readme',
///     uri: rq.url(''),
///     handler: (req) async => ReadResourceResult(contents: [...]),
///   );
/// }
/// ```
class McpBuilder {
  final _tools = <String, _ToolEntry>{};
  final _resources = <String, _ResourceEntry>{};
  final _prompts = <String, _PromptEntry>{};
  final _resourceTemplates = <ResourceTemplate>[];
  final _methods = <String, MethodHandler>{};

  // ── Registration API ─────────────────────────────────────────────────────────

  /// Register an MCP tool.
  ///
  /// [inputSchema] defaults to `ToolSchema(type: 'object')` when omitted.
  void tool({
    required String name,
    String? title,
    String? description,
    ToolSchema? inputSchema,
    ToolSchema? outputSchema,
    ToolAnnotations? annotations,
    required ToolHandler handler,
  }) {
    _tools[name] = _ToolEntry(
      Tool(
        name: name,
        title: title,
        description: description,
        inputSchema: inputSchema ?? ToolSchema(type: 'object'),
        outputSchema: outputSchema,
        annotations: annotations,
      ),
      handler,
    );
  }

  /// Register a readable MCP resource.
  ///
  /// [name] is also used as the path-key fallback during URI lookup
  /// (e.g. name `'routing'` matches an incoming URI whose path is `/routing`).
  void resource({
    required String name,
    required String uri,
    String? title,
    String? description,
    String? mimeType,
    required ResourceHandler handler,
  }) {
    _resources[name] = _ResourceEntry(
      Resource(
        name: name,
        uri: uri,
        title: title,
        description: description,
        mimeType: mimeType,
      ),
      handler,
    );
  }

  /// Register an MCP prompt.
  void prompt({
    required String name,
    String? title,
    String? description,
    List<PromptArgument>? arguments,
    required PromptHandler handler,
  }) {
    _prompts[name] = _PromptEntry(
      Prompt(
        name: name,
        title: title,
        description: description,
        arguments: arguments,
      ),
      handler,
    );
  }

  /// Register a resource URI template.
  void resourceTemplate({
    required String name,
    required String uriTemplate,
    String? title,
    String? description,
    String? mimeType,
  }) {
    _resourceTemplates.add(ResourceTemplate(
      name: name,
      uriTemplate: uriTemplate,
      title: title,
      description: description,
      mimeType: mimeType,
    ));
  }

  /// Register a custom MCP method handler.
  ///
  /// Custom handlers take priority over the built-in method routing in
  /// [McpController], so you can override any standard method or add new ones.
  ///
  /// ```dart
  /// mcp.method('notifications/initialized', (payload) async {
  ///   return JSONRPCNotification(method: 'notifications/initialized');
  /// });
  /// ```
  void method(String name, MethodHandler handler) {
    _methods[name] = handler;
  }

  // ── Build list results ───────────────────────────────────────────────────────

  ListToolsResult buildToolsResult() =>
      ListToolsResult(tools: _tools.values.map((e) => e.tool).toList());

  ListResourcesResult buildResourcesResult() => ListResourcesResult(
      resources: _resources.values.map((e) => e.resource).toList());

  ListPromptsResult buildPromptsResult() =>
      ListPromptsResult(prompts: _prompts.values.map((e) => e.prompt).toList());

  ListResourceTemplatesResult buildResourceTemplatesResult() =>
      ListResourceTemplatesResult(resourceTemplates: _resourceTemplates);

  // ── Handler lookups ──────────────────────────────────────────────────────────

  ToolHandler? toolHandler(String name) => _tools[name]?.handler;

  PromptHandler? promptHandler(String name) => _prompts[name]?.handler;

  /// Look up a resource handler for an incoming [resources/read] URI.
  ///
  /// Tries exact URI match first, then falls back to the path-derived key
  /// (strips slashes, e.g. `/routing` → `routing`, `` → `readme`).
  ResourceHandler? resourceHandlerByUri(String uri) {
    for (final entry in _resources.values) {
      if (entry.resource.uri == uri) return entry.handler;
    }
    final key = (Uri.tryParse(uri)?.path ?? '').replaceAll('/', '');
    return _resources[key]?.handler;
  }

  MethodHandler? methodHandler(String name) => _methods[name];
}
