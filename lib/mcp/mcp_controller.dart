import 'dart:async';
import 'dart:convert';
import 'package:finch/finch_route.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch_doc/mcp/mc_base.dart';

typedef McpMethodAction
    = Map<String, Future<MC> Function(Map<String, Object?> payload)>;

typedef McpCallAction
    = Map<String, Future<CallToolResult> Function(CallToolRequest payload)>;

abstract class McpController extends Controller {
  ListToolsResult get toolsResult;
  McpMethodAction get methodActions;
  McpCallAction get callAction;

  @override
  Future<String> index() async {
    final requestData = rq.getAll().removeAll(['POST', 'GET', 'FILE']);
    Stream<SSE> stream = Stream.fromFuture(Future(() async {
      var method = requestData['method'] as String? ?? '';
      final request = JSONRPCRequest(
        method: method,
        params: requestData['params'] as Map<String, dynamic>?,
        jsonrpc: requestData['jsonrpc'] as String? ?? '2.0',
      );
      if (request.method == 'initialize') {
        final result = InitializeResult(
          protocolVersion: '2024-11-05',
          capabilities: ServerCapabilities(
            {
              'tools': toolsResult.toMap(),
              'resources': {
                'list': true,
                'read': true,
              },
              'prompts': {
                'list': true,
                'get': true,
              },
            },
          ),
          serverInfo: Implementation(
            name: 'finch-doc-mcp-server',
            version: '1.0.0',
          ),
        );

        final response = InitializeResultResponse(
          id: (requestData['id'] ?? '-1').toString(),
          result: result,
        );
        return SSE(data: jsonEncode(response.toMap()));
      } else if (request.method == 'tools/list') {
        final response = ListToolsResultResponse(
          id: (requestData['id'] ?? '-1').toString(),
          result: toolsResult,
        );
        return SSE(data: jsonEncode(response.toMap()));
      } else {
        var result = await handleMcpMethod(method, requestData);
        var resultMap = result.toMap();
        Map<String, dynamic> responseMap;
        if (resultMap.containsKey('jsonrpc')) {
          // Already a full JSON-RPC response (e.g. McpJSONRPCErrorResponse)
          responseMap = resultMap;
          if (!responseMap.containsKey('id')) {
            responseMap['id'] = (requestData['id'] ?? '-1').toString();
          }
        } else {
          // Raw result (e.g. McpCallToolResult) — wrap in a proper JSON-RPC response
          final response = CallToolResultResponse(
            id: (requestData['id'] ?? '-1').toString(),
            result: CallToolResult.toMC(resultMap),
          );
          responseMap = response.toMap();
        }
        var sse = SSE(data: jsonEncode(responseMap));
        return sse;
      }
    }));
    return await rq.renderSSE(stream);
  }

  Future<MC> handleMcpMethod(
      String method, Map<String, Object?> payload) async {
    if (method.isEmpty) {
      return JSONRPCResultResponse(result: EmptyResult());
    }
    final action = methodActions[method];

    if (action == null) {
      return JSONRPCErrorResponse(
        error: Error(
          code: -32601,
          message: 'Method not found: $method',
        ),
      );
    }

    return await action(payload);
  }
}
