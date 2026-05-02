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
        name: key,
        title: doc.title,
        description: doc.description,
        inputSchema: McpInputSchema(),
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
        // 'tools/list': (payload) async => toolsResult,
        // 'initialize': this.index(),
      };

  Future<McpModel> resourcesList(McpModel payload) async {
    var enContent = Extractor.contents['en'];
    List<McpResource> resources = [];
    enContent?.contents.forEach((key, doc) {
      McpResource resource = McpResource(
        name: key,
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
        name: key,
        title: doc.title,
        description: doc.description,
      );
      prompts.add(prompt);
    });

    return McpListPromptsResult(prompts: prompts);
  }
}
