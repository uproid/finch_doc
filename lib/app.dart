import 'package:finch_doc/core/configs.dart';
import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch_doc/core/local_events.dart';
import 'package:finch/app.dart';
import 'package:finch/finch_console.dart';
import 'package:finch/route.dart';
import 'route/web_route.dart';

FinchApp app = FinchApp(configs: configs);

void main() async {
  Extractor.init();
  Request.localEvents.addAll(localEvents);
  app.addRouting(getFinchRoute);
  app.start().then((value) {
    Console.p("App is running at: http://localhost:${value.port}");
  });
}
