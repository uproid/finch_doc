import 'package:finch/finch_route.dart';

var localEvents = <String, Object>{
  'now': DateTime.now(),
  'maxLength': (String? text, int maxLength) {
    text ??= '';
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  },
  'urlLn': (String path) {
    var rq = Context.rq;
    var lang = rq.getLanguage();
    if (lang == 'en') {
      return url(rq, '/$path');
    } else {
      return url(rq, '/$lang/$path');
    }
  },
  'set': (String key, Object value) {
    var rq = Context.rq;
    rq.addParam(key, value);
    return '';
  },
  'get': (String key, [Object? def]) {
    var rq = Context.rq;
    return rq.getParam(key, def: def);
  },
};

String url(Request rq, String subPath, {Map<String, String>? params}) {
  var pathRequest = rq.httpRequest.requestedUri.origin;
  var uri = Uri.parse(pathRequest);
  uri = uri.resolve(subPath);
  if (params != null && params.isNotEmpty) {
    uri = uri.replace(queryParameters: params);
  }

  var url = uri.toString();
  return url;
}
