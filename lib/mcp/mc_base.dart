import 'package:finch_doc/mcp/map_model.dart';

abstract interface class MC {
  Map<String, Object?> toMap();
}

abstract class MapMC<K, V> extends MapModel<K, V> implements MC {
  MapMC(super.data);
}

class JSONRPCErrorResponse extends JSONRPCMessage {
  String jsonrpc;
  String? id;
  Error error;

  JSONRPCErrorResponse({this.jsonrpc = '2.0', this.id, required this.error});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'error': error.toMap()};
  }

  factory JSONRPCErrorResponse.toMC(Map<String, Object?> map) {
    return JSONRPCErrorResponse(
      jsonrpc: map['jsonrpc'] as String,
      id: map['id'] as String?,
      error: Error.toMC(map['error'] as Map<String, Object?>),
    );
  }
}

class Error extends MC {
  int code;
  String message;
  Object? data;

  Error({required this.code, required this.message, this.data});

  @override
  Map<String, Object?> toMap() {
    return {'code': code, 'message': message, 'data': data};
  }

  factory Error.toMC(Map<String, Object?> map) {
    return Error(
      code: map['code'] as int,
      message: map['message'] as String,
      data: map['data'],
    );
  }
}

abstract class JSONRPCMessage extends MC {}

class JSONRPCNotification extends JSONRPCMessage {
  String jsonrpc;
  String method;
  Map<String, Object?>? params;

  JSONRPCNotification({
    this.jsonrpc = '2.0',
    required this.method,
    this.params,
  });

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params};
  }

  factory JSONRPCNotification.toMC(Map<String, Object?> map) {
    return JSONRPCNotification(
      jsonrpc: map['jsonrpc'] as String,
      method: map['method'] as String,
      params: map['params'] as Map<String, Object?>?,
    );
  }
}

abstract class JSONRPCResponse extends JSONRPCMessage {}

class JSONRPCResultResponse extends JSONRPCResponse {
  String jsonrpc;
  String? id;
  Result result;

  JSONRPCResultResponse({this.jsonrpc = '2.0', this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory JSONRPCResultResponse.toMC(Map<String, Object?> map) {
    return JSONRPCResultResponse(
      jsonrpc: map['jsonrpc'] as String,
      id: map['id'] as String?,
      result: Result.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class Result extends MC implements CancelTaskResult {
  MetaObject? meta;
  Map<String, Object?>? unknown;

  Result({this.meta, this.unknown});

  @override
  Map<String, Object?> toMap() {
    return {'meta': meta?.toMap(), ...?unknown};
  }

  factory Result.toMC(Map<String, Object?> map) {
    return Result(
      meta: map['meta'] != null
          ? MetaObject.toMC(map['meta'] as Map<String, Object?>)
          : null,
      unknown: map['unknown'] as Map<String, Object?>?,
    );
  }
}

class MetaObject extends MC {
  Map<String, Object?> _data;
  MetaObject(this._data);

  @override
  Map<String, Object?> toMap() {
    return _data;
  }

  factory MetaObject.toMC(Map<String, Object?> map) {
    return MetaObject(map);
  }
}

class JSONRPCRequest extends MC {
  String method;
  Map<String, Object?>? params;
  String jsonrpc;

  JSONRPCRequest({this.jsonrpc = '2.0', required this.method, this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params};
  }

  factory JSONRPCRequest.toMC(Map<String, Object?> map) {
    return JSONRPCRequest(
      jsonrpc: map['jsonrpc'] as String,
      method: map['method'] as String,
      params: map['params'] as Map<String, Object?>?,
    );
  }
}

class Annotations extends MC {
  int? priority;
  String? lastModified;
  List<Role>? audience;

  Annotations({this.priority, this.lastModified, this.audience});

  @override
  Map<String, Object?> toMap() {
    return {
      if (priority != null) 'priority': priority,
      if (lastModified != null) 'lastModified': lastModified,
      if (audience != null)
        'audience': audience!.map((e) => e.toString()).toList(),
    };
  }

  factory Annotations.toMC(Map<String, Object?> map) {
    return Annotations(
      priority: map['priority'] as int?,
      lastModified: map['lastModified'] as String?,
      audience: map['audience'] != null
          ? (map['audience'] as List<dynamic>)
              .map((e) => Role.to(e as String))
              .toList()
          : null,
    );
  }
}

enum Role {
  user,
  assistant;

  @override
  String toString() {
    return name;
  }

  factory Role.to(String str) {
    return Role.values.firstWhere((e) => e.name == str);
  }
}

class EmptyResult extends Result {
  EmptyResult() : super(meta: null, unknown: null);
  @override
  Map<String, Object?> toMap() {
    return {};
  }
}

class Icon extends MC {
  String src;
  String? mimeType;
  List<String>? sizes;
  Theme? theme;

  Icon({required this.src, this.mimeType, this.sizes, this.theme});
  @override
  Map<String, Object?> toMap() {
    return {
      'src': src,
      if (mimeType != null) 'mimeType': mimeType,
      if (sizes != null) 'sizes': sizes,
      if (theme != null) 'theme': theme!.name,
    };
  }

  factory Icon.toMC(Map<String, Object?> map) {
    return Icon(
      src: map['src'] as String,
      mimeType: map['mimeType'] as String?,
      sizes: (map['sizes'] as List<dynamic>?)?.cast<String>(),
      theme: map['theme'] != null ? Theme.to(map['theme'] as String) : null,
    );
  }
}

enum Theme {
  dark,
  light;

  factory Theme.to(String str) => Theme.values.firstWhere((e) => e.name == str);
}

enum LoggingLevel {
  debug,
  info,
  notice,
  warning,
  error,
  critical,
  alert,
  emergency;

  factory LoggingLevel.to(String str) =>
      LoggingLevel.values.firstWhere((e) => e.name == str);

  @override
  String toString() => name;
}

class NotificationParams extends TaskStatusNotificationParams {
  RequestMetaObject? $meta;

  NotificationParams({this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {if ($meta != null) '_meta': $meta!.toMap()};
  }

  factory NotificationParams.toMC(Map<String, Object?> map) {
    return NotificationParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class RequestMetaObject extends MapMC<String, Object?> {
  RequestMetaObject({String? progressToken})
      : super({'progressToken': progressToken});

  String? get progressToken => data['progressToken'] as String?;

  set progressToken(String? value) => data['progressToken'] = value;

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory RequestMetaObject.toMC(Map<String, Object?> map) {
    return RequestMetaObject(progressToken: map['progressToken'] as String?);
  }
}

class PaginatedRequestParams extends MC {
  String? cursor;
  RequestMetaObject? $meta;

  PaginatedRequestParams({this.cursor, this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {
      if (cursor != null) 'cursor': cursor,
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory PaginatedRequestParams.toMC(Map<String, Object?> map) {
    return PaginatedRequestParams(
      cursor: map['cursor'] as String?,
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class InternalError extends Error {
  InternalError({required super.message, super.data}) : super(code: -32603);
}

class InvalidParamsError extends Error {
  InvalidParamsError({required super.message, super.data})
      : super(code: -32602);
}

class InvalidRequestError extends Error {
  InvalidRequestError({required super.message, super.data})
      : super(code: -32600);
}

class MethodNotFoundError extends Error {
  MethodNotFoundError({required super.message, super.data})
      : super(code: -32601);
}

class ParseError extends Error {
  ParseError({required super.message, super.data}) : super(code: -32700);
}

class ContentBlock extends MC {
  String type;
  String data;
  String mimeType;
  Annotations? annotations;
  MetaObject? $meta;

  ContentBlock({
    required this.type,
    required this.data,
    required this.mimeType,
    this.annotations,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'type': type,
      'data': data,
      'mimeType': mimeType,
      if (annotations != null) 'annotations': annotations!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory ContentBlock.toMC(Map<String, Object?> map) {
    return ContentBlock(
      type: map['type'] as String,
      data: map['data'] as String,
      mimeType: map['mimeType'] as String,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class AudioContent extends ContentBlock {
  AudioContent({
    required super.data,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'audio');
}

interface class ResourceContents extends MC {
  String uri;
  String? mimeType;
  MetaObject? $meta;

  ResourceContents({required this.uri, this.mimeType, this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {
      'uri': uri,
      if (mimeType != null) 'mimeType': mimeType,
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory ResourceContents.toMC(Map<String, Object?> map) {
    return ResourceContents(
      uri: map['uri'] as String,
      mimeType: map['mimeType'] as String?,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class BlobResourceContents extends ResourceContents {
  String blob;
  BlobResourceContents({
    required this.blob,
    required super.uri,
    super.mimeType,
    super.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'blob': blob};
  }

  factory BlobResourceContents.toMC(Map<String, Object?> map) {
    return BlobResourceContents(
      blob: map['blob'] as String,
      uri: map['uri'] as String,
      mimeType: map['mimeType'] as String?,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class TextResourceContent extends ContentBlock {
  String text;

  TextResourceContent({
    required this.text,
    required super.data,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'text');

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'text': text};
  }

  factory TextResourceContent.toMC(Map<String, Object?> map) {
    return TextResourceContent(
      text: map['text'] as String,
      data: map['data'] as String,
      mimeType: map['mimeType'] as String,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class EmbeddedResource extends ContentBlock {
  ResourceContents resource;

  EmbeddedResource({
    required this.resource,
    required super.data,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'resource');

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'resource': resource.toMap()};
  }

  factory EmbeddedResource.toMC(Map<String, Object?> map) {
    return EmbeddedResource(
      resource: ResourceContents.toMC(map['resource'] as Map<String, Object?>),
      data: map['data'] as String,
      mimeType: map['mimeType'] as String,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ImageContent extends ContentBlock {
  ImageContent({
    required super.data,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'image');
}

class ResourceLink extends ContentBlock {
  List<Icon>? icons;
  String name;
  String? title;
  String uri;
  String? description;
  int? size;

  ResourceLink({
    this.icons,
    required this.name,
    this.title,
    required this.uri,
    this.description,
    this.size,
    required super.data,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'resource_link');

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (title != null) 'title': title,
      'uri': uri,
      if (description != null) 'description': description,
      if (size != null) 'size': size,
    };
  }

  factory ResourceLink.toMC(Map<String, Object?> map) {
    return ResourceLink(
      icons: map['icons'] != null
          ? (map['icons'] as List<dynamic>)
              .map((e) => Icon.toMC(e as Map<String, Object?>))
              .toList()
          : null,
      name: map['name'] as String,
      title: map['title'] as String?,
      uri: map['uri'] as String,
      description: map['description'] as String?,
      size: map['size'] as int?,
      data: map['data'] as String,
      mimeType: map['mimeType'] as String,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class TextContent extends ContentBlock {
  String text;

  TextContent({
    required this.text,
    required super.mimeType,
    super.annotations,
    super.$meta,
  }) : super(type: 'text', data: '');

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'text': text};
  }

  factory TextContent.toMC(Map<String, Object?> map) {
    return TextContent(
      text: map['text'] as String,
      mimeType: map['mimeType'] as String,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class TextResourceContents extends ResourceContents {
  String text;

  TextResourceContents({
    required this.text,
    required super.uri,
    super.mimeType,
    super.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'text': text};
  }

  factory TextResourceContents.toMC(Map<String, Object?> map) {
    return TextResourceContents(
      text: map['text'] as String,
      uri: map['uri'] as String,
      mimeType: map['mimeType'] as String?,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class CompleteRequestParamsArgument extends MC {
  String name;
  String value;

  CompleteRequestParamsArgument({required this.name, required this.value});

  @override
  Map<String, Object?> toMap() {
    return {'name': name, 'value': value};
  }

  factory CompleteRequestParamsArgument.toMC(Map<String, Object?> map) {
    return CompleteRequestParamsArgument(
      name: map['name'] as String,
      value: map['value'] as String,
    );
  }
}

class CompleteRequestParamsContext extends MC {
  Map<String, String>? arguments;

  CompleteRequestParamsContext({this.arguments});

  @override
  Map<String, Object?> toMap() {
    return {'arguments': arguments};
  }

  factory CompleteRequestParamsContext.toMC(Map<String, Object?> map) {
    return CompleteRequestParamsContext(
      arguments:
          (map['arguments'] as Map<String, dynamic>?)?.cast<String, String>(),
    );
  }
}

class CompleteRequestParams extends MC {
  RequestMetaObject? $meta;
  Reference ref;
  CompleteRequestParamsArgument argument;
  CompleteRequestParamsContext? context;

  CompleteRequestParams({
    this.$meta,
    required this.ref,
    required this.argument,
    this.context,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      'ref': ref.toMap(),
      'argument': argument.toMap(),
      if (context != null) 'context': context!.toMap(),
    };
  }

  factory CompleteRequestParams.toMC(Map<String, Object?> map) {
    return CompleteRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      ref: PromptReference.toMC(map['ref'] as Map<String, Object?>),
      argument: CompleteRequestParamsArgument.toMC(
        map['argument'] as Map<String, Object?>,
      ),
      context: map['context'] != null
          ? CompleteRequestParamsContext.toMC(
              map['context'] as Map<String, Object?>,
            )
          : null,
    );
  }
}

abstract class Reference extends MC {}

class PromptReference extends Reference {
  String name;
  String? title;
  String type = 'ref/prompt';

  PromptReference({required this.name, this.title});
  @override
  Map<String, Object?> toMap() {
    return {'name': name, if (title != null) 'title': title, 'type': type};
  }

  factory PromptReference.toMC(Map<String, Object?> map) {
    return PromptReference(
      name: map['name'] as String,
      title: map['title'] as String?,
    );
  }
}

class ResourceTemplateReference extends Reference {
  String type = 'ref/resource_template';
  String uri;

  ResourceTemplateReference({required this.uri});

  @override
  Map<String, Object?> toMap() {
    return {'type': type, 'uri': uri};
  }

  factory ResourceTemplateReference.toMC(Map<String, Object?> map) {
    return ResourceTemplateReference(uri: map['uri'] as String);
  }
}

class CompleteRequest extends MC {
  String id;
  CompleteRequestParams params;
  String jsonrpc = '2.0';
  String method = 'completion/complete';

  CompleteRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'id': id,
      'params': params.toMap(),
    };
  }

  factory CompleteRequest.toMC(Map<String, Object?> map) {
    return CompleteRequest(
      id: map['id'] as String,
      params: CompleteRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

class CompleteResultResponse extends MC {
  String jsonrpc = '2.0';
  String id;
  CompleteResult result;

  CompleteResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory CompleteResultResponse.toMC(Map<String, Object?> map) {
    return CompleteResultResponse(
      id: map['id'] as String,
      result: CompleteResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class CompleteResult extends MapMC<String, Object?> {
  MetaObject? $meta;
  CompleteResultCompletion completion;
  CompleteResult({this.$meta, required this.completion})
      : super({'_meta': $meta, 'completion': completion});

  @override
  Map<String, Object?> toMap() {
    return {...data, 'completion': completion.toMap(), '_meta': $meta?.toMap()};
  }

  factory CompleteResult.toMC(Map<String, Object?> map) {
    return CompleteResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      completion: CompleteResultCompletion.toMC(
        map['completion'] as Map<String, Object?>,
      ),
    );
  }
}

class CompleteResultCompletion extends MC {
  List<String> value;
  int? total;
  bool? hasMore;

  CompleteResultCompletion({required this.value, this.total, this.hasMore});

  @override
  Map<String, Object?> toMap() {
    return {
      'value': value,
      if (total != null) 'total': total,
      if (hasMore != null) 'hasMore': hasMore,
    };
  }

  factory CompleteResultCompletion.toMC(Map<String, Object?> map) {
    return CompleteResultCompletion(
      value: (map['value'] as List<dynamic>).cast<String>(),
      total: map['total'] as int?,
      hasMore: map['hasMore'] as bool?,
    );
  }
}

class ElicitRequest extends MC {
  String id;
  ElicitRequestParams params;
  String jsonrpc = '2.0';
  String method = 'completion/elicit';

  ElicitRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'id': id,
      'params': params.toMap(),
    };
  }

  factory ElicitRequest.toMC(Map<String, Object?> map) {
    return ElicitRequest(
      id: map['id'] as String,
      params: ElicitRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

class ElicitRequestParams extends MC {
  String jsonrpc = '2.0';
  String id;
  ElicitResult result;

  ElicitRequestParams({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ElicitRequestParams.toMC(Map<String, Object?> map) {
    return ElicitRequestParams(
      id: map['id'] as String,
      result: ElicitResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

enum ActionType {
  accept,
  decline,
  cancel;

  factory ActionType.to(String str) =>
      ActionType.values.firstWhere((e) => e.name == str);

  @override
  String toString() => name;
}

class ElicitResult extends MapMC<String, Object?> {
  MetaObject? $meta;
  ActionType action;
  Map<String, Object?> content;

  ElicitResult({this.$meta, required this.action, required this.content})
      : super({});

  @override
  Map<String, Object?> toMap() {
    return {
      ...data,
      'action': action.toString(),
      '_meta': $meta?.toMap(),
      'content': content,
    };
  }

  factory ElicitResult.toMC(Map<String, Object?> map) {
    return ElicitResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      action: ActionType.to(map['action'] as String),
      content: map['content'] as Map<String, Object?>,
    )..data.addAll(
        map
          ..removeWhere(
            (key, value) =>
                key == 'action' || key == '_meta' || key == 'content',
          ),
      );
  }
}

class Schema<T> extends MC {
  String type;
  String? title;
  String? description;
  T? defaultValue;

  Schema({required this.type, this.title, this.description, this.defaultValue});

  @override
  Map<String, Object?> toMap() {
    return {
      'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (defaultValue != null) 'default': defaultValue,
    };
  }

  factory Schema.toMC(Map<String, Object?> map) {
    return Schema(
      type: map['type'] as String,
      title: map['title'] as String?,
      description: map['description'] as String?,
      defaultValue: map['default'] as T?,
    );
  }
}

class BooleanSchema extends PrimitiveSchemaDefinition<bool> {
  @override
  String get type => 'boolean';

  BooleanSchema({super.title, super.description, super.defaultValue})
      : super(type: 'boolean');

  factory BooleanSchema.toMC(Map<String, Object?> map) {
    return BooleanSchema(
      title: map['title'] as String?,
      description: map['description'] as String?,
      defaultValue: map['default'] as bool?,
    );
  }
}

class ElicitRequestURLParams extends ElicitRequestParams {
  TaskMetadata? task;
  RequestMetaObject? $meta;
  String node = "url";
  String message;
  String elicitationId;
  String url;

  ElicitRequestURLParams({
    this.task,
    this.$meta,
    required this.message,
    required this.elicitationId,
    required this.url,
  }) : super(
          id: '',
          result: ElicitResult(action: ActionType.accept, content: {}),
        );

  @override
  Map<String, Object?> toMap() {
    return {
      if (task != null) 'task': task!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
      'node': node,
      'message': message,
      'elicitationId': elicitationId,
      'url': url,
    };
  }

  factory ElicitRequestURLParams.toMC(Map<String, Object?> map) {
    return ElicitRequestURLParams(
      task: map['task'] != null
          ? TaskMetadata.toMC(map['task'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      message: map['message'] as String,
      elicitationId: map['elicitationId'] as String,
      url: map['url'] as String,
    );
  }
}

class TaskMetadata extends MC {
  int? ttl;

  TaskMetadata({this.ttl});

  @override
  Map<String, Object?> toMap() {
    return {if (ttl != null) 'ttl': ttl};
  }

  factory TaskMetadata.toMC(Map<String, Object?> map) {
    return TaskMetadata(ttl: map['ttl'] as int?);
  }
}

abstract class EnumSchema<T> extends PrimitiveSchemaDefinition<T> {
  EnumSchema({
    required super.type,
    super.title,
    super.description,
    super.defaultValue,
  });
}

abstract class SingleSelectEnumSchema<T> extends EnumSchema<T> {
  SingleSelectEnumSchema({
    required super.type,
    super.title,
    super.description,
    super.defaultValue,
  });
}

class UntitledSingleSelectEnumSchema extends SingleSelectEnumSchema<String> {
  List<String> $enum;

  UntitledSingleSelectEnumSchema({
    required this.$enum,
    super.defaultValue,
    super.title,
    super.description,
  }) : super(type: 'string');
  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'enum': $enum};
  }

  factory UntitledSingleSelectEnumSchema.toMC(Map<String, Object?> map) {
    return UntitledSingleSelectEnumSchema(
      $enum: (map['enum'] as List<dynamic>).cast<String>(),
      defaultValue: map['default'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }
}

class TitledSingleSelectEnumSchema extends SingleSelectEnumSchema<String> {
  List<({String $const, String title})> oneOf;

  TitledSingleSelectEnumSchema({
    required this.oneOf,
    super.defaultValue,
    super.title,
    super.description,
  }) : super(type: 'string');

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      'oneOf': oneOf.map((e) => {'const': e.$const, 'title': e.title}).toList(),
    };
  }

  factory TitledSingleSelectEnumSchema.toMC(Map<String, Object?> map) {
    return TitledSingleSelectEnumSchema(
      oneOf: (map['oneOf'] as List<dynamic>)
          .map(
            (e) => ($const: e['const'] as String, title: e['title'] as String),
          )
          .toList(),
      defaultValue: map['default'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }
}

abstract class MultiSelectEnumSchema<T> extends EnumSchema<List<T>> {
  MultiSelectEnumSchema({super.title, super.description, super.defaultValue})
      : super(type: 'array');
}

class UntitledMultiSelectEnumSchema extends MultiSelectEnumSchema<String> {
  int? minItems;
  int? maxItems;
  List<String> items;

  UntitledMultiSelectEnumSchema({
    required this.items,
    this.minItems,
    this.maxItems,
    super.defaultValue,
    super.title,
    super.description,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      if (minItems != null) 'minItems': minItems,
      if (maxItems != null) 'maxItems': maxItems,
      'items': {'type': 'string', 'enum': items},
    };
  }

  factory UntitledMultiSelectEnumSchema.toMC(Map<String, Object?> map) {
    final itemsMap = map['items'] as Map<String, Object?>;
    return UntitledMultiSelectEnumSchema(
      items: (itemsMap['enum'] as List<dynamic>).cast<String>(),
      minItems: map['minItems'] as int?,
      maxItems: map['maxItems'] as int?,
      defaultValue: map['default'] != null
          ? (map['default'] as List<dynamic>).cast<String>()
          : null,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }
}

class TitledMultiSelectEnumSchema extends UntitledMultiSelectEnumSchema {
  TitledMultiSelectEnumSchema({
    required super.items,
    super.minItems,
    super.maxItems,
    super.defaultValue,
    super.title,
    super.description,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      if (minItems != null) 'minItems': minItems,
      if (maxItems != null) 'maxItems': maxItems,
      'items': {'type': 'string', 'anyOf': items},
    };
  }

  factory TitledMultiSelectEnumSchema.toMC(Map<String, Object?> map) {
    final itemsMap = map['items'] as Map<String, Object?>;
    return TitledMultiSelectEnumSchema(
      items: (itemsMap['anyOf'] as List<dynamic>).cast<String>(),
      minItems: map['minItems'] as int?,
      maxItems: map['maxItems'] as int?,
      defaultValue: map['default'] != null
          ? (map['default'] as List<dynamic>).cast<String>()
          : null,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }
}

class LegacyTitledEnumSchema extends EnumSchema<String> {
  List<String> $enum;
  List<String>? enumNames;

  LegacyTitledEnumSchema({
    required this.$enum,
    this.enumNames,
    super.defaultValue,
    super.title,
    super.description,
  }) : super(type: 'string');

  @override
  Map<String, Object?> toMap() {
    return {...super.toMap(), 'enum': $enum, 'enumNames': enumNames};
  }

  factory LegacyTitledEnumSchema.toMC(Map<String, Object?> map) {
    return LegacyTitledEnumSchema(
      $enum: (map['enum'] as List<dynamic>).cast<String>(),
      defaultValue: map['default'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      enumNames: (map['enumNames'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

class ElicitRequestFormParams extends ElicitRequestParams {
  TaskMetadata? task;
  RequestMetaObject? $meta;
  String node = "form";
  String message;
  ElicitRequestFormParamsSchema? requestedSchema;

  ElicitRequestFormParams({
    this.task,
    this.$meta,
    required this.message,
    this.requestedSchema,
  }) : super(
          id: '',
          result: ElicitResult(action: ActionType.accept, content: {}),
        );

  @override
  Map<String, Object?> toMap() {
    return {
      if (task != null) 'task': task!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
      'node': node,
      'message': message,
      if (requestedSchema != null) 'requestedSchema': requestedSchema!.toMap(),
    };
  }

  factory ElicitRequestFormParams.toMC(Map<String, Object?> map) {
    return ElicitRequestFormParams(
      task: map['task'] != null
          ? TaskMetadata.toMC(map['task'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      message: map['message'] as String,
      requestedSchema: ElicitRequestFormParamsSchema.toMC(
        map['requestedSchema'] as Map<String, Object?>,
      ),
    );
  }
}

class ElicitRequestFormParamsSchema extends MC {
  String? $schema;
  String type = 'object';
  Map<String, PrimitiveSchemaDefinition> properties = {};
  List<String>? required;

  ElicitRequestFormParamsSchema({
    this.$schema,
    this.required,
    this.type = 'object',
    required this.properties,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($schema != null) r'$schema': $schema,
      'type': type,
      if (properties.isNotEmpty)
        'properties': properties.map(
          (key, value) => MapEntry(key, value.toMap()),
        ),
      if (required != null) 'required': required,
    };
  }

  factory ElicitRequestFormParamsSchema.toMC(Map<String, Object?> map) {
    final propertiesMap = map['properties'] as Map<String, Object?>?;
    return ElicitRequestFormParamsSchema(
      $schema: map[r'$schema'] as String?,
      type: map['type'] as String? ?? 'object',
      properties: propertiesMap != null
          ? propertiesMap.map(
              (key, value) => MapEntry(
                key,
                StringSchema.toMC(value as Map<String, Object?>),
              ),
            )
          : {},
      required: (map['required'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

abstract class PrimitiveSchemaDefinition<T> extends Schema<T> {
  PrimitiveSchemaDefinition({
    required super.type,
    super.title,
    super.description,
    super.defaultValue,
  });
}

enum StringFormat {
  uri('uri'),
  email('email'),
  date('date'),
  dateTime('date-time');

  final String value;
  const StringFormat(this.value);

  static StringFormat to(String str) =>
      StringFormat.values.firstWhere((e) => e.value == str);
}

class StringSchema extends PrimitiveSchemaDefinition<String> {
  int? minLength;
  int? maxLength;
  StringFormat? format;

  StringSchema({
    this.minLength,
    this.maxLength,
    this.format,
    super.defaultValue,
    super.title,
    super.description,
  }) : super(type: 'string');

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      if (minLength != null) 'minLength': minLength,
      if (maxLength != null) 'maxLength': maxLength,
      if (format != null) 'format': format!.value,
    };
  }

  factory StringSchema.toMC(Map<String, Object?> map) {
    return StringSchema(
      minLength: map['minLength'] as int?,
      maxLength: map['maxLength'] as int?,
      format: map['format'] != null
          ? StringFormat.to(map['format'] as String)
          : null,
      defaultValue: map['default'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }
}

class NumberSchema extends PrimitiveSchemaDefinition<num> {
  num? minimum;
  num? maximum;

  NumberSchema({
    super.type = 'number',
    this.minimum,
    this.maximum,
    super.defaultValue,
    super.title,
    super.description,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      if (minimum != null) 'minimum': minimum,
      if (maximum != null) 'maximum': maximum,
    };
  }

  factory NumberSchema.toMC(Map<String, Object?> map) {
    return NumberSchema(
      minimum: map['minimum'] as num?,
      maximum: map['maximum'] as num?,
      defaultValue: map['default'] as num?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      type: map['type'] as String? ?? 'number',
    );
  }
}

class InitializeRequest extends MC {
  String jsonrpc = '2.0';
  String method = 'initialize';
  String id;
  InitializeRequestParams params;

  InitializeRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'id': id,
      'params': params.toMap(),
    };
  }

  factory InitializeRequest.toMC(Map<String, Object?> map) {
    return InitializeRequest(
      id: map['id'] as String,
      params: InitializeRequestParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class InitializeRequestParams extends MC {
  RequestMetaObject? $meta;
  String protocolVersion;
  ClientCapabilities capabilities;
  Implementation clientInfo;

  InitializeRequestParams({
    this.$meta,
    required this.protocolVersion,
    required this.capabilities,
    required this.clientInfo,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '\$meta': $meta!.toMap(),
      'protocolVersion': protocolVersion,
      'capabilities': capabilities.toMap(),
      'clientInfo': clientInfo.toMap(),
    };
  }

  factory InitializeRequestParams.toMC(Map<String, Object?> map) {
    return InitializeRequestParams(
      $meta: map['\$meta'] != null
          ? RequestMetaObject.toMC(map['\$meta'] as Map<String, Object?>)
          : null,
      protocolVersion: map['protocolVersion'] as String,
      capabilities: ClientCapabilities.toMC(
        map['capabilities'] as Map<String, Object?>,
      ),
      clientInfo: Implementation.toMC(
        map['clientInfo'] as Map<String, Object?>,
      ),
    );
  }
}

typedef JSONObject = Map<String, Object?>;
typedef JSONValue = Object?;

class ClientCapabilities extends MapMC<String, Object?> {
  ClientCapabilities(super.data);

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ClientCapabilities.toMC(Map<String, Object?> map) {
    return ClientCapabilities(map);
  }
}

class Implementation extends MC {
  List<Icon>? icons;
  String name;
  String? description;
  String? title;
  String? version;
  String? websiteUrl;

  Implementation({
    this.icons,
    required this.name,
    this.description,
    this.title,
    this.version,
    this.websiteUrl,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (description != null) 'description': description,
      if (title != null) 'title': title,
      if (version != null) 'version': version,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
    };
  }

  factory Implementation.toMC(Map<String, Object?> map) {
    return Implementation(
      icons: map['icons'] != null
          ? (map['icons'] as List<dynamic>)
              .map((e) => Icon.toMC(e as Map<String, Object?>))
              .toList()
          : null,
      name: map['name'] as String,
      description: map['description'] as String?,
      title: map['title'] as String?,
      version: map['version'] as String?,
      websiteUrl: map['websiteUrl'] as String?,
    );
  }
}

class InitializeResultResponse extends MC {
  String jsonrpc = '2.0';
  String id;
  InitializeResult result;

  InitializeResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory InitializeResultResponse.toMC(Map<String, Object?> map) {
    return InitializeResultResponse(
      id: map['id'] as String,
      result: InitializeResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class InitializeResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  String get protocolVersion => data['protocolVersion'] as String;
  ServerCapabilities get capabilities =>
      ServerCapabilities.toMC(data['capabilities'] as Map<String, Object?>);
  Implementation get serverInfo =>
      Implementation.toMC(data['serverInfo'] as Map<String, Object?>);
  String? get instructions => data['instructions'] as String?;

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set protocolVersion(String value) => data['protocolVersion'] = value;
  set capabilities(ServerCapabilities value) =>
      data['capabilities'] = value.toMap();
  set serverInfo(Implementation value) => data['serverInfo'] = value.toMap();
  set instructions(String? value) => data['instructions'] = value;

  InitializeResult({
    MetaObject? $meta,
    required String protocolVersion,
    required ServerCapabilities capabilities,
    required Implementation serverInfo,
    String? instructions,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          'protocolVersion': protocolVersion,
          'capabilities': capabilities.toMap(),
          'serverInfo': serverInfo.toMap(),
          if (instructions != null) 'instructions': instructions,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory InitializeResult.toMC(Map<String, Object?> map) {
    return InitializeResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      protocolVersion: map['protocolVersion'] as String,
      capabilities: ServerCapabilities.toMC(
        map['capabilities'] as Map<String, Object?>,
      ),
      serverInfo: Implementation.toMC(
        map['serverInfo'] as Map<String, Object?>,
      ),
      instructions: map['instructions'] as String?,
    );
  }
}

class ServerCapabilities extends MapMC<String, Object?> {
  ServerCapabilities(super.data);

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ServerCapabilities.toMC(Map<String, Object?> map) {
    return ServerCapabilities(map);
  }
}

class SetLevelRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "logging/setLevel";
  SetLevelRequestParams params;

  SetLevelRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory SetLevelRequest.toMC(Map<String, Object?> map) {
    return SetLevelRequest(
      id: map['id'] as String,
      params: SetLevelRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

class SetLevelRequestParams extends MC {
  RequestMetaObject? $meta;
  LoggingLevel level;

  SetLevelRequestParams({this.$meta, required this.level});

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      'level': level.toString(),
    };
  }

  factory SetLevelRequestParams.toMC(Map<String, Object?> map) {
    return SetLevelRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      level: LoggingLevel.to(map['level'] as String),
    );
  }
}

class SetLevelResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  Result result;

  SetLevelResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory SetLevelResultResponse.toMC(Map<String, Object?> map) {
    return SetLevelResultResponse(
      id: map['id'] as String,
      result: Result.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class CancelledNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notification/cancelled";
  CancelledNotificationParams params;

  CancelledNotification({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params.toMap()};
  }

  factory CancelledNotification.toMC(Map<String, Object?> map) {
    return CancelledNotification(
      params: CancelledNotificationParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class CancelledNotificationParams extends MC {
  MetaObject? $meta;
  String? requestId;
  String? reason;

  CancelledNotificationParams({this.$meta, this.requestId, this.reason});

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      if (requestId != null) 'requestId': requestId,
      if (reason != null) 'reason': reason,
    };
  }

  factory CancelledNotificationParams.toMC(Map<String, Object?> map) {
    return CancelledNotificationParams(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      requestId: map['requestId'] as String?,
      reason: map['reason'] as String?,
    );
  }
}

class InitializedNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/initialized";
  NotificationParams? params;

  InitializedNotification({this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory InitializedNotification.toMC(Map<String, Object?> map) {
    return InitializedNotification(
      params: map['params'] != null
          ? NotificationParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class TaskStatusNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/tasks/status";
  TaskStatusNotificationParams params;

  TaskStatusNotification({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params.toMap()};
  }

  factory TaskStatusNotification.toMC(Map<String, Object?> map) {
    return TaskStatusNotification(
      params: Task.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

abstract class TaskStatusNotificationParams implements MC {}

enum TaskStatus {
  working('working'),
  completed('completed'),
  failed('failed'),
  cancelled('cancelled'),
  inputRequired('input_required');

  final String value;
  const TaskStatus(this.value);
}

class Task extends TaskStatusNotificationParams implements CancelTaskResult {
  String taskId;
  TaskStatus status;
  String? statusMessage;
  String createdAt;
  String lastUpdatedAt;
  int? ttl;
  int? pollInterval;

  Task({
    required this.taskId,
    required this.status,
    this.statusMessage,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.ttl,
    this.pollInterval,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'taskId': taskId,
      'status': status.toString(),
      if (statusMessage != null) 'statusMessage': statusMessage,
      'createdAt': createdAt,
      'lastUpdatedAt': lastUpdatedAt,
      if (ttl != null) 'ttl': ttl,
      if (pollInterval != null) 'pollInterval': pollInterval,
    };
  }

  factory Task.toMC(Map<String, Object?> map) {
    return Task(
      taskId: map['taskId'] as String,
      status: TaskStatus.values.firstWhere(
        (e) => e.value == (map['status'] as String),
      ),
      statusMessage: map['statusMessage'] as String?,
      createdAt: map['createdAt'] as String,
      lastUpdatedAt: map['lastUpdatedAt'] as String,
      ttl: map['ttl'] as int?,
      pollInterval: map['pollInterval'] as int?,
    );
  }
}

class LoggingMessageNotificationParams extends MC {
  MetaObject? $meta;
  LoggingLevel level;
  String? logger;
  dynamic data;

  LoggingMessageNotificationParams({
    this.$meta,
    required this.level,
    this.logger,
    required this.data,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      'level': level.toString(),
      if (logger != null) 'logger': logger,
      'data': data,
    };
  }

  factory LoggingMessageNotificationParams.toMC(Map<String, Object?> map) {
    return LoggingMessageNotificationParams(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      level: LoggingLevel.to(map['level'] as String),
      logger: map['logger'] as String?,
      data: map['data'],
    );
  }
}

class ProgressNotification extends MC {
  ///jsonrpc: “2.0”;
  ///method: “notifications/progress”;
  ///params: ProgressNotificationParams;

  String jsonrpc = "2.0";
  String method = "notifications/progress";
  ProgressNotificationParams params;

  ProgressNotification({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params.toMap()};
  }
}

class ProgressNotificationParams extends MC {
  ///_meta?: MetaObject;
  ///progressToken: ProgressToken;
  ///progress: number;
  ///total?: number;
  ///message?: string;

  MetaObject? $meta;
  String progressToken;
  num progress;
  num? total;
  String? message;

  ProgressNotificationParams({
    this.$meta,
    required this.progressToken,
    required this.progress,
    this.total,
    this.message,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      'progressToken': progressToken,
      'progress': progress,
      if (total != null) 'total': total,
      if (message != null) 'message': message,
    };
  }

  factory ProgressNotificationParams.toMC(Map<String, Object?> map) {
    return ProgressNotificationParams(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      progressToken: map['progressToken'] as String,
      progress: map['progress'] as num,
      total: map['total'] as num?,
      message: map['message'] as String?,
    );
  }
}

class ResourceListChangedNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/resources/list_changed";
  NotificationParams? params;

  ResourceListChangedNotification({this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ResourceListChangedNotification.toMC(Map<String, Object?> map) {
    return ResourceListChangedNotification(
      params: map['params'] != null
          ? NotificationParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ResourceUpdatedNotification extends MC {
  ///jsonrpc: “2.0”;
  ///method: “notifications/resources/updated”;
  ///params: ResourceUpdatedNotificationParams;

  String jsonrpc = "2.0";
  String method = "notifications/resources/updated";
  ResourceUpdatedNotificationParams params;

  ResourceUpdatedNotification({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params.toMap()};
  }

  factory ResourceUpdatedNotification.toMC(Map<String, Object?> map) {
    return ResourceUpdatedNotification(
      params: ResourceUpdatedNotificationParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class ResourceUpdatedNotificationParams extends MC {
  /// jsonrpc: “2.0”;
  /// method: “notifications/resources/updated”;
  /// params: ResourceUpdatedNotificationParams;

  MetaObject? $meta;
  String resourceId;
  String? resourceType;
  Map<String, Object?>? data;

  ResourceUpdatedNotificationParams({
    this.$meta,
    required this.resourceId,
    this.resourceType,
    this.data,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      'resourceId': resourceId,
      if (resourceType != null) 'resourceType': resourceType,
      if (data != null) 'data': data,
    };
  }

  factory ResourceUpdatedNotificationParams.toMC(Map<String, Object?> map) {
    return ResourceUpdatedNotificationParams(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      resourceId: map['resourceId'] as String,
      resourceType: map['resourceType'] as String?,
      data: map['data'] as Map<String, Object?>?,
    );
  }
}

class RootsListChangedNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/roots/list_changed";
  NotificationParams? params;

  RootsListChangedNotification({this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory RootsListChangedNotification.toMC(Map<String, Object?> map) {
    return RootsListChangedNotification(
      params: map['params'] != null
          ? NotificationParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ToolListChangedNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/tools/list_changed";
  NotificationParams? params;

  ToolListChangedNotification({this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ToolListChangedNotification.toMC(Map<String, Object?> map) {
    return ToolListChangedNotification(
      params: map['params'] != null
          ? NotificationParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ElicitationCompleteNotification extends MC {
  ///jsonrpc: “2.0”;
  ///method: “notifications/elicitation/complete”;
  ///params: { elicitationId: string };

  String jsonrpc = "2.0";
  String method = "notifications/elicitation/complete";
  ElicitationCompleteNotificationParams params;

  ElicitationCompleteNotification({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'method': method, 'params': params.toMap()};
  }

  factory ElicitationCompleteNotification.toMC(Map<String, Object?> map) {
    return ElicitationCompleteNotification(
      params: ElicitationCompleteNotificationParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class ElicitationCompleteNotificationParams extends MC {
  String elicitationId;

  ElicitationCompleteNotificationParams({required this.elicitationId});

  @override
  Map<String, Object?> toMap() {
    return {'elicitationId': elicitationId};
  }

  factory ElicitationCompleteNotificationParams.toMC(Map<String, Object?> map) {
    return ElicitationCompleteNotificationParams(
      elicitationId: map['elicitationId'] as String,
    );
  }
}

class PingRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "ping";
  RequestParams? params;

  PingRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory PingRequest.toMC(Map<String, Object?> map) {
    return PingRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? RequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class RequestParams extends MC {
  MetaObject? $meta;

  RequestParams({this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {if ($meta != null) '_meta': $meta!.toMap()};
  }

  factory RequestParams.toMC(Map<String, Object?> map) {
    return RequestParams(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

enum ResultType {
  complete('complete'),
  inputRequired('input_required');

  final String value;
  const ResultType(this.value);
}

class PromptListChangedNotification extends MC {
  String jsonrpc = "2.0";
  String method = "notifications/prompts/list_changed";
  NotificationParams? params;

  PromptListChangedNotification({this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory PromptListChangedNotification.toMC(Map<String, Object?> map) {
    return PromptListChangedNotification(
      params: map['params'] != null
          ? NotificationParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class PingResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  Result result;

  PingResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory PingResultResponse.toMC(Map<String, Object?> map) {
    return PingResultResponse(
      id: map['id'] as String,
      result: Result.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class CreateTaskResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  CreateTaskResult result;

  CreateTaskResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory CreateTaskResultResponse.toMC(Map<String, Object?> map) {
    return CreateTaskResultResponse(
      id: map['id'] as String,
      result: CreateTaskResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*interface CreateTaskResult {
  _meta?: MetaObject;
  task: Task;
  [key: string]: unknown;
}*/

class CreateTaskResult extends MapMC<String, Object?> {
  Task get task => Task.toMC(data['task'] as Map<String, Object?>);

  set task(Task value) => data['task'] = value.toMap();

  CreateTaskResult({MetaObject? $meta, required Task task})
      : super(
            {if ($meta != null) '_meta': $meta.toMap(), 'task': task.toMap()});

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory CreateTaskResult.toMC(Map<String, Object?> map) {
    return CreateTaskResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      task: Task.toMC(map['task'] as Map<String, Object?>),
    );
  }
}

class RelatedTaskMetadata extends MC {
  String taskId;
  String? relationshipType;

  RelatedTaskMetadata({required this.taskId, this.relationshipType});

  @override
  Map<String, Object?> toMap() {
    return {
      'taskId': taskId,
      if (relationshipType != null) 'relationshipType': relationshipType,
    };
  }

  factory RelatedTaskMetadata.toMC(Map<String, Object?> map) {
    return RelatedTaskMetadata(
      taskId: map['taskId'] as String,
      relationshipType: map['relationshipType'] as String?,
    );
  }
}

class GetTaskRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tasks/get";
  GetTaskRequestParams params;

  GetTaskRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory GetTaskRequest.toMC(Map<String, Object?> map) {
    return GetTaskRequest(
      id: map['id'] as String,
      params: GetTaskRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

class GetTaskRequestParams extends MC {
  String taskId;

  GetTaskRequestParams({required this.taskId});

  @override
  Map<String, Object?> toMap() {
    return {'taskId': taskId};
  }

  factory GetTaskRequestParams.toMC(Map<String, Object?> map) {
    return GetTaskRequestParams(taskId: map['taskId'] as String);
  }
}

/*
interface GetTaskPayloadRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  method: “tasks/result”;
  params: { taskId: string };
}
*/
class GetTaskPayloadRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tasks/result";
  GetTaskRequestParams params;

  GetTaskPayloadRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory GetTaskPayloadRequest.toMC(Map<String, Object?> map) {
    return GetTaskPayloadRequest(
      id: map['id'] as String,
      params: GetTaskRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

/*
interface GetTaskPayloadResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: GetTaskPayloadResult;
}
*/
class GetTaskPayloadResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  GetTaskPayloadResult result;

  GetTaskPayloadResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory GetTaskPayloadResultResponse.toMC(Map<String, Object?> map) {
    return GetTaskPayloadResultResponse(
      id: map['id'] as String,
      result: GetTaskPayloadResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*interface GetTaskPayloadResult {
  _meta?: MetaObject;
  [key: string]: unknown;
}*/

class GetTaskPayloadResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();

  GetTaskPayloadResult({
    MetaObject? $meta,
    Map<String, Object?>? additionalData,
  }) : super({if ($meta != null) '_meta': $meta.toMap(), ...?additionalData});

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory GetTaskPayloadResult.toMC(Map<String, Object?> map) {
    return GetTaskPayloadResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      additionalData: Map.from(map)..remove('_meta'),
    );
  }
}

/*
interface ListTasksRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  params?: PaginatedRequestParams;
  method: “tasks/list”;
}
*/
class ListTasksRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tasks/list";
  PaginatedRequestParams? params;

  ListTasksRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ListTasksRequest.toMC(Map<String, Object?> map) {
    return ListTasksRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? PaginatedRequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ListTasksResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ListTasksResult result;

  ListTasksResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ListTasksResultResponse.toMC(Map<String, Object?> map) {
    return ListTasksResultResponse(
      id: map['id'] as String,
      result: ListTasksResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*
interface ListTasksResult {
  _meta?: MetaObject;
  nextCursor?: string;
  tasks: Task[];
  [key: string]: unknown;
}*/
class ListTasksResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  String? get nextCursor => data['nextCursor'] as String?;
  List<Task> get tasks => (data['tasks'] as List<dynamic>)
      .map((e) => Task.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set nextCursor(String? value) => data['nextCursor'] = value;
  set tasks(List<Task> value) =>
      data['tasks'] = value.map((e) => e.toMap()).toList();

  ListTasksResult({
    MetaObject? $meta,
    String? nextCursor,
    required List<Task> tasks,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          if (nextCursor != null) 'nextCursor': nextCursor,
          'tasks': tasks.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ListTasksResult.toMC(Map<String, Object?> map) {
    return ListTasksResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      nextCursor: map['nextCursor'] as String?,
      tasks: (map['tasks'] as List<dynamic>)
          .map((e) => Task.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) => key == '_meta' || key == 'nextCursor' || key == 'tasks',
        ),
    );
  }
}

/*
interface CancelTaskRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  method: “tasks/cancel”;
  params: { taskId: string };
}
*/
class CancelTaskRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tasks/cancel";
  GetTaskRequestParams params;

  CancelTaskRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory CancelTaskRequest.toMC(Map<String, Object?> map) {
    return CancelTaskRequest(
      id: map['id'] as String,
      params: GetTaskRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

/*
interface CancelTaskResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: CancelTaskResult;
}
*/
class CancelTaskResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  CancelTaskResult result;
  CancelTaskResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory CancelTaskResultResponse.toMC(Map<String, Object?> map) {
    return CancelTaskResultResponse(
      id: map['id'] as String,
      result: CancelTaskResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

abstract class CancelTaskResult implements MC {
  factory CancelTaskResult.toMC(Map<String, Object?> map) {
    return Task(
      taskId: map['taskId'] as String,
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${map['status']}',
      ),
      createdAt: map['createdAt'] as String,
      lastUpdatedAt: map['lastUpdatedAt'] as String,
    );
  }
}

/*
interface GetPromptRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  method: “prompts/get”;
  params: GetPromptRequestParams;
}
*/
class GetPromptRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "prompts/get";
  GetPromptRequestParams params;

  GetPromptRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory GetPromptRequest.toMC(Map<String, Object?> map) {
    return GetPromptRequest(
      id: map['id'] as String,
      params: GetPromptRequestParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

/*
interface GetPromptRequestParams {
  _meta?: RequestMetaObject;
  inputResponses?: InputResponses;
  requestState?: string;
  name: string;
  arguments?: { [key: string]: string };
}
*/
class GetPromptRequestParams extends MC {
  RequestMetaObject? $meta;
  InputResponses? inputResponses;
  String? requestState;
  String name;
  Map<String, String>? arguments;

  GetPromptRequestParams({
    this.$meta,
    this.inputResponses,
    this.requestState,
    required this.name,
    this.arguments,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      if (inputResponses != null) 'inputResponses': inputResponses!.toMap(),
      if (requestState != null) 'requestState': requestState,
      'name': name,
      if (arguments != null) 'arguments': arguments,
    };
  }

  factory GetPromptRequestParams.toMC(Map<String, Object?> map) {
    return GetPromptRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      inputResponses: map['inputResponses'],
      requestState: map['requestState'] as String?,
      name: map['name'] as String,
      arguments: (map['arguments'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }
}

typedef InputResponses = dynamic;

/*
interface GetPromptResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: InputRequiredResult | GetPromptResult;
}
*/

class GetPromptResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  GetPromptResult result;

  GetPromptResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result};
  }

  factory GetPromptResultResponse.toMC(Map<String, Object?> map) {
    return GetPromptResultResponse(
      id: map['id'] as String,
      result: GetPromptResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*
interface GetPromptResult {
  _meta?: MetaObject;
  resultType: ResultType;
  description?: string;
  messages: PromptMessage[];
  [key: string]: unknown;
}*/
class GetPromptResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  String? get description => data['description'] as String?;
  List<PromptMessage> get messages => (data['messages'] as List<dynamic>)
      .map((e) => PromptMessage.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set description(String? value) => data['description'] = value;
  set messages(List<PromptMessage> value) =>
      data['messages'] = value.map((e) => e.toMap()).toList();

  GetPromptResult({
    MetaObject? $meta,
    String? description,
    required List<PromptMessage> messages,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          'description': description,
          'messages': messages.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory GetPromptResult.toMC(Map<String, Object?> map) {
    return GetPromptResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      description: map['description'] as String?,
      messages: (map['messages'] as List<dynamic>)
          .map((e) => PromptMessage.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'description' ||
              key == 'messages',
        ),
    );
  }
}

/*
interface PromptMessage {
  role: Role;
  content: ContentBlock;
}
*/
class PromptMessage extends MC {
  Role role;
  ContentBlock content;
  PromptMessage({required this.role, required this.content});
  @override
  Map<String, Object?> toMap() {
    return {'role': role.toString(), 'content': content.toMap()};
  }

  factory PromptMessage.toMC(Map<String, Object?> map) {
    return PromptMessage(
      role: Role.values.firstWhere(
        (e) => e.toString() == 'Role.${map['role']}',
      ),
      content: ContentBlock.toMC(map['content'] as Map<String, Object?>),
    );
  }
}

/*
interface ListPromptsRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  params?: PaginatedRequestParams;
  method: “prompts/list”;
}
*/
class ListPromptsRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "prompts/list";
  PaginatedRequestParams? params;

  ListPromptsRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ListPromptsRequest.toMC(Map<String, Object?> map) {
    return ListPromptsRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? PaginatedRequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

/*
interface ListPromptsResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: ListPromptsResult;
}
*/
class ListPromptsResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ListPromptsResult result;
  ListPromptsResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ListPromptsResultResponse.toMC(Map<String, Object?> map) {
    return ListPromptsResultResponse(
      id: map['id'] as String,
      result: ListPromptsResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*
interface ListPromptsResult {
  _meta?: MetaObject;
  resultType: ResultType;
  nextCursor?: string;
  prompts: Prompt[];
  [key: string]: unknown;
}
*/
class ListPromptsResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  String? get nextCursor => data['nextCursor'] as String?;
  List<Prompt> get prompts => (data['prompts'] as List<dynamic>)
      .map((e) => Prompt.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set nextCursor(String? value) => data['nextCursor'] = value;
  set prompts(List<Prompt> value) =>
      data['prompts'] = value.map((e) => e.toMap()).toList();

  ListPromptsResult({
    MetaObject? $meta,
    String? nextCursor,
    required List<Prompt> prompts,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          if (nextCursor != null) 'nextCursor': nextCursor,
          'prompts': prompts.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ListPromptsResult.toMC(Map<String, Object?> map) {
    return ListPromptsResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      nextCursor: map['nextCursor'] as String?,
      prompts: (map['prompts'] as List<dynamic>)
          .map((e) => Prompt.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'nextCursor' ||
              key == 'prompts',
        ),
    );
  }
}

/*interface Prompt {
  icons?: Icon[];
  name: string;
  title?: string;
  description?: string;
  arguments?: PromptArgument[];
  _meta?: MetaObject;
}*/
class Prompt extends MC {
  List<Icon>? icons;
  String name;
  String? title;
  String? description;
  List<PromptArgument>? arguments;
  MetaObject? $meta;

  Prompt({
    this.icons,
    required this.name,
    this.title,
    this.description,
    this.arguments,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (arguments != null)
        'arguments': arguments!.map((e) => e.toMap()).toList(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory Prompt.toMC(Map<String, Object?> map) {
    return Prompt(
      icons: (map['icons'] as List<dynamic>?)
          ?.map((e) => Icon.toMC(e as Map<String, Object?>))
          .toList(),
      name: map['name'] as String,
      title: map['title'] as String?,
      description: map['description'] as String?,
      arguments: (map['arguments'] as List<dynamic>?)
          ?.map((e) => PromptArgument.toMC(e as Map<String, Object?>))
          .toList(),
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

/*
interface PromptArgument {
  name: string;
  title?: string;
  description?: string;
  required?: boolean;
}*/
class PromptArgument extends MC {
  String name;
  String? title;
  String? description;
  bool? required;

  PromptArgument({
    required this.name,
    this.title,
    this.description,
    this.required,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'name': name,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (required != null) 'required': required,
    };
  }

  factory PromptArgument.toMC(Map<String, Object?> map) {
    return PromptArgument(
      name: map['name'] as String,
      title: map['title'] as String?,
      description: map['description'] as String?,
      required: map['required'] as bool?,
    );
  }
}

/*
interface ListResourcesRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  params?: PaginatedRequestParams;
  method: “resources/list”;
}
*/
class ListResourcesRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "resources/list";
  PaginatedRequestParams? params;

  ListResourcesRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ListResourcesRequest.toMC(Map<String, Object?> map) {
    return ListResourcesRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? PaginatedRequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

/*
interface ListResourcesResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: ListResourcesResult;
}
*/
class ListResourcesResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ListResourcesResult result;

  ListResourcesResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ListResourcesResultResponse.toMC(Map<String, Object?> map) {
    return ListResourcesResultResponse(
      id: map['id'] as String,
      result: ListResourcesResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*
interface ListResourcesResult {
  _meta?: MetaObject;
  resultType: ResultType;
  nextCursor?: string;
  resources: Resource[];
  [key: string]: unknown;
}
*/
class ListResourcesResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  String? get nextCursor => data['nextCursor'] as String?;
  List<Resource> get resources => (data['resources'] as List<dynamic>)
      .map((e) => Resource.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set nextCursor(String? value) => data['nextCursor'] = value;
  set resources(List<Resource> value) =>
      data['resources'] = value.map((e) => e.toMap()).toList();

  ListResourcesResult({
    MetaObject? $meta,
    String? nextCursor,
    required List<Resource> resources,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          if (nextCursor != null) 'nextCursor': nextCursor,
          'resources': resources.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ListResourcesResult.toMC(Map<String, Object?> map) {
    return ListResourcesResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      nextCursor: map['nextCursor'] as String?,
      resources: (map['resources'] as List<dynamic>)
          .map((e) => Resource.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'nextCursor' ||
              key == 'resources',
        ),
    );
  }
}

/*
interface Resource {
  icons?: Icon[];
  name: string;
  title?: string;
  uri: string;
  description?: string;
  mimeType?: string;
  annotations?: Annotations;
  size?: number;
  _meta?: MetaObject;
}*/
class Resource extends MC {
  List<Icon>? icons;
  String name;
  String? title;
  String uri;
  String? description;
  String? mimeType;
  Annotations? annotations;
  int? size;
  MetaObject? $meta;

  Resource({
    this.icons,
    required this.name,
    this.title,
    required this.uri,
    this.description,
    this.mimeType,
    this.annotations,
    this.size,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (title != null) 'title': title,
      'uri': uri,
      if (description != null) 'description': description,
      if (mimeType != null) 'mimeType': mimeType,
      if (annotations != null) 'annotations': annotations!.toMap(),
      if (size != null) 'size': size,
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory Resource.toMC(Map<String, Object?> map) {
    return Resource(
      icons: (map['icons'] as List<dynamic>?)
          ?.map((e) => Icon.toMC(e as Map<String, Object?>))
          .toList(),
      name: map['name'] as String,
      title: map['title'] as String?,
      uri: map['uri'] as String,
      description: map['description'] as String?,
      mimeType: map['mimeType'] as String?,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      size: map['size'] as int?,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

/*
interface ReadResourceRequest {
  jsonrpc: “2.0”;
  id: RequestId;
  method: “resources/read”;
  params: ReadResourceRequestParams;
}*/
class ReadResourceRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "resources/read";
  ReadResourceRequestParams params;

  ReadResourceRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory ReadResourceRequest.toMC(Map<String, Object?> map) {
    return ReadResourceRequest(
      id: map['id'] as String,
      params: ReadResourceRequestParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

/*
interface ReadResourceRequestParams {
  _meta?: RequestMetaObject;
  inputResponses?: InputResponses;
  requestState?: string;
  uri: string;
}*/
class ReadResourceRequestParams extends MC {
  RequestMetaObject? $meta;
  InputResponses? inputResponses;
  String? requestState;
  String uri;

  ReadResourceRequestParams({
    this.$meta,
    this.inputResponses,
    this.requestState,
    required this.uri,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($meta != null) '_meta': $meta!.toMap(),
      if (inputResponses != null) 'inputResponses': inputResponses!.toMap(),
      if (requestState != null) 'requestState': requestState,
      'uri': uri,
    };
  }

  factory ReadResourceRequestParams.toMC(Map<String, Object?> map) {
    return ReadResourceRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      inputResponses: map['inputResponses'],
      requestState: map['requestState'] as String?,
      uri: map['uri'] as String,
    );
  }
}

/*
interface ReadResourceResultResponse {
  jsonrpc: “2.0”;
  id: RequestId;
  result: InputRequiredResult | ReadResourceResult;
}*/
class ReadResourceResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ReadResourceResult result;

  ReadResourceResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ReadResourceResultResponse.toMC(Map<String, Object?> map) {
    return ReadResourceResultResponse(
      id: map['id'] as String,
      result: ReadResourceResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

/*
interface ReadResourceResult {
  _meta?: MetaObject;
  resultType: ResultType;
  contents: (TextResourceContents | BlobResourceContents)[];
  [key: string]: unknown;
}*/
class ReadResourceResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  List<ResourceContents> get contents => (data['contents'] as List<dynamic>)
      .map((e) => ResourceContents.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set contents(List<ResourceContents> value) =>
      data['contents'] = value.map((e) => e.toMap()).toList();

  ReadResourceResult({
    MetaObject? $meta,
    required List<ResourceContents> contents,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          'contents': contents.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ReadResourceResult.toMC(Map<String, Object?> map) {
    return ReadResourceResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      contents: (map['contents'] as List<dynamic>)
          .map((e) => ResourceContents.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' || key == 'resultType' || key == 'contents',
        ),
    );
  }
}

class ResourceTemplate extends MC {
  List<Icon>? icons;
  String name;
  String? title;
  String uriTemplate;
  String? description;
  String? mimeType;
  Annotations? annotations;
  MetaObject? $meta;

  ResourceTemplate({
    this.icons,
    required this.name,
    this.title,
    required this.uriTemplate,
    this.description,
    this.mimeType,
    this.annotations,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (title != null) 'title': title,
      'uriTemplate': uriTemplate,
      if (description != null) 'description': description,
      if (mimeType != null) 'mimeType': mimeType,
      if (annotations != null) 'annotations': annotations!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory ResourceTemplate.toMC(Map<String, Object?> map) {
    return ResourceTemplate(
      icons: (map['icons'] as List<dynamic>?)
          ?.map((e) => Icon.toMC(e as Map<String, Object?>))
          .toList(),
      name: map['name'] as String,
      title: map['title'] as String?,
      uriTemplate: map['uriTemplate'] as String,
      description: map['description'] as String?,
      mimeType: map['mimeType'] as String?,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ListResourceTemplatesRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "resources/templates/list";
  PaginatedRequestParams? params;

  ListResourceTemplatesRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ListResourceTemplatesRequest.toMC(Map<String, Object?> map) {
    return ListResourceTemplatesRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? PaginatedRequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ListResourceTemplatesResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ListResourceTemplatesResult result;

  ListResourceTemplatesResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ListResourceTemplatesResultResponse.toMC(Map<String, Object?> map) {
    return ListResourceTemplatesResultResponse(
      id: map['id'] as String,
      result: ListResourceTemplatesResult.toMC(
        map['result'] as Map<String, Object?>,
      ),
    );
  }
}

class ListResourceTemplatesResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  String? get nextCursor => data['nextCursor'] as String?;
  List<ResourceTemplate> get resourceTemplates =>
      (data['resourceTemplates'] as List<dynamic>)
          .map((e) => ResourceTemplate.toMC(e as Map<String, Object?>))
          .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set nextCursor(String? value) => data['nextCursor'] = value;
  set resourceTemplates(List<ResourceTemplate> value) =>
      data['resourceTemplates'] = value.map((e) => e.toMap()).toList();

  ListResourceTemplatesResult({
    MetaObject? $meta,
    String? nextCursor,
    required List<ResourceTemplate> resourceTemplates,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          if (nextCursor != null) 'nextCursor': nextCursor,
          'resourceTemplates': resourceTemplates.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ListResourceTemplatesResult.toMC(Map<String, Object?> map) {
    return ListResourceTemplatesResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      nextCursor: map['nextCursor'] as String?,
      resourceTemplates: (map['resourceTemplates'] as List<dynamic>)
          .map((e) => ResourceTemplate.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'nextCursor' ||
              key == 'resourceTemplates',
        ),
    );
  }
}

class SubscribeRequestParams extends MC {
  RequestMetaObject? $meta;
  String uri;

  SubscribeRequestParams({this.$meta, required this.uri});

  @override
  Map<String, Object?> toMap() {
    return {if ($meta != null) '_meta': $meta!.toMap(), 'uri': uri};
  }

  factory SubscribeRequestParams.toMC(Map<String, Object?> map) {
    return SubscribeRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      uri: map['uri'] as String,
    );
  }
}

class SubscribeRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "resources/subscribe";
  SubscribeRequestParams params;

  SubscribeRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory SubscribeRequest.toMC(Map<String, Object?> map) {
    return SubscribeRequest(
      id: map['id'] as String,
      params: SubscribeRequestParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class SubscribeResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  Result result;

  SubscribeResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory SubscribeResultResponse.toMC(Map<String, Object?> map) {
    return SubscribeResultResponse(
      id: map['id'] as String,
      result: Result.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class UnsubscribeRequestParams extends MC {
  RequestMetaObject? $meta;
  String uri;

  UnsubscribeRequestParams({this.$meta, required this.uri});

  @override
  Map<String, Object?> toMap() {
    return {if ($meta != null) '_meta': $meta!.toMap(), 'uri': uri};
  }

  factory UnsubscribeRequestParams.toMC(Map<String, Object?> map) {
    return UnsubscribeRequestParams(
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      uri: map['uri'] as String,
    );
  }
}

class UnsubscribeResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  Result result;

  UnsubscribeResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory UnsubscribeResultResponse.toMC(Map<String, Object?> map) {
    return UnsubscribeResultResponse(
      id: map['id'] as String,
      result: Result.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class Root extends MC {
  String uri;
  String? name;
  MetaObject? $meta;

  Root({required this.uri, this.name, this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {
      'uri': uri,
      if (name != null) 'name': name,
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory Root.toMC(Map<String, Object?> map) {
    return Root(
      uri: map['uri'] as String,
      name: map['name'] as String?,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ListRootsResult extends MC {
  List<Root> roots;

  ListRootsResult({required this.roots});

  @override
  Map<String, Object?> toMap() {
    return {'roots': roots.map((e) => e.toMap()).toList()};
  }

  factory ListRootsResult.toMC(Map<String, Object?> map) {
    return ListRootsResult(
      roots: (map['roots'] as List<dynamic>)
          .map((e) => Root.toMC(e as Map<String, Object?>))
          .toList(),
    );
  }
}

class ListRootsRequest extends MC {
  String method = "roots/list";
  RequestParams? params;

  ListRootsRequest({this.params});

  @override
  Map<String, Object?> toMap() {
    return {'method': method, if (params != null) 'params': params!.toMap()};
  }

  factory ListRootsRequest.toMC(Map<String, Object?> map) {
    return ListRootsRequest(
      params: map['params'] != null
          ? RequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ModelHint extends MC {
  String? name;

  ModelHint({this.name});

  @override
  Map<String, Object?> toMap() {
    return {if (name != null) 'name': name};
  }

  factory ModelHint.toMC(Map<String, Object?> map) {
    return ModelHint(name: map['name'] as String?);
  }
}

class ModelPreferences extends MC {
  List<ModelHint>? hints;
  num? costPriority;
  num? speedPriority;
  num? intelligencePriority;

  ModelPreferences({
    this.hints,
    this.costPriority,
    this.speedPriority,
    this.intelligencePriority,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (hints != null) 'hints': hints!.map((e) => e.toMap()).toList(),
      if (costPriority != null) 'costPriority': costPriority,
      if (speedPriority != null) 'speedPriority': speedPriority,
      if (intelligencePriority != null)
        'intelligencePriority': intelligencePriority,
    };
  }

  factory ModelPreferences.toMC(Map<String, Object?> map) {
    return ModelPreferences(
      hints: (map['hints'] as List<dynamic>?)
          ?.map((e) => ModelHint.toMC(e as Map<String, Object?>))
          .toList(),
      costPriority: map['costPriority'] as num?,
      speedPriority: map['speedPriority'] as num?,
      intelligencePriority: map['intelligencePriority'] as num?,
    );
  }
}

class SamplingMessage extends MC {
  Role role;
  List<ContentBlock> content;
  MetaObject? $meta;

  SamplingMessage({required this.role, required this.content, this.$meta});

  @override
  Map<String, Object?> toMap() {
    return {
      'role': role.toString(),
      'content': content.map((e) => e.toMap()).toList(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory SamplingMessage.toMC(Map<String, Object?> map) {
    return SamplingMessage(
      role: Role.to(map['role'] as String),
      content: (map['content'] as List<dynamic>)
          .map((e) => ContentBlock.toMC(e as Map<String, Object?>))
          .toList(),
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ToolChoice extends MC {
  String? mode;

  ToolChoice({this.mode});

  @override
  Map<String, Object?> toMap() {
    return {if (mode != null) 'mode': mode};
  }

  factory ToolChoice.toMC(Map<String, Object?> map) {
    return ToolChoice(mode: map['mode'] as String?);
  }
}

class ToolResultContent extends ContentBlock {
  String toolUseId;
  List<ContentBlock> content;
  Map<String, Object?>? structuredContent;
  bool? isError;

  ToolResultContent({
    required this.toolUseId,
    required this.content,
    this.structuredContent,
    this.isError,
    super.annotations,
    super.$meta,
  }) : super(type: 'tool_result', data: '', mimeType: '');

  @override
  Map<String, Object?> toMap() {
    return {
      'type': type,
      'toolUseId': toolUseId,
      'content': content.map((e) => e.toMap()).toList(),
      if (structuredContent != null) 'structuredContent': structuredContent,
      if (isError != null) 'isError': isError,
      if (annotations != null) 'annotations': annotations!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory ToolResultContent.toMC(Map<String, Object?> map) {
    return ToolResultContent(
      toolUseId: map['toolUseId'] as String,
      content: (map['content'] as List<dynamic>)
          .map((e) => ContentBlock.toMC(e as Map<String, Object?>))
          .toList(),
      structuredContent: map['structuredContent'] as Map<String, Object?>?,
      isError: map['isError'] as bool?,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ToolUseContent extends ContentBlock {
  String id;
  String name;
  Map<String, Object?> input;

  ToolUseContent({
    required this.id,
    required this.name,
    required this.input,
    super.annotations,
    super.$meta,
  }) : super(type: 'tool_use', data: '', mimeType: '');

  @override
  Map<String, Object?> toMap() {
    return {
      'type': type,
      'id': id,
      'name': name,
      'input': input,
      if (annotations != null) 'annotations': annotations!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory ToolUseContent.toMC(Map<String, Object?> map) {
    return ToolUseContent(
      id: map['id'] as String,
      name: map['name'] as String,
      input: map['input'] as Map<String, Object?>,
      annotations: map['annotations'] != null
          ? Annotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class ToolAnnotations extends MC {
  String? title;
  bool? readOnlyHint;
  bool? destructiveHint;
  bool? idempotentHint;
  bool? openWorldHint;

  ToolAnnotations({
    this.title,
    this.readOnlyHint,
    this.destructiveHint,
    this.idempotentHint,
    this.openWorldHint,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (title != null) 'title': title,
      if (readOnlyHint != null) 'readOnlyHint': readOnlyHint,
      if (destructiveHint != null) 'destructiveHint': destructiveHint,
      if (idempotentHint != null) 'idempotentHint': idempotentHint,
      if (openWorldHint != null) 'openWorldHint': openWorldHint,
    };
  }

  factory ToolAnnotations.toMC(Map<String, Object?> map) {
    return ToolAnnotations(
      title: map['title'] as String?,
      readOnlyHint: map['readOnlyHint'] as bool?,
      destructiveHint: map['destructiveHint'] as bool?,
      idempotentHint: map['idempotentHint'] as bool?,
      openWorldHint: map['openWorldHint'] as bool?,
    );
  }
}

class ToolExecution extends MC {
  String? taskSupport;

  ToolExecution({this.taskSupport});

  @override
  Map<String, Object?> toMap() {
    return {if (taskSupport != null) 'taskSupport': taskSupport};
  }

  factory ToolExecution.toMC(Map<String, Object?> map) {
    return ToolExecution(taskSupport: map['taskSupport'] as String?);
  }
}

class ToolSchema extends MC {
  String? $schema;
  String type = 'object';
  Map<String, Object?>? properties;
  List<String>? required;

  ToolSchema({
    this.$schema,
    this.properties,
    this.required,
    this.type = 'object',
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if ($schema != null) r'$schema': $schema,
      'type': type,
      if (properties != null) 'properties': properties,
      if (required != null) 'required': required,
    };
  }

  factory ToolSchema.toMC(Map<String, Object?> map) {
    return ToolSchema(
      $schema: map[r'$schema'] as String?,
      properties: map['properties'] as Map<String, Object?>?,
      required: (map['required'] as List<dynamic>?)?.cast<String>(),
      type: map['type'] as String? ?? 'object',
    );
  }
}

class Tool extends MC {
  List<Icon>? icons;
  String name;
  String? title;
  String? description;
  ToolSchema inputSchema;
  ToolExecution? execution;
  ToolSchema? outputSchema;
  ToolAnnotations? annotations;
  MetaObject? $meta;

  Tool({
    this.icons,
    required this.name,
    this.title,
    this.description,
    required this.inputSchema,
    this.execution,
    this.outputSchema,
    this.annotations,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (icons != null) 'icons': icons!.map((e) => e.toMap()).toList(),
      'name': name,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      'inputSchema': inputSchema.toMap(),
      if (execution != null) 'execution': execution!.toMap(),
      if (outputSchema != null) 'outputSchema': outputSchema!.toMap(),
      if (annotations != null) 'annotations': annotations!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory Tool.toMC(Map<String, Object?> map) {
    return Tool(
      icons: (map['icons'] as List<dynamic>?)
          ?.map((e) => Icon.toMC(e as Map<String, Object?>))
          .toList(),
      name: map['name'] as String,
      title: map['title'] as String?,
      description: map['description'] as String?,
      inputSchema: ToolSchema.toMC(map['inputSchema'] as Map<String, Object?>),
      execution: map['execution'] != null
          ? ToolExecution.toMC(map['execution'] as Map<String, Object?>)
          : null,
      outputSchema: map['outputSchema'] != null
          ? ToolSchema.toMC(map['outputSchema'] as Map<String, Object?>)
          : null,
      annotations: map['annotations'] != null
          ? ToolAnnotations.toMC(map['annotations'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class CreateMessageRequestParams extends MC {
  List<SamplingMessage> messages;
  ModelPreferences? modelPreferences;
  String? systemPrompt;
  String? includeContext;
  num? temperature;
  int maxTokens;
  List<String>? stopSequences;
  Map<String, Object?>? metadata;
  List<Tool>? tools;
  ToolChoice? toolChoice;

  CreateMessageRequestParams({
    required this.messages,
    this.modelPreferences,
    this.systemPrompt,
    this.includeContext,
    this.temperature,
    required this.maxTokens,
    this.stopSequences,
    this.metadata,
    this.tools,
    this.toolChoice,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'messages': messages.map((e) => e.toMap()).toList(),
      if (modelPreferences != null)
        'modelPreferences': modelPreferences!.toMap(),
      if (systemPrompt != null) 'systemPrompt': systemPrompt,
      if (includeContext != null) 'includeContext': includeContext,
      if (temperature != null) 'temperature': temperature,
      'maxTokens': maxTokens,
      if (stopSequences != null) 'stopSequences': stopSequences,
      if (metadata != null) 'metadata': metadata,
      if (tools != null) 'tools': tools!.map((e) => e.toMap()).toList(),
      if (toolChoice != null) 'toolChoice': toolChoice!.toMap(),
    };
  }

  factory CreateMessageRequestParams.toMC(Map<String, Object?> map) {
    return CreateMessageRequestParams(
      messages: (map['messages'] as List<dynamic>)
          .map((e) => SamplingMessage.toMC(e as Map<String, Object?>))
          .toList(),
      modelPreferences: map['modelPreferences'] != null
          ? ModelPreferences.toMC(
              map['modelPreferences'] as Map<String, Object?>,
            )
          : null,
      systemPrompt: map['systemPrompt'] as String?,
      includeContext: map['includeContext'] as String?,
      temperature: map['temperature'] as num?,
      maxTokens: map['maxTokens'] as int,
      stopSequences: (map['stopSequences'] as List<dynamic>?)?.cast<String>(),
      metadata: map['metadata'] as Map<String, Object?>?,
      tools: (map['tools'] as List<dynamic>?)
          ?.map((e) => Tool.toMC(e as Map<String, Object?>))
          .toList(),
      toolChoice: map['toolChoice'] != null
          ? ToolChoice.toMC(map['toolChoice'] as Map<String, Object?>)
          : null,
    );
  }
}

class CreateMessageRequest extends MC {
  String method = "sampling/createMessage";
  CreateMessageRequestParams params;

  CreateMessageRequest({required this.params});

  @override
  Map<String, Object?> toMap() {
    return {'method': method, 'params': params.toMap()};
  }

  factory CreateMessageRequest.toMC(Map<String, Object?> map) {
    return CreateMessageRequest(
      params: CreateMessageRequestParams.toMC(
        map['params'] as Map<String, Object?>,
      ),
    );
  }
}

class CreateMessageResult extends MC {
  String model;
  String? stopReason;
  Role role;
  List<ContentBlock> content;
  MetaObject? $meta;

  CreateMessageResult({
    required this.model,
    this.stopReason,
    required this.role,
    required this.content,
    this.$meta,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'model': model,
      if (stopReason != null) 'stopReason': stopReason,
      'role': role.toString(),
      'content': content.map((e) => e.toMap()).toList(),
      if ($meta != null) '_meta': $meta!.toMap(),
    };
  }

  factory CreateMessageResult.toMC(Map<String, Object?> map) {
    return CreateMessageResult(
      model: map['model'] as String,
      stopReason: map['stopReason'] as String?,
      role: Role.to(map['role'] as String),
      content: (map['content'] as List<dynamic>)
          .map((e) => ContentBlock.toMC(e as Map<String, Object?>))
          .toList(),
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
    );
  }
}

class CallToolRequestParams extends MC {
  TaskMetadata? task;
  RequestMetaObject? $meta;
  InputResponses? inputResponses;
  String? requestState;
  String name;
  Map<String, Object?>? arguments;

  CallToolRequestParams({
    this.task,
    this.$meta,
    this.inputResponses,
    this.requestState,
    required this.name,
    this.arguments,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      if (task != null) 'task': task!.toMap(),
      if ($meta != null) '_meta': $meta!.toMap(),
      if (inputResponses != null) 'inputResponses': inputResponses!.toMap(),
      if (requestState != null) 'requestState': requestState,
      'name': name,
      if (arguments != null) 'arguments': arguments,
    };
  }

  factory CallToolRequestParams.toMC(Map<String, Object?> map) {
    return CallToolRequestParams(
      task: map['task'] != null
          ? TaskMetadata.toMC(map['task'] as Map<String, Object?>)
          : null,
      $meta: map['_meta'] != null
          ? RequestMetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      inputResponses: map['inputResponses'],
      requestState: map['requestState'] as String?,
      name: map['name'] as String,
      arguments: map['arguments'] as Map<String, Object?>?,
    );
  }
}

class CallToolRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tools/call";
  CallToolRequestParams params;

  CallToolRequest({required this.id, required this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      'params': params.toMap(),
    };
  }

  factory CallToolRequest.toMC(Map<String, Object?> map) {
    return CallToolRequest(
      id: map['id'] as String,
      params: CallToolRequestParams.toMC(map['params'] as Map<String, Object?>),
    );
  }
}

class CallToolResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  List<ContentBlock> get content => (data['content'] as List<dynamic>)
      .map((e) => ContentBlock.toMC(e as Map<String, Object?>))
      .toList();
  Map<String, Object?>? get structuredContent =>
      data['structuredContent'] as Map<String, Object?>?;
  bool? get isError => data['isError'] as bool?;

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set content(List<ContentBlock> value) =>
      data['content'] = value.map((e) => e.toMap()).toList();
  set structuredContent(Map<String, Object?>? value) =>
      data['structuredContent'] = value;
  set isError(bool? value) => data['isError'] = value;

  CallToolResult({
    MetaObject? $meta,
    required List<ContentBlock> content,
    Map<String, Object?>? structuredContent,
    bool? isError,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          'content': content.map((e) => e.toMap()).toList(),
          if (structuredContent != null) 'structuredContent': structuredContent,
          if (isError != null) 'isError': isError,
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory CallToolResult.toMC(Map<String, Object?> map) {
    return CallToolResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      content: ((map['content'] ?? []) as List<dynamic>)
          .map((e) => ContentBlock.toMC(e as Map<String, Object?>))
          .toList(),
      structuredContent: map['structuredContent'] as Map<String, Object?>?,
      isError: map['isError'] as bool?,
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'content' ||
              key == 'structuredContent' ||
              key == 'isError',
        ),
    );
  }
}

class CallToolResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  CallToolResult result;

  CallToolResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory CallToolResultResponse.toMC(Map<String, Object?> map) {
    return CallToolResultResponse(
      id: map['id'] as String,
      result: CallToolResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class ListToolsRequest extends MC {
  String jsonrpc = "2.0";
  String id;
  String method = "tools/list";
  PaginatedRequestParams? params;

  ListToolsRequest({required this.id, this.params});

  @override
  Map<String, Object?> toMap() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'method': method,
      if (params != null) 'params': params!.toMap(),
    };
  }

  factory ListToolsRequest.toMC(Map<String, Object?> map) {
    return ListToolsRequest(
      id: map['id'] as String,
      params: map['params'] != null
          ? PaginatedRequestParams.toMC(map['params'] as Map<String, Object?>)
          : null,
    );
  }
}

class ListToolsResultResponse extends MC {
  String jsonrpc = "2.0";
  String id;
  ListToolsResult result;

  ListToolsResultResponse({required this.id, required this.result});

  @override
  Map<String, Object?> toMap() {
    return {'jsonrpc': jsonrpc, 'id': id, 'result': result.toMap()};
  }

  factory ListToolsResultResponse.toMC(Map<String, Object?> map) {
    return ListToolsResultResponse(
      id: map['id'] as String,
      result: ListToolsResult.toMC(map['result'] as Map<String, Object?>),
    );
  }
}

class ListToolsResult extends MapMC<String, Object?> {
  MetaObject? get $meta => data['_meta'] != null
      ? MetaObject.toMC(data['_meta'] as Map<String, Object?>)
      : null;
  ResultType get resultType =>
      ResultType.values.firstWhere((e) => e.value == data['resultType']);
  String? get nextCursor => data['nextCursor'] as String?;
  List<Tool> get tools => (data['tools'] as List<dynamic>)
      .map((e) => Tool.toMC(e as Map<String, Object?>))
      .toList();

  set $meta(MetaObject? value) => data['_meta'] = value?.toMap();
  set resultType(ResultType value) => data['resultType'] = value.value;
  set nextCursor(String? value) => data['nextCursor'] = value;
  set tools(List<Tool> value) =>
      data['tools'] = value.map((e) => e.toMap()).toList();

  ListToolsResult({
    MetaObject? $meta,
    String? nextCursor,
    required List<Tool> tools,
    Map<String, Object?>? additionalData,
  }) : super({
          if ($meta != null) '_meta': $meta.toMap(),
          if (nextCursor != null) 'nextCursor': nextCursor,
          'tools': tools.map((e) => e.toMap()).toList(),
          ...?additionalData,
        });

  @override
  Map<String, Object?> toMap() {
    return data;
  }

  factory ListToolsResult.toMC(Map<String, Object?> map) {
    return ListToolsResult(
      $meta: map['_meta'] != null
          ? MetaObject.toMC(map['_meta'] as Map<String, Object?>)
          : null,
      nextCursor: map['nextCursor'] as String?,
      tools: (map['tools'] as List<dynamic>)
          .map((e) => Tool.toMC(e as Map<String, Object?>))
          .toList(),
      additionalData: Map.from(map)
        ..removeWhere(
          (key, _) =>
              key == '_meta' ||
              key == 'resultType' ||
              key == 'nextCursor' ||
              key == 'tools',
        ),
    );
  }
}
