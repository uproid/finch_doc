import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch_doc/mcp/mcp.dart';
import 'package:finch_doc/mcp/mcp_controller.dart';

class McpDocController extends McpController {
  @override
  McpListToolsResult get toolsResult {
    List<McpTool> tools = [];

    var enContent = Extractor.contents['en'];
    enContent?.contents.forEach((key, doc) {
      McpTool tool = McpTool(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description,
        inputSchema: McpInputSchema(
          type: 'object',
          properties: {
            'lang': McpProperty(
              type: 'string',
              description: 'Language code (en, fa, nl, zh)',
            ),
          },
          required: [],
        ),
      );
      tools.add(tool);
    });

    return McpListToolsResult(
      tools: tools,
    );
  }

  @override
  McpMethodAction get methodActions => {
        'tools/call': handleToolCall,
        'prompts/list': promptList,
        'resources/list': resourcesList,
      };

  Future<McpModel> resourcesList(McpModel payload) async {
    var enContent = Extractor.contents['en'];
    List<McpResource> resources = [];
    enContent?.contents.forEach((key, doc) {
      McpResource resource = McpResource(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description,
        uri: rq.url(key),
      );
      resources.add(resource);
    });
    return McpListResourcesResult(resources: resources);
  }

  @override
  McpCallAction get callAction {
    var enContent = Extractor.contents['en'];
    McpCallAction res = {};
    enContent?.contents.forEach((key, doc) {
      key = key.isEmpty ? 'readme' : key;
      res[key] = (req) async {
        return McpCallToolResult(content: [
          McpTextContent(text: doc.md),
        ]);
      };
    });

    return res;
  }

  Future<McpModel> promptList(McpModel payload) async {
    var enContent = Extractor.contents['en'];
    List<McpPrompt> prompts = [];
    enContent?.contents.forEach((key, doc) {
      McpPrompt prompt = McpPrompt(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description,
      );
      prompts.add(prompt);
    });

    return McpListPromptsResult(prompts: prompts);
  }

  Future<McpModel> handleToolCall(McpModel payload) async {
    final method = payload.get<String>('method', def: 'tools/call');
    final id = payload.get<dynamic>('id', def: null);
    final paramsMap = payload.get<Map<String, dynamic>?>('params', def: null);

    final request = McpCallToolRequest(
      id: id,
      method: method,
      params: McpCallToolRequestParams(
        name: paramsMap?['name'] as String? ?? 'readme',
        arguments: paramsMap?['arguments'] as Map<String, dynamic>?,
      ),
    );

    if (callAction.containsKey(request.params.name)) {
      return await callAction[request.params.name]!(request);
    } else {
      return McpJSONRPCErrorResponse(
        error: McpError(
            code: -32601, message: 'Tool not found: ${request.params.name}'),
      );
    }
  }
}
