import 'dart:async';
import 'dart:convert';

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
  late StreamController<SSE> _controller;

  @override
  Future<String> index() async {
    _controller = StreamController<SSE>();

    _handleInitialRequest();

    return rq.renderSSE(_controller.stream);
  }

  void _handleInitialRequest() {
    Future.microtask(() async {
      try {
        final requestData = rq.getAll().removeAll(['POST', 'GET', 'FILE']);
        var method = requestData['method'] as String? ?? '';
        final request = McpJSONRPCRequest(
          method: method,
          id: requestData['id'],
          params: requestData['params'] as Map<String, dynamic>?,
          jsonrpc: requestData['jsonrpc'] as String? ?? '2.0',
        );

        final response = await _handleRequest(request);
        if (!_controller.isClosed) {
          _controller.add(SSE(data: jsonEncode(response.toMap())));
        }

        _listenForRequests();
      } catch (e) {
        if (!_controller.isClosed) {
          _controller.addError(e);
          _controller.close();
        }
      }
    });
  }

  Future<void> _listenForRequests() async {
    try {
      while (!_controller.isClosed) {
        final requestData = await _readNextRequest();
        if (requestData != null) {
          var method = requestData['method'] as String? ?? '';
          final request = McpJSONRPCRequest(
            method: method,
            id: requestData['id'],
            params: requestData['params'] as Map<String, dynamic>?,
            jsonrpc: requestData['jsonrpc'] as String? ?? '2.0',
          );

          final response = await _handleRequest(request);
          if (!_controller.isClosed) {
            _controller.add(SSE(data: jsonEncode(response.toMap())));
          }
        } else {
          break;
        }
      }
    } catch (e) {
      if (!_controller.isClosed) {
        _controller.addError(e);
      }
    } finally {
      if (!_controller.isClosed) {
        _controller.close();
      }
    }
  }

  Future<Map<String, dynamic>?> _readNextRequest() async {
    try {
      final data = rq.getAll().removeAll(['POST', 'GET', 'FILE']);
      return data.isNotEmpty ? data : null;
    } catch (e) {
      return null;
    }
  }

  Future<McpModel> _handleRequest(McpJSONRPCRequest request) async {
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

      return McpJSONRPCResponse(
        id: request.id,
        result: result.toMap(),
      );
    } else if (request.method == 'tools/list') {
      return McpJSONRPCResponse(
        id: request.id,
        result: toolsResult.toMap(),
      );
    } else {
      return await handleMcpMethod(request.method, request);
    }
  }

  Future<McpModel> handleMcpMethod(String method, McpModel payload) async {
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
