import 'dart:async';
import 'dart:convert';
import 'package:finch/console.dart';
import 'package:finch/finch_route.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch_doc/mcp/mcp.dart';

typedef McpMethodAction
    = Map<String, Future<McpModel> Function(McpModel payload)>;

typedef McpCallAction = Map<String,
    Future<McpCallToolResult> Function(McpCallToolRequest payload)>;

abstract class McpController extends Controller {
  McpListToolsResult get toolsResult;
  McpMethodAction get methodActions;
  McpCallAction get callAction;

  @override
  Future<String> index() async {
    final requestData = rq.getAll().removeAll(['POST', 'GET', 'FILE']);
    Stream<SSE> stream = Stream.fromFuture(Future(() async {
      var method = requestData['method'] as String? ?? '';
      final request = McpJSONRPCRequest(
        method: method,
        id: requestData['id'],
        params: requestData['params'] as Map<String, dynamic>?,
        jsonrpc: requestData['jsonrpc'] as String? ?? '2.0',
      );
      if (request.method == 'initialize') {
        final result = McpInitializeResult(
          protocolVersion: '2024-11-05',
          capabilities: McpServerCapabilities(
            tools: toolsResult.toMap(),
          ),
          serverInfo: McpImplementation(
            name: 'finch-doc-mcp-server',
            version: '1.0.0',
          ),
        );

        final response = McpJSONRPCResponse(
          id: request.id,
          result: result.toMap(),
        );
        return SSE(data: jsonEncode(response.toMap()));
      } else if (request.method == 'tools/list') {
        final response = McpJSONRPCResponse(
          id: request.id,
          result: toolsResult.toMap(),
        );
        return SSE(data: jsonEncode(response.toMap()));
      } else {
        var result = await handleMcpMethod(method, request);
        var resultMap = result.toMap();
        Map<String, dynamic> responseMap;
        if (resultMap.containsKey('jsonrpc')) {
          // Already a full JSON-RPC response (e.g. McpJSONRPCErrorResponse)
          responseMap = resultMap;
          if (!responseMap.containsKey('id')) {
            responseMap['id'] = request.id;
          }
        } else {
          // Raw result (e.g. McpCallToolResult) — wrap in a proper JSON-RPC response
          final response = McpJSONRPCResponse(
            id: request.id,
            result: resultMap,
          );
          responseMap = response.toMap();
        }
        var sse = SSE(data: jsonEncode(responseMap));
        return sse;
      }
    }));
    return await rq.renderSSE(stream);
  }

  Future<McpModel> handleMcpMethod(String method, McpModel payload) async {
    if (method.isEmpty) {
      return McpModel().fillMap({
        "jsonrpc": "2.0",
        "id": 1,
        "result": {},
      });
    }
    final action = methodActions[method];

    if (action == null) {
      return McpJSONRPCErrorResponse(
        error: McpError(
          code: -32601,
          message: 'Method not found: $method',
        ),
      );
    }

    return await action(payload);
  }
}
