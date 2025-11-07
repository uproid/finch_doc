import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch_doc/core/local_events.dart';
import 'package:finch/app.dart';
import 'package:finch/finch_console.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/route.dart';
import 'route/web_route.dart';

FinchConfigs configs = FinchConfigs(
  widgetsPath: pathTo(env['WIDGETS_PATH'] ?? "./lib/widgets"),
  widgetsType: env['WIDGETS_TYPE'] ?? 'html.twig',
  languagePath: pathTo(env['LANGUAGE_PATH'] ?? "./lib/languages"),
  publicDir: pathTo(env['PUBLIC_DIR'] ?? './public'),
  dbConfig: FinchDBConfig(enable: false),
  port: 9902,
  enableLocalDebugger: Console.isDebug,
);

FinchApp app = FinchApp(configs: configs);

void main() async {
  DataExtractor.init();
  Request.localEvents.addAll(localEvents);
  app.addRouting(getFinchRoute);
  app.start().then((value) {
    Console.p("App is running at: http://localhost:${value.port}");
  });
}
