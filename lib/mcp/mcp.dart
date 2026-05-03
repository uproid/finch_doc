import 'dart:convert';
import 'package:finch/model_less.dart';

// ============================================================
// Base
// ============================================================

class McpModel extends ModelLess {
  @override
  Map<String, dynamic> toMap({
    bool hideNull = true,
    bool hideEmpty = true,
  }) {
    final Map<String, dynamic> f = {};
    fields.forEach((key, value) {
      if (hideNull && value == null) return;
      if (hideEmpty) {
        if (value is String && value.isEmpty) return;
        if (value is List && value.isEmpty) return;
        if (value is Map && value.isEmpty) return;
      }
      if (value is DateTime) {
        f[key] = value.toIso8601String();
      } else if (value is McpModel) {
        f[key] = value.toMap(hideNull: hideNull);
      } else if (value is List) {
        f[key] = value
            .map((e) => e is McpModel ? e.toMap(hideNull: hideNull) : e)
            .toList();
      } else if (value is Map<String, McpProperty>) {
        f[key] = value.map((k, v) => MapEntry(k, v.toMap()));
      } else if (value is McpArrayModel) {
        f[key] = value.toMap(hideNull: hideNull);
      } else {
        f[key] = value;
      }
    });
    return f;
  }

  T fillString<T extends McpModel>(String str) {
    fields.addAll(jsonDecode(str) as Map<String, dynamic>);
    return this as T;
  }

  T fillMap<T extends McpModel>(Map<String, dynamic> map) {
    fields.addAll(map);
    return this as T;
  }
}

class McpArrayModel extends ModelLessArray<McpModel> {
  List<Map<String, dynamic>> toMap({bool hideNull = true}) {
    return fields
            ?.map((e) => e.toMap(hideNull: hideNull))
            .toList(growable: false) ??
        [];
  }

  List<T> fillString<T extends McpModel>(String str) {
    fields?.addAll((jsonDecode(str) as List).map((e) => McpModel().fillMap(e)));
    return this as List<T>;
  }

  List<T> fillList<T extends McpModel>(List<Map<String, dynamic>> list) {
    fields?.addAll(list.map((e) => McpModel().fillMap(e)));
    return this as List<T>;
  }
}

// ============================================================
// Common Types
// ============================================================

/// An opaque token used to represent a cursor for pagination.
typedef McpCursor = String;

/// A uniquely identifying ID for a request in JSON-RPC.
typedef McpRequestId = dynamic; // String | number

/// A progress token, used to associate progress notifications with the original request.
typedef McpProgressToken = dynamic; // String | number

class McpInputSchema extends McpModel {
  String get type => get('type', def: 'object');
  List<String> get required => get('required', def: <String>[]);
  Map<String, McpProperty> get properties =>
      get('properties', def: <String, McpProperty>{});

  set type(String value) => set('type', value);
  set required(List<String> value) => set('required', value);
  set properties(Map<String, McpProperty> value) => set('properties', value);

  McpInputSchema({
    String type = 'object',
    List<String> required = const [],
    Map<String, McpProperty> properties = const {},
  }) {
    this.type = type;
    this.required = required;
    this.properties = properties;
  }
}

class McpOutputSchema extends McpInputSchema {
  McpOutputSchema({
    super.type,
    super.required,
    super.properties,
  });
}

class McpProperty extends McpModel {
  String get type => get('type', def: 'string');
  String? get format => get('format', def: null);
  String? get description => get('description', def: null);
  bool? get nullable => get('nullable', def: null);
  bool? get readOnly => get('readOnly', def: null);
  bool? get writeOnly => get('writeOnly', def: null);

  set type(String value) => set('type', value);
  set format(String? value) => set('format', value);
  set description(String? value) => set('description', value);
  set nullable(bool? value) => set('nullable', value);
  set readOnly(bool? value) => set('readOnly', value);
  set writeOnly(bool? value) => set('writeOnly', value);

  McpProperty({
    String type = 'string',
    String? format,
    String? description,
    bool? nullable,
    bool? readOnly,
    bool? writeOnly,
  }) {
    this.type = type;
    this.format = format;
    this.description = description;
    this.nullable = nullable;
    this.readOnly = readOnly;
    this.writeOnly = writeOnly;
  }
}

/// Optional annotations for the client.
class McpAnnotations extends McpModel {
  /// Who the intended audience of this object or data is.
  List<String>? get audience => get<List<String>?>('audience', def: null);

  /// How important this data is for operating the server. 1 = most important, 0 = least.
  double? get priority => get<double?>('priority', def: null);

  /// The moment the resource was last modified, as an ISO 8601 formatted string.
  String? get lastModified => get<String?>('lastModified', def: null);

  set audience(List<String>? value) => set('audience', value);
  set priority(double? value) => set('priority', value);
  set lastModified(String? value) => set('lastModified', value);

  McpAnnotations({
    List<String>? audience,
    double? priority,
    String? lastModified,
  }) {
    this.audience = audience;
    this.priority = priority;
    this.lastModified = lastModified;
  }
}

/// An optionally-sized icon that can be displayed in a user interface.
class McpIcon extends McpModel {
  /// A standard URI pointing to an icon resource.
  String get src => get('src');

  /// Optional MIME type override.
  String? get mimeType => get('mimeType', def: null);

  /// Optional array of strings specifying sizes (e.g., "48x48", "any").
  List<String>? get sizes => get<List<String>?>('sizes', def: null);

  /// Optional theme specifier: "light" or "dark".
  String? get theme => get('theme', def: null);

  set src(String value) => set('src', value);
  set mimeType(String? value) => set('mimeType', value);
  set sizes(List<String>? value) => set('sizes', value);
  set theme(String? value) => set('theme', value);

  McpIcon({
    required String src,
    String? mimeType,
    List<String>? sizes,
    String? theme,
  }) {
    this.src = src;
    this.mimeType = mimeType;
    this.sizes = sizes;
    this.theme = theme;
  }
}

// ============================================================
// JSON-RPC Base
// ============================================================

class McpError extends McpModel {
  /// The error type that occurred.
  int get code => get('code');

  /// A short description of the error.
  String get message => get('message');

  /// Additional information about the error.
  dynamic get data => get('data', def: null);

  set code(int value) => set('code', value);
  set message(String value) => set('message', value);
  set data(dynamic value) => set('data', value);

  McpError({required int code, required String message, dynamic data}) {
    this.code = code;
    this.message = message;
    this.data = data;
  }
}

class McpJSONRPCResponse extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get<dynamic>('id', def: null);
  dynamic get result => get('result');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set result(dynamic value) => set('result', value);

  McpJSONRPCResponse({
    String jsonrpc = '2.0',
    dynamic id,
    required dynamic result,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.result = result;
  }
}

class McpJSONRPCErrorResponse extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get<dynamic>('id', def: null);
  McpError get error => get('error');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set error(McpError value) => set('error', value);

  McpJSONRPCErrorResponse({
    String jsonrpc = '2.0',
    dynamic id,
    required McpError error,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.error = error;
  }
}

class McpJSONRPCNotification extends McpModel {
  String get method => get('method');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);
  String get jsonrpc => get('jsonrpc', def: '2.0');

  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);
  set jsonrpc(String value) => set('jsonrpc', value);

  McpJSONRPCNotification({
    required String method,
    Map<String, dynamic>? params,
    String jsonrpc = '2.0',
  }) {
    this.method = method;
    this.params = params;
    this.jsonrpc = jsonrpc;
  }
}

class McpJSONRPCRequest extends McpModel {
  String get method => get('method');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');

  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);
  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);

  McpJSONRPCRequest({
    required String method,
    Map<String, dynamic>? params,
    String jsonrpc = '2.0',
    required dynamic id,
  }) {
    this.method = method;
    this.params = params;
    this.jsonrpc = jsonrpc;
    this.id = id;
  }
}

// ============================================================
// Content Types
// ============================================================

/// Text provided to or from an LLM.
class McpTextContent extends McpContent {
  String get type => get('type', def: 'text');
  String get text => get('text');
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set text(String value) => set('text', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpTextContent({
    String type = 'text',
    required String text,
    McpAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.text = text;
    this.annotations = annotations;
    this.meta = meta;
  }
}

/// An image provided to or from an LLM.
class McpImageContent extends McpContent {
  String get type => get('type', def: 'image');

  /// The base64-encoded image data.
  String get data => get('data');

  /// The MIME type of the image.
  String get mimeType => get('mimeType');
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set data(String value) => set('data', value);
  set mimeType(String value) => set('mimeType', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpImageContent({
    String type = 'image',
    required String data,
    required String mimeType,
    McpAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.data = data;
    this.mimeType = mimeType;
    this.annotations = annotations;
    this.meta = meta;
  }
}

/// Audio provided to or from an LLM.
class McpAudioContent extends McpContent {
  String get type => get('type', def: 'audio');

  /// The base64-encoded audio data.
  String get data => get('data');

  /// The MIME type of the audio.
  String get mimeType => get('mimeType');
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set data(String value) => set('data', value);
  set mimeType(String value) => set('mimeType', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpAudioContent({
    String type = 'audio',
    required String data,
    required String mimeType,
    McpAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.data = data;
    this.mimeType = mimeType;
    this.annotations = annotations;
    this.meta = meta;
  }
}

/// A resource that the server is capable of reading, included in a prompt or tool call result.
class McpResourceLink extends McpModel {
  String get type => get('type', def: 'resource_link');
  String get name => get('name');
  String? get title => get('title', def: null);
  String get uri => get('uri');
  String? get description => get('description', def: null);
  String? get mimeType => get('mimeType', def: null);
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  int? get size => get<int?>('size', def: null);
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set uri(String value) => set('uri', value);
  set description(String? value) => set('description', value);
  set mimeType(String? value) => set('mimeType', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set size(int? value) => set('size', value);
  set icons(List<McpIcon>? value) => set('icons', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpResourceLink({
    String type = 'resource_link',
    required String name,
    String? title,
    required String uri,
    String? description,
    String? mimeType,
    McpAnnotations? annotations,
    int? size,
    List<McpIcon>? icons,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.name = name;
    this.title = title;
    this.uri = uri;
    this.description = description;
    this.mimeType = mimeType;
    this.annotations = annotations;
    this.size = size;
    this.icons = icons;
    this.meta = meta;
  }
}

class McpTextResourceContents extends McpModel {
  String get uri => get('uri');
  String? get mimeType => get('mimeType', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The text of the item.
  String get text => get('text');

  set uri(String value) => set('uri', value);
  set mimeType(String? value) => set('mimeType', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set text(String value) => set('text', value);

  McpTextResourceContents({
    required String uri,
    String? mimeType,
    Map<String, dynamic>? meta,
    required String text,
  }) {
    this.uri = uri;
    this.mimeType = mimeType;
    this.meta = meta;
    this.text = text;
  }
}

class McpBlobResourceContents extends McpModel {
  String get uri => get('uri');
  String? get mimeType => get('mimeType', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// A base64-encoded string representing the binary data of the item.
  String get blob => get('blob');

  set uri(String value) => set('uri', value);
  set mimeType(String? value) => set('mimeType', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set blob(String value) => set('blob', value);

  McpBlobResourceContents({
    required String uri,
    String? mimeType,
    Map<String, dynamic>? meta,
    required String blob,
  }) {
    this.uri = uri;
    this.mimeType = mimeType;
    this.meta = meta;
    this.blob = blob;
  }
}

/// The contents of a resource, embedded into a prompt or tool call result.
class McpEmbeddedResource extends McpModel {
  String get type => get('type', def: 'resource');

  /// Either McpTextResourceContents or McpBlobResourceContents
  dynamic get resource => get('resource');
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set resource(dynamic value) => set('resource', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpEmbeddedResource({
    String type = 'resource',
    required dynamic resource,
    McpAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.resource = resource;
    this.annotations = annotations;
    this.meta = meta;
  }
}

// ============================================================
// completion/complete
// ============================================================

class McpPromptReference extends McpModel {
  String get type => get('type', def: 'ref/prompt');
  String get name => get('name');
  String? get title => get('title', def: null);

  set type(String value) => set('type', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);

  McpPromptReference({
    String type = 'ref/prompt',
    required String name,
    String? title,
  }) {
    this.type = type;
    this.name = name;
    this.title = title;
  }
}

class McpResourceTemplateReference extends McpModel {
  String get type => get('type', def: 'ref/resource');

  /// The URI or URI template of the resource.
  String get uri => get('uri');

  set type(String value) => set('type', value);
  set uri(String value) => set('uri', value);

  McpResourceTemplateReference({
    String type = 'ref/resource',
    required String uri,
  }) {
    this.type = type;
    this.uri = uri;
  }
}

class McpCompleteRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// PromptReference or ResourceTemplateReference
  dynamic get ref => get('ref');

  /// The argument's information: { name, value }
  Map<String, String> get argument => get('argument', def: <String, String>{});

  /// Additional context for completions
  Map<String, dynamic>? get context =>
      get<Map<String, dynamic>?>('context', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set ref(dynamic value) => set('ref', value);
  set argument(Map<String, String> value) => set('argument', value);
  set context(Map<String, dynamic>? value) => set('context', value);

  McpCompleteRequestParams({
    Map<String, dynamic>? meta,
    required dynamic ref,
    required Map<String, String> argument,
    Map<String, dynamic>? context,
  }) {
    this.meta = meta;
    this.ref = ref;
    this.argument = argument;
    this.context = context;
  }
}

class McpCompleteRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'completion/complete');
  McpCompleteRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpCompleteRequestParams value) => set('params', value);

  McpCompleteRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'completion/complete',
    required McpCompleteRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpCompleteResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// { values: string[], total?: number, hasMore?: boolean }
  Map<String, dynamic> get completion =>
      get('completion', def: <String, dynamic>{});

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set completion(Map<String, dynamic> value) => set('completion', value);

  McpCompleteResult({
    Map<String, dynamic>? meta,
    required Map<String, dynamic> completion,
  }) {
    this.meta = meta;
    this.completion = completion;
  }
}

// ============================================================
// elicitation/create
// ============================================================

/// Schema types for elicitation form fields
class McpStringSchema extends McpModel {
  String get type => get('type', def: 'string');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  int? get minLength => get<int?>('minLength', def: null);
  int? get maxLength => get<int?>('maxLength', def: null);

  /// "uri" | "email" | "date" | "date-time"
  String? get format => get('format', def: null);
  String? get defaultValue => get<String?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set minLength(int? value) => set('minLength', value);
  set maxLength(int? value) => set('maxLength', value);
  set format(String? value) => set('format', value);
  set defaultValue(String? value) => set('default', value);

  McpStringSchema({
    String type = 'string',
    String? title,
    String? description,
    int? minLength,
    int? maxLength,
    String? format,
    String? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.minLength = minLength;
    this.maxLength = maxLength;
    this.format = format;
    this.defaultValue = defaultValue;
  }
}

class McpNumberSchema extends McpModel {
  /// "number" | "integer"
  String get type => get('type', def: 'number');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  num? get minimum => get<num?>('minimum', def: null);
  num? get maximum => get<num?>('maximum', def: null);
  num? get defaultValue => get<num?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set minimum(num? value) => set('minimum', value);
  set maximum(num? value) => set('maximum', value);
  set defaultValue(num? value) => set('default', value);

  McpNumberSchema({
    String type = 'number',
    String? title,
    String? description,
    num? minimum,
    num? maximum,
    num? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.minimum = minimum;
    this.maximum = maximum;
    this.defaultValue = defaultValue;
  }
}

class McpBooleanSchema extends McpModel {
  String get type => get('type', def: 'boolean');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  bool? get defaultValue => get<bool?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set defaultValue(bool? value) => set('default', value);

  McpBooleanSchema({
    String type = 'boolean',
    String? title,
    String? description,
    bool? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.defaultValue = defaultValue;
  }
}

/// Single-selection enumeration without display titles.
class McpUntitledSingleSelectEnumSchema extends McpModel {
  String get type => get('type', def: 'string');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  List<String> get enumValues => get('enum', def: <String>[]);
  String? get defaultValue => get<String?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set enumValues(List<String> value) => set('enum', value);
  set defaultValue(String? value) => set('default', value);

  McpUntitledSingleSelectEnumSchema({
    String type = 'string',
    String? title,
    String? description,
    required List<String> enumValues,
    String? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.enumValues = enumValues;
    this.defaultValue = defaultValue;
  }
}

/// Single-selection enumeration with display titles for each option.
class McpTitledSingleSelectEnumSchema extends McpModel {
  String get type => get('type', def: 'string');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);

  /// Array of { const: string, title: string }
  List<Map<String, String>> get oneOf =>
      get('oneOf', def: <Map<String, String>>[]);
  String? get defaultValue => get<String?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set oneOf(List<Map<String, String>> value) => set('oneOf', value);
  set defaultValue(String? value) => set('default', value);

  McpTitledSingleSelectEnumSchema({
    String type = 'string',
    String? title,
    String? description,
    required List<Map<String, String>> oneOf,
    String? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.oneOf = oneOf;
    this.defaultValue = defaultValue;
  }
}

/// Legacy enum schema (use TitledSingleSelectEnumSchema instead).
class McpLegacyTitledEnumSchema extends McpModel {
  String get type => get('type', def: 'string');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  List<String> get enumValues => get('enum', def: <String>[]);

  /// (Legacy) Display names for enum values.
  List<String>? get enumNames => get<List<String>?>('enumNames', def: null);
  String? get defaultValue => get<String?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set enumValues(List<String> value) => set('enum', value);
  set enumNames(List<String>? value) => set('enumNames', value);
  set defaultValue(String? value) => set('default', value);

  McpLegacyTitledEnumSchema({
    String type = 'string',
    String? title,
    String? description,
    required List<String> enumValues,
    List<String>? enumNames,
    String? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.enumValues = enumValues;
    this.enumNames = enumNames;
    this.defaultValue = defaultValue;
  }
}

/// Multiple-selection enumeration without display titles.
class McpUntitledMultiSelectEnumSchema extends McpModel {
  String get type => get('type', def: 'array');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  int? get minItems => get<int?>('minItems', def: null);
  int? get maxItems => get<int?>('maxItems', def: null);

  /// { type: "string", enum: string[] }
  Map<String, dynamic> get items => get('items', def: <String, dynamic>{});
  List<String>? get defaultValue => get<List<String>?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set minItems(int? value) => set('minItems', value);
  set maxItems(int? value) => set('maxItems', value);
  set items(Map<String, dynamic> value) => set('items', value);
  set defaultValue(List<String>? value) => set('default', value);

  McpUntitledMultiSelectEnumSchema({
    String type = 'array',
    String? title,
    String? description,
    int? minItems,
    int? maxItems,
    required Map<String, dynamic> items,
    List<String>? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.minItems = minItems;
    this.maxItems = maxItems;
    this.items = items;
    this.defaultValue = defaultValue;
  }
}

/// Multiple-selection enumeration with display titles for each option.
class McpTitledMultiSelectEnumSchema extends McpModel {
  String get type => get('type', def: 'array');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  int? get minItems => get<int?>('minItems', def: null);
  int? get maxItems => get<int?>('maxItems', def: null);

  /// { anyOf: { const: string, title: string }[] }
  Map<String, dynamic> get items => get('items', def: <String, dynamic>{});
  List<String>? get defaultValue => get<List<String>?>('default', def: null);

  set type(String value) => set('type', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set minItems(int? value) => set('minItems', value);
  set maxItems(int? value) => set('maxItems', value);
  set items(Map<String, dynamic> value) => set('items', value);
  set defaultValue(List<String>? value) => set('default', value);

  McpTitledMultiSelectEnumSchema({
    String type = 'array',
    String? title,
    String? description,
    int? minItems,
    int? maxItems,
    required Map<String, dynamic> items,
    List<String>? defaultValue,
  }) {
    this.type = type;
    this.title = title;
    this.description = description;
    this.minItems = minItems;
    this.maxItems = maxItems;
    this.items = items;
    this.defaultValue = defaultValue;
  }
}

class McpElicitRequestFormParams extends McpModel {
  Map<String, dynamic>? get task =>
      get<Map<String, dynamic>?>('task', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// "form" or null (defaults to "form")
  String? get mode => get<String?>('mode', def: null);

  /// The message to present to the user.
  String get message => get('message');

  /// A restricted subset of JSON Schema with only primitive types.
  Map<String, dynamic> get requestedSchema =>
      get('requestedSchema', def: <String, dynamic>{});

  set task(Map<String, dynamic>? value) => set('task', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set mode(String? value) => set('mode', value);
  set message(String value) => set('message', value);
  set requestedSchema(Map<String, dynamic> value) =>
      set('requestedSchema', value);

  McpElicitRequestFormParams({
    Map<String, dynamic>? task,
    Map<String, dynamic>? meta,
    String? mode,
    required String message,
    required Map<String, dynamic> requestedSchema,
  }) {
    this.task = task;
    this.meta = meta;
    this.mode = mode;
    this.message = message;
    this.requestedSchema = requestedSchema;
  }
}

class McpElicitRequestURLParams extends McpModel {
  Map<String, dynamic>? get task =>
      get<Map<String, dynamic>?>('task', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String get mode => get('mode', def: 'url');

  /// The message to present to the user explaining why the interaction is needed.
  String get message => get('message');

  /// The ID of the elicitation, unique within the context of the server.
  String get elicitationId => get('elicitationId');

  /// The URL that the user should navigate to.
  String get url => get('url');

  set task(Map<String, dynamic>? value) => set('task', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set mode(String value) => set('mode', value);
  set message(String value) => set('message', value);
  set elicitationId(String value) => set('elicitationId', value);
  set url(String value) => set('url', value);

  McpElicitRequestURLParams({
    Map<String, dynamic>? task,
    Map<String, dynamic>? meta,
    String mode = 'url',
    required String message,
    required String elicitationId,
    required String url,
  }) {
    this.task = task;
    this.meta = meta;
    this.mode = mode;
    this.message = message;
    this.elicitationId = elicitationId;
    this.url = url;
  }
}

class McpElicitRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'elicitation/create');

  /// ElicitRequestFormParams or ElicitRequestURLParams
  dynamic get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(dynamic value) => set('params', value);

  McpElicitRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'elicitation/create',
    required dynamic params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

/// The client's response to an elicitation request.
class McpElicitResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// "accept" | "decline" | "cancel"
  String get action => get('action');

  /// The submitted form data, only present when action is "accept" and mode was "form".
  Map<String, dynamic>? get content =>
      get<Map<String, dynamic>?>('content', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set action(String value) => set('action', value);
  set content(Map<String, dynamic>? value) => set('content', value);

  McpElicitResult({
    Map<String, dynamic>? meta,
    required String action,
    Map<String, dynamic>? content,
  }) {
    this.meta = meta;
    this.action = action;
    this.content = content;
  }
}

// ============================================================
// initialize
// ============================================================

class McpImplementation extends McpModel {
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  String get name => get('name');
  String? get title => get('title', def: null);
  String get version => get('version');
  String? get description => get('description', def: null);
  String? get websiteUrl => get('websiteUrl', def: null);

  set icons(List<McpIcon>? value) => set('icons', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set version(String value) => set('version', value);
  set description(String? value) => set('description', value);
  set websiteUrl(String? value) => set('websiteUrl', value);

  McpImplementation({
    List<McpIcon>? icons,
    required String name,
    String? title,
    required String version,
    String? description,
    String? websiteUrl,
  }) {
    this.icons = icons;
    this.name = name;
    this.title = title;
    this.version = version;
    this.description = description;
    this.websiteUrl = websiteUrl;
  }
}

class McpClientCapabilities extends McpModel {
  Map<String, dynamic>? get experimental =>
      get<Map<String, dynamic>?>('experimental', def: null);
  Map<String, dynamic>? get roots =>
      get<Map<String, dynamic>?>('roots', def: null);
  Map<String, dynamic>? get sampling =>
      get<Map<String, dynamic>?>('sampling', def: null);
  Map<String, dynamic>? get elicitation =>
      get<Map<String, dynamic>?>('elicitation', def: null);
  Map<String, dynamic>? get tasks =>
      get<Map<String, dynamic>?>('tasks', def: null);

  set experimental(Map<String, dynamic>? value) => set('experimental', value);
  set roots(Map<String, dynamic>? value) => set('roots', value);
  set sampling(Map<String, dynamic>? value) => set('sampling', value);
  set elicitation(Map<String, dynamic>? value) => set('elicitation', value);
  set tasks(Map<String, dynamic>? value) => set('tasks', value);

  McpClientCapabilities({
    Map<String, dynamic>? experimental,
    Map<String, dynamic>? roots,
    Map<String, dynamic>? sampling,
    Map<String, dynamic>? elicitation,
    Map<String, dynamic>? tasks,
  }) {
    this.experimental = experimental;
    this.roots = roots;
    this.sampling = sampling;
    this.elicitation = elicitation;
    this.tasks = tasks;
  }
}

class McpServerCapabilities extends McpModel {
  Map<String, dynamic>? get experimental =>
      get<Map<String, dynamic>?>('experimental', def: null);
  dynamic get logging => get<dynamic>('logging', def: null);
  dynamic get completions => get<dynamic>('completions', def: null);
  Map<String, dynamic>? get prompts =>
      get<Map<String, dynamic>?>('prompts', def: null);
  Map<String, dynamic>? get resources =>
      get<Map<String, dynamic>?>('resources', def: null);
  Map<String, dynamic>? get tools =>
      get<Map<String, dynamic>?>('tools', def: null);
  Map<String, dynamic>? get tasks =>
      get<Map<String, dynamic>?>('tasks', def: null);

  set experimental(Map<String, dynamic>? value) => set('experimental', value);
  set logging(dynamic value) => set('logging', value);
  set completions(dynamic value) => set('completions', value);
  set prompts(Map<String, dynamic>? value) => set('prompts', value);
  set resources(Map<String, dynamic>? value) => set('resources', value);
  set tools(Map<String, dynamic>? value) => set('tools', value);
  set tasks(Map<String, dynamic>? value) => set('tasks', value);

  McpServerCapabilities({
    Map<String, dynamic>? experimental,
    dynamic logging,
    dynamic completions,
    Map<String, dynamic>? prompts,
    Map<String, dynamic>? resources,
    Map<String, dynamic>? tools,
    Map<String, dynamic>? tasks,
  }) {
    this.experimental = experimental;
    this.logging = logging;
    this.completions = completions;
    this.prompts = prompts;
    this.resources = resources;
    this.tools = tools;
    this.tasks = tasks;
  }
}

class McpInitializeRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The latest version of the Model Context Protocol that the client supports.
  String get protocolVersion => get('protocolVersion');
  McpClientCapabilities get capabilities => get('capabilities');
  McpImplementation get clientInfo => get('clientInfo');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set protocolVersion(String value) => set('protocolVersion', value);
  set capabilities(McpClientCapabilities value) => set('capabilities', value);
  set clientInfo(McpImplementation value) => set('clientInfo', value);

  McpInitializeRequestParams({
    Map<String, dynamic>? meta,
    required String protocolVersion,
    required McpClientCapabilities capabilities,
    required McpImplementation clientInfo,
  }) {
    this.meta = meta;
    this.protocolVersion = protocolVersion;
    this.capabilities = capabilities;
    this.clientInfo = clientInfo;
  }
}

class McpInitializeRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'initialize');
  McpInitializeRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpInitializeRequestParams value) => set('params', value);

  McpInitializeRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'initialize',
    required McpInitializeRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpInitializeResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The version of the Model Context Protocol the server wants to use.
  String get protocolVersion => get('protocolVersion');
  McpServerCapabilities get capabilities => get('capabilities');
  McpImplementation get serverInfo => get('serverInfo');

  /// Instructions describing how to use the server and its features.
  String? get instructions => get<String?>('instructions', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set protocolVersion(String value) => set('protocolVersion', value);
  set capabilities(McpServerCapabilities value) => set('capabilities', value);
  set serverInfo(McpImplementation value) => set('serverInfo', value);
  set instructions(String? value) => set('instructions', value);

  McpInitializeResult({
    Map<String, dynamic>? meta,
    required String protocolVersion,
    required McpServerCapabilities capabilities,
    required McpImplementation serverInfo,
    String? instructions,
  }) {
    this.meta = meta;
    this.protocolVersion = protocolVersion;
    this.capabilities = capabilities;
    this.serverInfo = serverInfo;
    this.instructions = instructions;
  }
}

// ============================================================
// logging/setLevel
// ============================================================

class McpSetLevelRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// "debug" | "info" | "notice" | "warning" | "error" | "critical" | "alert" | "emergency"
  String get level => get('level');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set level(String value) => set('level', value);

  McpSetLevelRequestParams({
    Map<String, dynamic>? meta,
    required String level,
  }) {
    this.meta = meta;
    this.level = level;
  }
}

class McpSetLevelRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'logging/setLevel');
  McpSetLevelRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpSetLevelRequestParams value) => set('params', value);

  McpSetLevelRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'logging/setLevel',
    required McpSetLevelRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// notifications/cancelled
// ============================================================

class McpCancelledNotificationParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The ID of the request to cancel.
  dynamic get requestId => get<dynamic>('requestId', def: null);

  /// An optional string describing the reason for the cancellation.
  String? get reason => get<String?>('reason', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set requestId(dynamic value) => set('requestId', value);
  set reason(String? value) => set('reason', value);

  McpCancelledNotificationParams({
    Map<String, dynamic>? meta,
    dynamic requestId,
    String? reason,
  }) {
    this.meta = meta;
    this.requestId = requestId;
    this.reason = reason;
  }
}

class McpCancelledNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/cancelled');
  McpCancelledNotificationParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(McpCancelledNotificationParams value) => set('params', value);

  McpCancelledNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/cancelled',
    required McpCancelledNotificationParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// notifications/progress
// ============================================================

class McpProgressNotificationParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The progress token from the initial request.
  dynamic get progressToken => get('progressToken');

  /// The progress thus far.
  num get progress => get('progress');

  /// Total number of items to process, if known.
  num? get total => get<num?>('total', def: null);

  /// An optional message describing the current progress.
  String? get message => get<String?>('message', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set progressToken(dynamic value) => set('progressToken', value);
  set progress(num value) => set('progress', value);
  set total(num? value) => set('total', value);
  set message(String? value) => set('message', value);

  McpProgressNotificationParams({
    Map<String, dynamic>? meta,
    required dynamic progressToken,
    required num progress,
    num? total,
    String? message,
  }) {
    this.meta = meta;
    this.progressToken = progressToken;
    this.progress = progress;
    this.total = total;
    this.message = message;
  }
}

class McpProgressNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/progress');
  McpProgressNotificationParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(McpProgressNotificationParams value) => set('params', value);

  McpProgressNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/progress',
    required McpProgressNotificationParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// notifications/message (logging)
// ============================================================

class McpLoggingMessageNotificationParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The severity of this log message.
  String get level => get('level');

  /// An optional name of the logger issuing this message.
  String? get logger => get<String?>('logger', def: null);

  /// The data to be logged.
  dynamic get data => get('data');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set level(String value) => set('level', value);
  set logger(String? value) => set('logger', value);
  set data(dynamic value) => set('data', value);

  McpLoggingMessageNotificationParams({
    Map<String, dynamic>? meta,
    required String level,
    String? logger,
    required dynamic data,
  }) {
    this.meta = meta;
    this.level = level;
    this.logger = logger;
    this.data = data;
  }
}

class McpLoggingMessageNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/message');
  McpLoggingMessageNotificationParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(McpLoggingMessageNotificationParams value) => set('params', value);

  McpLoggingMessageNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/message',
    required McpLoggingMessageNotificationParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// notifications/resources/updated
// ============================================================

class McpResourceUpdatedNotificationParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The URI of the resource that has been updated.
  String get uri => get('uri');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set uri(String value) => set('uri', value);

  McpResourceUpdatedNotificationParams({
    Map<String, dynamic>? meta,
    required String uri,
  }) {
    this.meta = meta;
    this.uri = uri;
  }
}

class McpResourceUpdatedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/resources/updated');
  McpResourceUpdatedNotificationParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(McpResourceUpdatedNotificationParams value) =>
      set('params', value);

  McpResourceUpdatedNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/resources/updated',
    required McpResourceUpdatedNotificationParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// notifications/elicitation/complete
// ============================================================

class McpElicitationCompleteNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/elicitation/complete');

  /// { elicitationId: string }
  Map<String, dynamic> get params => get('params', def: <String, dynamic>{});

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic> value) => set('params', value);

  McpElicitationCompleteNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/elicitation/complete',
    required String elicitationId,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    params = {'elicitationId': elicitationId};
  }
}

// ============================================================
// tasks
// ============================================================

class McpTaskMetadata extends McpModel {
  /// Requested duration in milliseconds to retain task from creation.
  int? get ttl => get<int?>('ttl', def: null);

  set ttl(int? value) => set('ttl', value);

  McpTaskMetadata({int? ttl}) {
    this.ttl = ttl;
  }
}

class McpTask extends McpModel {
  /// The task identifier.
  String get taskId => get('taskId');

  /// Current task state: "working" | "input_required" | "completed" | "failed" | "cancelled"
  String get status => get('status');

  /// Optional human-readable message describing the current task state.
  String? get statusMessage => get<String?>('statusMessage', def: null);

  /// ISO 8601 timestamp when the task was created.
  String get createdAt => get('createdAt');

  /// ISO 8601 timestamp when the task was last updated.
  String get lastUpdatedAt => get('lastUpdatedAt');

  /// Actual retention duration from creation in milliseconds, null for unlimited.
  dynamic get ttl => get('ttl'); // number | null

  /// Suggested polling interval in milliseconds.
  int? get pollInterval => get<int?>('pollInterval', def: null);

  set taskId(String value) => set('taskId', value);
  set status(String value) => set('status', value);
  set statusMessage(String? value) => set('statusMessage', value);
  set createdAt(String value) => set('createdAt', value);
  set lastUpdatedAt(String value) => set('lastUpdatedAt', value);
  set ttl(dynamic value) => set('ttl', value);
  set pollInterval(int? value) => set('pollInterval', value);

  McpTask({
    required String taskId,
    required String status,
    String? statusMessage,
    required String createdAt,
    required String lastUpdatedAt,
    required dynamic ttl,
    int? pollInterval,
  }) {
    this.taskId = taskId;
    this.status = status;
    this.statusMessage = statusMessage;
    this.createdAt = createdAt;
    this.lastUpdatedAt = lastUpdatedAt;
    this.ttl = ttl;
    this.pollInterval = pollInterval;
  }
}

class McpCreateTaskResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  McpTask get task => get('task');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set task(McpTask value) => set('task', value);

  McpCreateTaskResult({Map<String, dynamic>? meta, required McpTask task}) {
    this.meta = meta;
    this.task = task;
  }
}

class McpTaskStatusNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/tasks/status');

  /// NotificationParams & Task
  Map<String, dynamic> get params => get('params', def: <String, dynamic>{});

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic> value) => set('params', value);

  McpTaskStatusNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/tasks/status',
    required Map<String, dynamic> params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

// tasks/get
class McpGetTaskRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tasks/get');

  /// { taskId: string }
  Map<String, dynamic> get params => get('params', def: <String, dynamic>{});

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic> value) => set('params', value);

  McpGetTaskRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tasks/get',
    required String taskId,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    params = {'taskId': taskId};
  }
}

// tasks/result
class McpGetTaskPayloadRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tasks/result');

  /// { taskId: string }
  Map<String, dynamic> get params => get('params', def: <String, dynamic>{});

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic> value) => set('params', value);

  McpGetTaskPayloadRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tasks/result',
    required String taskId,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    params = {'taskId': taskId};
  }
}

// tasks/list
class McpListTasksRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tasks/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListTasksRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tasks/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListTasksResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get nextCursor => get<String?>('nextCursor', def: null);
  List<McpTask> get tasks => get('tasks', def: <McpTask>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set nextCursor(String? value) => set('nextCursor', value);
  set tasks(List<McpTask> value) => set('tasks', value);

  McpListTasksResult({
    Map<String, dynamic>? meta,
    String? nextCursor,
    required List<McpTask> tasks,
  }) {
    this.meta = meta;
    this.nextCursor = nextCursor;
    this.tasks = tasks;
  }
}

// tasks/cancel
class McpCancelTaskRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tasks/cancel');

  /// { taskId: string }
  Map<String, dynamic> get params => get('params', def: <String, dynamic>{});

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic> value) => set('params', value);

  McpCancelTaskRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tasks/cancel',
    required String taskId,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    params = {'taskId': taskId};
  }
}

// ============================================================
// prompts/get & prompts/list
// ============================================================

class McpPromptArgument extends McpModel {
  String get name => get('name');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  bool? get required => get<bool?>('required', def: null);

  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set required(bool? value) => set('required', value);

  McpPromptArgument({
    required String name,
    String? title,
    String? description,
    bool? required,
  }) {
    this.name = name;
    this.title = title;
    this.description = description;
    this.required = required;
  }
}

/// A prompt or prompt template that the server offers.
class McpPrompt extends McpModel {
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  String get name => get('name');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);
  List<McpPromptArgument>? get arguments =>
      get<List<McpPromptArgument>?>('arguments', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set icons(List<McpIcon>? value) => set('icons', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set arguments(List<McpPromptArgument>? value) => set('arguments', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpPrompt({
    List<McpIcon>? icons,
    required String name,
    String? title,
    String? description,
    List<McpPromptArgument>? arguments,
    Map<String, dynamic>? meta,
  }) {
    this.icons = icons;
    this.name = name;
    this.title = title;
    this.description = description;
    this.arguments = arguments;
    this.meta = meta;
  }
}

/// Describes a message returned as part of a prompt.
class McpPromptMessage extends McpModel {
  /// "user" | "assistant"
  String get role => get('role');

  /// TextContent | ImageContent | AudioContent | ResourceLink | EmbeddedResource
  dynamic get content => get('content');

  set role(String value) => set('role', value);
  set content(dynamic value) => set('content', value);

  McpPromptMessage({required String role, required dynamic content}) {
    this.role = role;
    this.content = content;
  }
}

class McpGetPromptRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The name of the prompt or prompt template.
  String get name => get('name');

  /// Arguments to use for templating the prompt.
  Map<String, String>? get arguments =>
      get<Map<String, String>?>('arguments', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set name(String value) => set('name', value);
  set arguments(Map<String, String>? value) => set('arguments', value);

  McpGetPromptRequestParams({
    Map<String, dynamic>? meta,
    required String name,
    Map<String, String>? arguments,
  }) {
    this.meta = meta;
    this.name = name;
    this.arguments = arguments;
  }
}

class McpGetPromptRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'prompts/get');
  McpGetPromptRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpGetPromptRequestParams value) => set('params', value);

  McpGetPromptRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'prompts/get',
    required McpGetPromptRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpGetPromptResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get description => get<String?>('description', def: null);
  List<McpPromptMessage> get messages =>
      get('messages', def: <McpPromptMessage>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set description(String? value) => set('description', value);
  set messages(List<McpPromptMessage> value) => set('messages', value);

  McpGetPromptResult({
    Map<String, dynamic>? meta,
    String? description,
    required List<McpPromptMessage> messages,
  }) {
    this.meta = meta;
    this.description = description;
    this.messages = messages;
  }
}

class McpListPromptsRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'prompts/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListPromptsRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'prompts/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListPromptsResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get nextCursor => get<String?>('nextCursor', def: null);
  List<McpPrompt> get prompts => get('prompts', def: <McpPrompt>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set nextCursor(String? value) => set('nextCursor', value);
  set prompts(List<McpPrompt> value) => set('prompts', value);

  McpListPromptsResult({
    Map<String, dynamic>? meta,
    String? nextCursor,
    required List<McpPrompt> prompts,
  }) {
    this.meta = meta;
    this.nextCursor = nextCursor;
    this.prompts = prompts;
  }
}

// ============================================================
// resources/list & resources/read & resources/subscribe
// ============================================================

/// A known resource that the server is capable of reading.
class McpResource extends McpModel {
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  String get name => get('name');
  String? get title => get('title', def: null);
  String get uri => get('uri');
  String? get description => get('description', def: null);
  String? get mimeType => get('mimeType', def: null);
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  int? get size => get<int?>('size', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set icons(List<McpIcon>? value) => set('icons', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set uri(String value) => set('uri', value);
  set description(String? value) => set('description', value);
  set mimeType(String? value) => set('mimeType', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set size(int? value) => set('size', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpResource({
    List<McpIcon>? icons,
    required String name,
    String? title,
    required String uri,
    String? description,
    String? mimeType,
    McpAnnotations? annotations,
    int? size,
    Map<String, dynamic>? meta,
  }) {
    this.icons = icons;
    this.name = name;
    this.title = title;
    this.uri = uri;
    this.description = description;
    this.mimeType = mimeType;
    this.annotations = annotations;
    this.size = size;
    this.meta = meta;
  }
}

class McpListResourcesRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'resources/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListResourcesRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'resources/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListResourcesResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get nextCursor => get<String?>('nextCursor', def: null);
  List<McpResource> get resources => get('resources', def: <McpResource>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set nextCursor(String? value) => set('nextCursor', value);
  set resources(List<McpResource> value) => set('resources', value);

  McpListResourcesResult({
    Map<String, dynamic>? meta,
    String? nextCursor,
    required List<McpResource> resources,
  }) {
    this.meta = meta;
    this.nextCursor = nextCursor;
    this.resources = resources;
  }
}

class McpReadResourceRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The URI of the resource.
  String get uri => get('uri');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set uri(String value) => set('uri', value);

  McpReadResourceRequestParams({
    Map<String, dynamic>? meta,
    required String uri,
  }) {
    this.meta = meta;
    this.uri = uri;
  }
}

class McpReadResourceRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'resources/read');
  McpReadResourceRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpReadResourceRequestParams value) => set('params', value);

  McpReadResourceRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'resources/read',
    required McpReadResourceRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpReadResourceResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// List of TextResourceContents or BlobResourceContents
  List<dynamic> get contents => get('contents', def: <dynamic>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set contents(List<dynamic> value) => set('contents', value);

  McpReadResourceResult({
    Map<String, dynamic>? meta,
    required List<dynamic> contents,
  }) {
    this.meta = meta;
    this.contents = contents;
  }
}

class McpSubscribeRequestParams extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String get uri => get('uri');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set uri(String value) => set('uri', value);

  McpSubscribeRequestParams({Map<String, dynamic>? meta, required String uri}) {
    this.meta = meta;
    this.uri = uri;
  }
}

class McpSubscribeRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'resources/subscribe');
  McpSubscribeRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpSubscribeRequestParams value) => set('params', value);

  McpSubscribeRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'resources/subscribe',
    required McpSubscribeRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpUnsubscribeRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'resources/unsubscribe');
  McpSubscribeRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpSubscribeRequestParams value) => set('params', value);

  McpUnsubscribeRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'resources/unsubscribe',
    required McpSubscribeRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// resources/templates/list
// ============================================================

/// A template description for resources available on the server.
class McpResourceTemplate extends McpModel {
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  String get name => get('name');
  String? get title => get('title', def: null);

  /// A URI template (RFC 6570) that can be used to construct resource URIs.
  String get uriTemplate => get('uriTemplate');
  String? get description => get('description', def: null);
  String? get mimeType => get('mimeType', def: null);
  McpAnnotations? get annotations =>
      get<McpAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set icons(List<McpIcon>? value) => set('icons', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set uriTemplate(String value) => set('uriTemplate', value);
  set description(String? value) => set('description', value);
  set mimeType(String? value) => set('mimeType', value);
  set annotations(McpAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpResourceTemplate({
    List<McpIcon>? icons,
    required String name,
    String? title,
    required String uriTemplate,
    String? description,
    String? mimeType,
    McpAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.icons = icons;
    this.name = name;
    this.title = title;
    this.uriTemplate = uriTemplate;
    this.description = description;
    this.mimeType = mimeType;
    this.annotations = annotations;
    this.meta = meta;
  }
}

class McpListResourceTemplatesRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'resources/templates/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListResourceTemplatesRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'resources/templates/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListResourceTemplatesResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get nextCursor => get<String?>('nextCursor', def: null);
  List<McpResourceTemplate> get resourceTemplates =>
      get('resourceTemplates', def: <McpResourceTemplate>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set nextCursor(String? value) => set('nextCursor', value);
  set resourceTemplates(List<McpResourceTemplate> value) =>
      set('resourceTemplates', value);

  McpListResourceTemplatesResult({
    Map<String, dynamic>? meta,
    String? nextCursor,
    required List<McpResourceTemplate> resourceTemplates,
  }) {
    this.meta = meta;
    this.nextCursor = nextCursor;
    this.resourceTemplates = resourceTemplates;
  }
}

// ============================================================
// roots/list
// ============================================================

/// Represents a root directory or file that the server can operate on.
class McpRoot extends McpModel {
  /// The URI identifying the root. Must start with file://.
  String get uri => get('uri');
  String? get name => get<String?>('name', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set uri(String value) => set('uri', value);
  set name(String? value) => set('name', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpRoot({required String uri, String? name, Map<String, dynamic>? meta}) {
    this.uri = uri;
    this.name = name;
    this.meta = meta;
  }
}

class McpListRootsRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'roots/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListRootsRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'roots/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListRootsResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  List<McpRoot> get roots => get('roots', def: <McpRoot>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set roots(List<McpRoot> value) => set('roots', value);

  McpListRootsResult(
      {Map<String, dynamic>? meta, required List<McpRoot> roots}) {
    this.meta = meta;
    this.roots = roots;
  }
}

// ============================================================
// sampling/createMessage
// ============================================================

class McpModelHint extends McpModel {
  /// A hint for a model name (treated as substring match).
  String? get name => get<String?>('name', def: null);

  set name(String? value) => set('name', value);

  McpModelHint({String? name}) {
    this.name = name;
  }
}

class McpModelPreferences extends McpModel {
  List<McpModelHint>? get hints => get<List<McpModelHint>?>('hints', def: null);

  /// 0 = not important, 1 = most important factor for cost.
  double? get costPriority => get<double?>('costPriority', def: null);

  /// 0 = not important, 1 = most important factor for speed.
  double? get speedPriority => get<double?>('speedPriority', def: null);

  /// 0 = not important, 1 = most important factor for intelligence.
  double? get intelligencePriority =>
      get<double?>('intelligencePriority', def: null);

  set hints(List<McpModelHint>? value) => set('hints', value);
  set costPriority(double? value) => set('costPriority', value);
  set speedPriority(double? value) => set('speedPriority', value);
  set intelligencePriority(double? value) => set('intelligencePriority', value);

  McpModelPreferences({
    List<McpModelHint>? hints,
    double? costPriority,
    double? speedPriority,
    double? intelligencePriority,
  }) {
    this.hints = hints;
    this.costPriority = costPriority;
    this.speedPriority = speedPriority;
    this.intelligencePriority = intelligencePriority;
  }
}

/// Controls tool selection behavior for sampling requests.
class McpToolChoice extends McpModel {
  /// "auto" | "required" | "none"
  String? get mode => get<String?>('mode', def: null);

  set mode(String? value) => set('mode', value);

  McpToolChoice({String? mode}) {
    this.mode = mode;
  }
}

/// A request from the assistant to call a tool (in sampling context).
class McpToolUseContent extends McpContent {
  String get type => get('type', def: 'tool_use');

  /// A unique identifier for this tool use.
  String get id => get('id');
  String get name => get('name');

  /// The arguments to pass to the tool.
  Map<String, dynamic> get input => get('input', def: <String, dynamic>{});
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set id(String value) => set('id', value);
  set name(String value) => set('name', value);
  set input(Map<String, dynamic> value) => set('input', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpToolUseContent({
    String type = 'tool_use',
    required String id,
    required String name,
    required Map<String, dynamic> input,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.id = id;
    this.name = name;
    this.input = input;
    this.meta = meta;
  }
}

/// The result of a tool use, provided by the user back to the assistant.
class McpToolResultContent extends McpContent {
  String get type => get('type', def: 'tool_result');

  /// The ID of the tool use this result corresponds to.
  String get toolUseId => get('toolUseId');

  /// The unstructured result content (same format as CallToolResult.content).
  List<dynamic> get content => get('content', def: <dynamic>[]);
  Map<String, dynamic>? get structuredContent =>
      get<Map<String, dynamic>?>('structuredContent', def: null);
  bool? get isError => get<bool?>('isError', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set type(String value) => set('type', value);
  set toolUseId(String value) => set('toolUseId', value);
  set content(List<dynamic> value) => set('content', value);
  set structuredContent(Map<String, dynamic>? value) =>
      set('structuredContent', value);
  set isError(bool? value) => set('isError', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpToolResultContent({
    String type = 'tool_result',
    required String toolUseId,
    required List<dynamic> content,
    Map<String, dynamic>? structuredContent,
    bool? isError,
    Map<String, dynamic>? meta,
  }) {
    this.type = type;
    this.toolUseId = toolUseId;
    this.content = content;
    this.structuredContent = structuredContent;
    this.isError = isError;
    this.meta = meta;
  }
}

/// Describes a message issued to or received from an LLM API.
class McpSamplingMessage extends McpModel {
  /// "user" | "assistant"
  String get role => get('role');

  /// TextContent | ImageContent | AudioContent | ToolUseContent | ToolResultContent
  /// or a list of the above
  dynamic get content => get('content');
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set role(String value) => set('role', value);
  set content(dynamic value) => set('content', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpSamplingMessage({
    required String role,
    required dynamic content,
    Map<String, dynamic>? meta,
  }) {
    this.role = role;
    this.content = content;
    this.meta = meta;
  }
}

class McpCreateMessageRequestParams extends McpModel {
  Map<String, dynamic>? get task =>
      get<Map<String, dynamic>?>('task', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  List<McpSamplingMessage> get messages =>
      get('messages', def: <McpSamplingMessage>[]);
  McpModelPreferences? get modelPreferences =>
      get<McpModelPreferences?>('modelPreferences', def: null);
  String? get systemPrompt => get<String?>('systemPrompt', def: null);

  /// "none" | "thisServer" | "allServers"
  String? get includeContext => get<String?>('includeContext', def: null);
  double? get temperature => get<double?>('temperature', def: null);

  /// The requested maximum number of tokens to sample.
  int get maxTokens => get('maxTokens');
  List<String>? get stopSequences =>
      get<List<String>?>('stopSequences', def: null);
  dynamic get metadata => get<dynamic>('metadata', def: null);

  /// Tools that the model may use during generation.
  List<dynamic>? get tools => get<List<dynamic>?>('tools', def: null);
  McpToolChoice? get toolChoice => get<McpToolChoice?>('toolChoice', def: null);

  set task(Map<String, dynamic>? value) => set('task', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set messages(List<McpSamplingMessage> value) => set('messages', value);
  set modelPreferences(McpModelPreferences? value) =>
      set('modelPreferences', value);
  set systemPrompt(String? value) => set('systemPrompt', value);
  set includeContext(String? value) => set('includeContext', value);
  set temperature(double? value) => set('temperature', value);
  set maxTokens(int value) => set('maxTokens', value);
  set stopSequences(List<String>? value) => set('stopSequences', value);
  set metadata(dynamic value) => set('metadata', value);
  set tools(List<dynamic>? value) => set('tools', value);
  set toolChoice(McpToolChoice? value) => set('toolChoice', value);

  McpCreateMessageRequestParams({
    Map<String, dynamic>? task,
    Map<String, dynamic>? meta,
    required List<McpSamplingMessage> messages,
    McpModelPreferences? modelPreferences,
    String? systemPrompt,
    String? includeContext,
    double? temperature,
    required int maxTokens,
    List<String>? stopSequences,
    dynamic metadata,
    List<dynamic>? tools,
    McpToolChoice? toolChoice,
  }) {
    this.task = task;
    this.meta = meta;
    this.messages = messages;
    this.modelPreferences = modelPreferences;
    this.systemPrompt = systemPrompt;
    this.includeContext = includeContext;
    this.temperature = temperature;
    this.maxTokens = maxTokens;
    this.stopSequences = stopSequences;
    this.metadata = metadata;
    this.tools = tools;
    this.toolChoice = toolChoice;
  }
}

class McpCreateMessageRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'sampling/createMessage');
  McpCreateMessageRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpCreateMessageRequestParams value) => set('params', value);

  McpCreateMessageRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'sampling/createMessage',
    required McpCreateMessageRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

abstract class McpContent extends McpModel {}

class McpCreateMessageResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The name of the model that generated the message.
  String get model => get('model');

  /// "endTurn" | "stopSequence" | "maxTokens" | "toolUse" | custom
  String? get stopReason => get<String?>('stopReason', def: null);

  /// "user" | "assistant"
  String get role => get('role');

  /// SamplingMessageContentBlock or list of SamplingMessageContentBlock
  dynamic get content => get('content');

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set model(String value) => set('model', value);
  set stopReason(String? value) => set('stopReason', value);
  set role(String value) => set('role', value);
  set content(dynamic value) => set('content', value);

  McpCreateMessageResult({
    Map<String, dynamic>? meta,
    required String model,
    String? stopReason,
    required String role,
    required dynamic content,
  }) {
    this.meta = meta;
    this.model = model;
    this.stopReason = stopReason;
    this.role = role;
    this.content = content;
  }
}

// ============================================================
// tools/call & tools/list
// ============================================================

/// Additional properties describing a Tool to clients (hints only).
class McpToolAnnotations extends McpModel {
  String? get title => get<String?>('title', def: null);

  /// If true, the tool does not modify its environment. Default: false
  bool? get readOnlyHint => get<bool?>('readOnlyHint', def: null);

  /// If true, the tool may perform destructive updates. Default: true
  bool? get destructiveHint => get<bool?>('destructiveHint', def: null);

  /// If true, calling the tool repeatedly with the same args has no additional effect. Default: false
  bool? get idempotentHint => get<bool?>('idempotentHint', def: null);

  /// If true, tool may interact with an open world of external entities. Default: true
  bool? get openWorldHint => get<bool?>('openWorldHint', def: null);

  set title(String? value) => set('title', value);
  set readOnlyHint(bool? value) => set('readOnlyHint', value);
  set destructiveHint(bool? value) => set('destructiveHint', value);
  set idempotentHint(bool? value) => set('idempotentHint', value);
  set openWorldHint(bool? value) => set('openWorldHint', value);

  McpToolAnnotations({
    String? title,
    bool? readOnlyHint,
    bool? destructiveHint,
    bool? idempotentHint,
    bool? openWorldHint,
  }) {
    this.title = title;
    this.readOnlyHint = readOnlyHint;
    this.destructiveHint = destructiveHint;
    this.idempotentHint = idempotentHint;
    this.openWorldHint = openWorldHint;
  }
}

/// Execution-related properties for a tool.
class McpToolExecution extends McpModel {
  /// "forbidden" | "optional" | "required". Default: "forbidden"
  String? get taskSupport => get<String?>('taskSupport', def: null);

  set taskSupport(String? value) => set('taskSupport', value);

  McpToolExecution({String? taskSupport}) {
    this.taskSupport = taskSupport;
  }
}

/// Definition for a tool the client can call.
class McpTool extends McpModel {
  List<McpIcon>? get icons => get<List<McpIcon>?>('icons', def: null);
  String get name => get('name', def: '');
  String? get title => get('title', def: null);
  String? get description => get('description', def: null);

  /// A JSON Schema object defining the expected parameters.
  McpInputSchema? get inputSchema => get('inputSchema', def: null);
  McpToolExecution? get execution =>
      get<McpToolExecution?>('execution', def: null);

  /// An optional JSON Schema object defining the structure of the tool's output.
  McpOutputSchema? get outputSchema =>
      get<McpOutputSchema?>('outputSchema', def: null);
  McpToolAnnotations? get annotations =>
      get<McpToolAnnotations?>('annotations', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  set icons(List<McpIcon>? value) => set('icons', value);
  set name(String value) => set('name', value);
  set title(String? value) => set('title', value);
  set description(String? value) => set('description', value);
  set inputSchema(McpInputSchema? value) => set('inputSchema', value);
  set execution(McpToolExecution? value) => set('execution', value);
  set outputSchema(McpOutputSchema? value) => set('outputSchema', value);
  set annotations(McpToolAnnotations? value) => set('annotations', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);

  McpTool({
    List<McpIcon>? icons,
    required String name,
    String? title,
    String? description,
    required McpInputSchema inputSchema,
    McpToolExecution? execution,
    McpOutputSchema? outputSchema,
    McpToolAnnotations? annotations,
    Map<String, dynamic>? meta,
  }) {
    this.icons = icons;
    this.name = name;
    this.title = title;
    this.description = description;
    this.inputSchema = inputSchema;
    this.execution = execution;
    this.outputSchema = outputSchema;
    this.annotations = annotations;
    this.meta = meta;
  }
}

class McpCallToolRequestParams extends McpModel {
  Map<String, dynamic>? get task =>
      get<Map<String, dynamic>?>('task', def: null);
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// The name of the tool.
  String get name => get('name');

  /// Arguments to use for the tool call.
  Map<String, dynamic>? get arguments =>
      get<Map<String, dynamic>?>('arguments', def: null);

  set task(Map<String, dynamic>? value) => set('task', value);
  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set name(String value) => set('name', value);
  set arguments(Map<String, dynamic>? value) => set('arguments', value);

  McpCallToolRequestParams({
    Map<String, dynamic>? task,
    Map<String, dynamic>? meta,
    required String name,
    Map<String, dynamic>? arguments,
  }) {
    this.task = task;
    this.meta = meta;
    this.name = name;
    this.arguments = arguments;
  }
}

class McpCallToolRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tools/call');
  McpCallToolRequestParams get params => get('params');

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(McpCallToolRequestParams value) => set('params', value);

  McpCallToolRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tools/call',
    required McpCallToolRequestParams params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

/// The server's response to a tool call.
class McpCallToolResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);

  /// A list of content objects representing the unstructured result.
  List<dynamic> get content => get('content', def: <dynamic>[]);

  /// An optional JSON object representing the structured result.
  Map<String, dynamic>? get structuredContent =>
      get<Map<String, dynamic>?>('structuredContent', def: null);

  /// Whether the tool call ended in an error.
  bool? get isError => get<bool?>('isError', def: null);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set content(List<dynamic> value) => set('content', value);
  set structuredContent(Map<String, dynamic>? value) =>
      set('structuredContent', value);
  set isError(bool? value) => set('isError', value);

  McpCallToolResult({
    Map<String, dynamic>? meta,
    required List<dynamic> content,
    Map<String, dynamic>? structuredContent,
    bool? isError,
  }) {
    this.meta = meta;
    this.content = content;
    this.structuredContent = structuredContent;
    this.isError = isError;
  }
}

class McpListToolsRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'tools/list');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpListToolsRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'tools/list',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

class McpListToolsResult extends McpModel {
  Map<String, dynamic>? get meta =>
      get<Map<String, dynamic>?>('_meta', def: null);
  String? get nextCursor => get<String?>('nextCursor', def: null);
  List<McpTool> get tools => get('tools', def: <McpTool>[]);

  set meta(Map<String, dynamic>? value) => set('_meta', value);
  set nextCursor(String? value) => set('nextCursor', value);
  set tools(List<McpTool> value) => set('tools', value);

  McpListToolsResult({
    Map<String, dynamic>? meta,
    String? nextCursor,
    required List<McpTool> tools,
  }) {
    this.meta = meta;
    this.nextCursor = nextCursor;
    this.tools = tools;
  }
}

// ============================================================
// ping
// ============================================================

class McpPingRequest extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  dynamic get id => get('id');
  String get method => get('method', def: 'ping');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set id(dynamic value) => set('id', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpPingRequest({
    String jsonrpc = '2.0',
    required dynamic id,
    String method = 'ping',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.id = id;
    this.method = method;
    this.params = params;
  }
}

// ============================================================
// Simple notification models (no params)
// ============================================================

class McpInitializedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/initialized');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpInitializedNotification({
    String jsonrpc = '2.0',
    String method = 'notifications/initialized',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    this.method = method;
    this.params = params;
  }
}

class McpPromptListChangedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/prompts/list_changed');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpPromptListChangedNotification({
    String jsonrpc = '2.0',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    method = 'notifications/prompts/list_changed';
    this.params = params;
  }
}

class McpResourceListChangedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method =>
      get('method', def: 'notifications/resources/list_changed');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpResourceListChangedNotification({
    String jsonrpc = '2.0',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    method = 'notifications/resources/list_changed';
    this.params = params;
  }
}

class McpRootsListChangedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/roots/list_changed');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpRootsListChangedNotification({
    String jsonrpc = '2.0',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    method = 'notifications/roots/list_changed';
    this.params = params;
  }
}

class McpToolListChangedNotification extends McpModel {
  String get jsonrpc => get('jsonrpc', def: '2.0');
  String get method => get('method', def: 'notifications/tools/list_changed');
  Map<String, dynamic>? get params =>
      get<Map<String, dynamic>?>('params', def: null);

  set jsonrpc(String value) => set('jsonrpc', value);
  set method(String value) => set('method', value);
  set params(Map<String, dynamic>? value) => set('params', value);

  McpToolListChangedNotification({
    String jsonrpc = '2.0',
    Map<String, dynamic>? params,
  }) {
    this.jsonrpc = jsonrpc;
    method = 'notifications/tools/list_changed';
    this.params = params;
  }
}
