import 'package:finch/finch_route.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/src/tools/console.dart';
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

    final request = McpJSONRPCRequest(
      method: requestData['method'] as String? ?? '',
      id: requestData['id'],
      params: requestData['params'] as Map<String, dynamic>?,
      jsonrpc: requestData['jsonrpc'] as String? ?? '2.0',
    );

    try {
      if (request.method == 'initialize') {
        final result = McpInitializeResult(
          protocolVersion: '2024-11-05',
          capabilities: McpServerCapabilities(
            tools: {}, // Signal that we support tools
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
        return rq.renderData(data: response.toMap());
      } else if (request.method == 'tools/list') {
        final response = McpJSONRPCResponse(
          id: request.id,
          result: toolsResult.toMap(),
        );
        return rq.renderData(data: response.toMap());
      }

      final payload = McpModel().fillMap(requestData);
      final responseModel = await handleMcpMethod(request.method, payload);

      final response = McpJSONRPCResponse(
        id: request.id,
        result: responseModel.toMap(),
      );
      Console.json(response.toMap());
      return rq.renderData(data: response.toMap());
    } catch (e) {
      final errorResponse = McpJSONRPCErrorResponse(
        id: request.id,
        error: McpError(
          code: -32601,
          message: e.toString(),
        ),
      );
      return rq.renderData(data: errorResponse.toMap());
    }
  }

  Future<McpModel> handleMcpMethod(String method, McpModel payload) async {
    final action = methodActions[method];
    if (action == null) {
      throw Exception('Method not found: $method');
    }
    return await action(payload);
  }

  Future<McpModel> handleToolCall(McpModel payload) async {
    final method = payload.get<String>('method', def: 'tools/call');
    final id = payload.get<dynamic>('id', def: null);
    final paramsMap = payload.get<Map<String, dynamic>?>('params', def: null);

    final request = McpCallToolRequest(
      id: id,
      method: method,
      params: McpCallToolRequestParams(
        name: paramsMap?['name'] as String? ?? '',
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
