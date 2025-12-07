import 'package:finch/console.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/finch_tools.dart';

const repository = 'https://github.com/uproid/finch';

FinchConfigs configs = FinchConfigs(
  widgetsPath: pathTo(env['WIDGETS_PATH'] ?? "./lib/widgets"),
  widgetsType: env['WIDGETS_TYPE'] ?? 'html.twig',
  languagePath: pathTo(env['LANGUAGE_PATH'] ?? "./lib/languages"),
  publicDir: pathTo(env['PUBLIC_DIR'] ?? './public'),
  dbConfig: FinchDBConfig(enable: false),
  port: 9902,
  enableLocalDebugger: Console.isDebug,
);
