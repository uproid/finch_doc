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
        // 'tools/list': (payload) async => toolsResult,
        // 'initialize': this.index(),
      };

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
}
