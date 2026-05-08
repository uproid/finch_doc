import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch_doc/mcp/mc_base.dart';
import 'package:finch_doc/mcp/mcp_controller.dart';

class McpDocController extends McpController {
  @override
  ListToolsResult get toolsResult {
    List<Tool> tools = [];

    var enContent = Extractor.contents['en'];
    enContent?.contents.forEach((key, doc) {
      Tool tool = Tool(
          name: key.isEmpty ? 'readme' : key,
          title: doc.title,
          description: doc.description.isNotEmpty
              ? doc.description
              : 'No description available.',
          inputSchema: ToolSchema(
            type: 'object',
          ),
          outputSchema: ToolSchema(
            type: "object",
            properties: {
              'text': {'type': 'string'}
            },
            required: ['text'],
          ));
      tools.add(tool);
    });

    return ListToolsResult(
      tools: tools,
    );
  }

  @override
  McpMethodAction get methodActions => {
        'tools/call': handleToolCall,
        'prompts/list': promptList,
        'resources/list': resourcesList,
        'resources/read': handleResourceRead,
        'prompts/get': handlePromptGet,
        'resources/templates/list': (payload) async {
          return ListResourceTemplatesResult(resourceTemplates: [
            ResourceTemplate(
              name: 'default',
              title: 'Default Template',
              description: 'A default template for rendering resources.',
              uriTemplate: '{+url}',
            )
          ]);
        },
        'notifications/initialized': (payload) async {
          return JSONRPCNotification(
            method: 'notifications/initialized',
          );
        },
        'logging/setLevel': (payload) async {
          return SetLevelResultResponse(id: '1', result: Result());
        },
      };

  Future<MC> resourcesList(Map<String, Object?> payload) async {
    var enContent = Extractor.contents['en'];
    //var request = ListResourcesRequest.toMC(payload);
    List<Resource> resources = [];
    enContent?.contents.forEach((key, doc) {
      Resource resource = Resource(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
        uri: rq.url(key),
      );
      resources.add(resource);
    });
    return ListResourcesResult(resources: resources);
  }

  @override
  McpCallAction get callAction {
    var enContent = Extractor.contents['en'];
    McpCallAction res = {};
    enContent?.contents.forEach((key, doc) {
      key = key.isEmpty ? 'readme' : key;
      res[key] = (req) async {
        return CallToolResult(
          content: [],
          structuredContent: {"text": doc.md},
        );
      };
    });

    return res;
  }

  Future<MC> promptList(Map<String, Object?> payload) async {
    var enContent = Extractor.contents['en'];
    //var request = ListPromptsRequest.toMC(payload);
    List<Prompt> prompts = [];
    enContent?.contents.forEach((key, doc) {
      Prompt prompt = Prompt(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
      );
      prompts.add(prompt);
    });

    return ListPromptsResult(prompts: prompts);
  }

  Future<MC> handleToolCall(Map<String, Object?> payload) async {
    var request = CallToolRequest.toMC(payload);
    if (callAction.containsKey(request.params.name)) {
      return await callAction[request.params.name]!(request);
    } else {
      return JSONRPCErrorResponse(
        error: Error(
          code: -32601,
          message: 'Tool not found: ${request.params.name}',
        ),
      );
    }
  }

  Future<MC> handleResourceRead(Map<String, Object?> payload) async {
    final request = ReadResourceRequest.toMC(payload);
    var key =
        (Uri.tryParse(request.params.uri)?.path ?? '').replaceAll('/', '');
    if (Extractor.contents['en']!.contents.containsKey(key)) {
      var doc = key.isEmpty
          ? Extractor.contents['en']!.contents.values.first
          : Extractor.contents['en']!.contents[key]!;
      return ReadResourceResult(
        contents: [
          TextResourceContents(
            text: doc.md,
            uri: rq.url(key),
            mimeType: 'text/markdown',
            $meta: MetaObject(doc.meta.cast()),
          ),
        ],
        $meta: MetaObject({
          ...doc.meta.cast<String, dynamic>(),
          'uri': request.params.uri,
          'url': rq.url(key),
        }),
      );
    } else {
      return JSONRPCErrorResponse(
          error: Error(
              code: -32601,
              message: 'Resource not found: ${request.params.uri}'));
    }
  }

  Future<MC> handlePromptGet(Map<String, Object?> payload) async {
    final request = GetPromptRequest.toMC(payload);

    var key = request.params.name;
    if (Extractor.contents['en']!.contents.containsKey(key)) {
      var doc = Extractor.contents['en']!.contents[key]!;
      return GetPromptResult(
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
        messages: [
          PromptMessage(
            role: Role.assistant,
            content: TextContent(text: doc.md, mimeType: 'text/markdown'),
          )
        ],
        $meta: MetaObject({
          ...doc.meta.cast<String, dynamic>(),
          'name': request.params.name,
          'url': rq.url(key),
        }),
      );
    } else {
      return JSONRPCErrorResponse(
        error: Error(code: -32601, message: 'Prompt not found: ${key}'),
      );
    }
  }
}
