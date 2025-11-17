import 'package:finch/console.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/finch_tools.dart';

FinchConfigs configs = FinchConfigs(
  widgetsPath: pathTo(env['WIDGETS_PATH'] ?? "./lib/widgets"),
  widgetsType: env['WIDGETS_TYPE'] ?? 'html.twig',
  languagePath: pathTo(env['LANGUAGE_PATH'] ?? "./lib/languages"),
  publicDir: pathTo(env['PUBLIC_DIR'] ?? './public'),
  dbConfig: FinchDBConfig(enable: false),
  port: 9902,
  enableLocalDebugger: Console.isDebug,
);

Map contentConfigs = {
  'repository': 'https://github.com/uproid/finch',
  'discord': 'https://discord.gg/YduDmJxCp9',
  'youtube': 'https://www.youtube.com/@finchdart',
  'otherPackages': 'https://pub.dev/publishers/finchdart.com/packages',
  'demo': 'https://example.finchdart.com',
  'changelog': 'https://pub.dev/packages/finch/changelog',
  'pubDev': 'https://pub.dev/packages/finch',
  'sponsor': 'https://github.com/sponsors/uproid',
  'contribution': 'https://github.com/uproid/finch/blob/master/CONTRIBUTING.md',
  'email': 'info@finchdart.com',
  'community': 'https://t.me/finchdart',
  'finchDoc': 'https://github.com/uproid/finch_doc',
  'edit': 'https://github.com/uproid/finch/edit/master/doc',
  'releases': 'https://github.com/uproid/finch/releases',
};
