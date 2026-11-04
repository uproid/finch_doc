import 'dart:io';

import 'package:finch/capp.dart';
import 'package:finch/console.dart';
import 'package:finch/src/finch_app.dart';
import 'package:finch/tools.dart';
import 'package:finch_doc/app.dart';

CappController buildHtmlCommand = CappController(
  'build-html',
  description: 'Builds the HTML files for the documentation.',
  options: [
    CappOption(
      name: 'output',
      shortName: 'o',
      description: 'Output directory for the HTML files.',
      value: './build_html',
    ),
  ],
  run: (c) async {
    // Check empty output directory
    String outputDir = c.getOption('output', def: './build_html');
    Directory dir = Directory(outputDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    } else {
      if (dir.listSync().isNotEmpty) {
        print(
            'Output directory is not empty. Please specify an empty directory.');
        return CappConsole.empty;
      }
    }

    /// Copy public assets
    var publicDir = Directory(joinPaths([FinchApp.config.publicDir]));
    var targetDir = Directory(joinPaths([outputDir]));
    if (publicDir.existsSync()) {
      await CappConsole.progress('Copying public assets...', () async {
        await publicDir.copyDirectory(targetDir);
      });
    }

    // All Routes
    var routes = await app.exploreAllRoutes();
    routes = routes.where((route) => route['method'] == 'GET').toList();
    Print.debug('Found ${routes.length} routes to build HTML files.');

    // replace content values
    var replace = {
      'http://localhost:${FinchApp.config.port}/': '/',
      "<script src='/debugger/console.js'></script>": '',
    };

    // Build HTML files
    for (var route in routes) {
      String path = route['path'];
      String filePath =
          path == '/' ? 'index.html' : joinPaths([path, 'index.html']);
      String fullPath = joinPaths([outputDir, filePath]);
      File file = File(fullPath);
      file.createSync(recursive: true);
      var uri = Uri.parse(joinPaths([
        'http://localhost:${FinchApp.config.port}',
        path,
      ]));
      await CappConsole.progress('', () async {
        var response = await FinchHttp.get(uri);
        var content = response.body;
        content = replace.entries.fold(content, (prev, entry) {
          return prev.replaceAll(entry.key, entry.value);
        });
        file.writeAsStringSync(content);
      });
    }

    return CappConsole.empty;
  },
);
