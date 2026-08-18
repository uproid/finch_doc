import 'package:finch/console.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/model.dart';
import 'package:finch_doc/core/error_view_doc.dart';
import 'package:finch_doc/core/languages.dart';
import 'package:finch_doc/languages/language_dart.g.dart';
import 'package:finch_doc/widgets/widget_dart.g.dart';

const repository = 'https://github.com/uproid/finch';

const enableApi = true;

final FinchConfigs configs = FinchConfigs(
  widgetsPath: pathTo(env['WIDGETS_PATH'] ?? "./lib/widgets"),
  widgetsType: env['WIDGETS_TYPE'] ?? 'html.twig',
  languagePath: pathTo(env['LANGUAGE_PATH'] ?? "./lib/languages"),
  publicDir: pathTo(env['PUBLIC_DIR'] ?? './public'),
  dbConfig: FinchDBConfig(enable: false),
  port: 9902,
  enableLocalDebugger: Console.isDebug,
  languageSource: LanguageSource.dart,
  dartLanguages: languageDart,
  jinjaMapTemplate: mapTemplates,
  errorWidget: ErrorViewDoc(),
  languages: languages.keys.toList(),
);
