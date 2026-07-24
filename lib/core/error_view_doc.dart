import 'package:finch/finch_app.dart';
import 'package:finch/finch_console.dart';
import 'package:finch/finch_mail.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/htmler.dart';
import 'package:finch/route.dart';
import 'package:finch/ui.dart';
import 'package:finch_doc/core/configs.dart';
import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch_doc/core/languages.dart';

class ErrorViewDoc extends FinchStringWidget {
  Request get rq => Context.rq;

  @override
  Tag Function(Map<dynamic, dynamic> args)? get generateHtml => (args) {
        var statusCode = args['status'] ?? 404;
        if (statusCode != 404) {
          _sendEmail(statusCode, args);
          return ErrorWidget().generateHtml!.call(args);
        }

        rq.addParam('content',
            '<h1>404 - Page Not Found</h1><p>The page you are looking for does not exist.</p>');
        rq.addParam('title', '404 - Page Not Found');
        rq.addParam('index', []);
        rq.addParam('filename', "content.filename");
        rq.addParam(
            'key', pathNorm(rq.uri.safePathSegments.last, endWithSlash: false));
        rq.addParam('configs', Extractor.configs);
        rq.addParam('meta', {});
        rq.addParam('description', "content.description");
        rq.addParam('finchVersion', FinchApp.info.version);
        var menus = Extractor.contents['en']!.menus;
        rq.addParam('language', languages[rq.getLanguage()]!.toMap());
        rq.addParam('languages', Extractor.allLanguages());
        rq.addParam('menus', menus);

        return $Cache(
          children: [
            $JinjaInclude('template/error.${configs.widgetsType}'),
          ],
        );
      };

  bool _allowSend() {
    const notAllowKeys = [];
    if (notAllowKeys.contains(Context.rq.route?.key)) {
      return false;
    }
    return true;
  }

  Future<void> _sendEmail(int statusCode, Map<dynamic, dynamic> args) async {
    if (_allowSend() == false) return;

    var to = [env['DEBUG_EMAIL_TO'] ?? 'test@finchdart.com'];

    args.addAll(<String, dynamic>{
      'url': Context.rq.uri.toString(),
      'method': Context.rq.method,
      'headers': Context.rq.headers,
      'data': Context.rq.getAllData(),
      'route': Context.rq.route?.toDetails(),
      'ip': Context.rq.getIP(),
    });

    MailSender.sendEmail(
      from: env['DEBUG_EMAIL_FROM'] ?? 'test@finchdart.com',
      to: to,
      allowInsecure: true,
      subject: 'Document(Finch) Error: $statusCode',
      fromName: env['DEBUG_EMAIL_FROM_NAME'] ?? 'Finch Documentation',
      host: env['DEBUG_EMAIL_HOST'] ?? 'mail',
      port: int.tryParse(env['DEBUG_EMAIL_PORT'] ?? '1025') ?? 1025,
      html: _mapToHtml(args),
      password: env['DEBUG_EMAIL_PASSWORD'],
      ssl: env['DEBUG_EMAIL_SSL']?.toLowerCase() == 'true' ? true : false,
      username: env['DEBUG_EMAIL_USERNAME'],
    ).onError((error, stackTrace) {
      Console.e('Error sending email: $error');
      return false;
    });
  }

  String _mapToHtml(Map args) {
    var res = "";
    for (var key in args.keys) {
      var arg = args[key];
      res += "<b>$key</b>: ";
      if (arg is List) {
        res += "${arg.join(', ')}<hr>";
      } else if (arg is Map) {
        res += _mapToHtml(arg);
      } else {
        res += "${arg.toString()}<hr>";
      }
    }
    return res;
  }
}
