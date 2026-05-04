import 'dart:io';

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
          description: doc.description.isNotEmpty
              ? doc.description
              : 'No description available.',
          inputSchema: McpInputSchema(
            type: 'object',
            properties: {},
            required: [],
          ),
          outputSchema: McpOutputSchema(
            type: "object",
            properties: {'text': McpProperty(type: 'string')},
            required: ['text'],
          ));
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
        'resources/read': handleResourceRead,
        'prompts/get': handlePromptGet,
        'resources/templates/list': (payload) async {
          return McpListResourceTemplatesResult(resourceTemplates: [
            McpResourceTemplate(
              name: 'default',
              title: 'Default Template',
              description: 'A default template for rendering resources.',
              uriTemplate: '{+url}',
            )
          ]);
        },
        'notifications/initialized': (payload) async {
          return McpJSONRPCNotification(
            method: 'notifications/initialized',
          );
        },
        'logging/setLevel': (payload) async {
          return McpModel().fillMap({
            "jsonrpc": "2.0",
            "id": 1,
            "result": {},
          });
        },
      };

  Future<McpModel> resourcesList(McpModel payload) async {
    var enContent = Extractor.contents['en'];
    List<McpResource> resources = [];
    enContent?.contents.forEach((key, doc) {
      McpResource resource = McpResource(
        name: key.isEmpty ? 'readme' : key,
        title: doc.title,
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
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
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
      );
      prompts.add(prompt);
    });

    return McpListPromptsResult(prompts: prompts);
  }

  Future<McpModel> handleToolCall(McpModel payload) async {
    final method = payload.get<String>('method', def: 'tools/call');
    final id = payload.get<dynamic>('id', def: '-1');
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

  Future<McpModel> handleResourceRead(McpModel payload) async {
    final method = payload.get<String>('method', def: 'resources/read');
    final id = payload.get<dynamic>('id', def: '-1');
    final paramsMap = payload.get<Map<String, dynamic>?>('params', def: null);

    final request = McpReadResourceRequest(
      id: id,
      method: method,
      params: McpReadResourceRequestParams(
        uri: paramsMap?['uri'] as String? ?? (rq.url('readme')),
      ),
    );

    var key = request.params.uri.split('/').last;
    if (Extractor.contents['en']!.contents.containsKey(key)) {
      var doc = Extractor.contents['en']!.contents[key]!;
      return McpReadResourceResult(
        contents: [
          McpTextResourceContents(
            text: doc.md,
            uri: rq.url(key),
            mimeType: 'text/markdown',
            meta: {
              ...doc.meta.cast<String, dynamic>(),
            },
          ).toMap(),
        ],
        meta: {
          ...doc.meta.cast<String, dynamic>(),
          'uri': request.params.uri,
          'url': rq.url(key),
        },
      );
    } else {
      return McpJSONRPCErrorResponse(
        error: McpError(
            code: -32601, message: 'Resource not found: ${request.params.uri}'),
      );
    }
  }

  //////////
  Future<McpModel> handlePromptGet(McpModel payload) async {
    final method = payload.get<String>('method', def: 'prompts/get');
    final id = payload.get<dynamic>('id', def: '-1');
    final paramsMap = payload.get<Map<String, dynamic>?>('params', def: null);

    final request = McpGetPromptRequest(
      id: id,
      method: method,
      params: McpGetPromptRequestParams(
        name: paramsMap?['name'] as String? ?? 'readme',
      ),
    );

    var key = request.params.name;
    if (Extractor.contents['en']!.contents.containsKey(key)) {
      var doc = Extractor.contents['en']!.contents[key]!;
      return McpGetPromptResult(
        description: doc.description.isNotEmpty
            ? doc.description
            : 'No description available.',
        messages: [
          McpPromptMessage(
            role: 'assistant',
            content: [
              McpTextContent(text: doc.md).toMap(),
            ],
          )
        ],
        meta: {
          ...doc.meta.cast<String, dynamic>(),
          'name': request.params.name,
          'url': rq.url(key),
        },
      );
    } else {
      return McpJSONRPCErrorResponse(
        error: McpError(code: -32601, message: 'Prompt not found: ${key}'),
      );
    }
  }
}
