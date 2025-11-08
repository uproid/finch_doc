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
      return rq.url('/$path');
    } else {
      return rq.url('/$lang/$path');
    }
  },
};
