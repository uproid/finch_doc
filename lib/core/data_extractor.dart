import 'dart:io';

import 'package:finch_doc/controllers/home_controller.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/route.dart';
import 'package:markdown/markdown.dart';

class DataExtractor {
  static Map<String, ContentModel> contents = {};
  static final routes = <FinchRoute>[];
  static final menus = <String, String>{};

  static void init() {
    routes.clear();
    routes.addAll(makeDynamicRoutes());
  }

  static List<FinchRoute> makeDynamicRoutes() {
    var res = <FinchRoute>[];
    Directory dir = Directory(pathTo('./content'));
    var files = dir
        .listSync()
        .whereType<File>()
        .where(
          (f) => f.path.endsWith('.md'),
        )
        .toList();

    files.sort((a, b) {
      var numA = int.tryParse(a.fileName.split('.').first) ?? 0;
      var numB = int.tryParse(b.fileName.split('.').first) ?? 0;
      return numA.compareTo(numB);
    });

    for (var file in files) {
      var content = file.readAsStringSync();
      var key = fileNameToKey(file.fileName);
      if (key.toLowerCase() == 'readme') {
        key = '';
      }
      var doc = ContentModel(
        file.fileFullName,
        key,
        content,
      );

      contents[key] = doc;

      doc.previous = contents.values.length > 1
          ? contents.values.elementAt(contents.values.length - 2)
          : null;

      doc.previous?.next = doc;

      menus[key] = doc.title;

      res.add(FinchRoute(
        path: '/$key',
        key: key,
        extraPath: [file.fileFullName],
        methods: Methods.GET_ONLY,
        index: () async => HomeController().renderDocument(key),
      ));
    }
    return res;
  }

  static String fileNameToKey(String fileName) {
    var res = '';
    if (fileName.contains('.')) {
      res = fileName.split('.').last;
    } else {
      res = fileName;
    }

    res = res.replaceAll('-', '_')..toLowerCase();
    return res;
  }
}

class ContentModel {
  String filename;
  String key;
  String title = '';
  String html = '';
  List<Map<String, dynamic>> index = [];

  ContentModel? next;
  ContentModel? previous;

  ContentModel(
    this.filename,
    this.key,
    String md,
  ) {
    this.html = _initContent(md);
    _initIndex(md);
  }

  void _initIndex(String md) {
    List<Element> doc = Document().parse(md).whereType<Element>().toList();
    var tags = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'];
    for (var node in doc) {
      if (title.isEmpty) {
        title = node.textContent;
      }
      var indexInTags = tags.indexOf(node.tag);
      if (indexInTags != -1) {
        index.add({
          'level': indexInTags + 1,
          'id': node.textContent.toSlug(),
          'title': node.textContent,
        });
      }
    }
  }

  String _initContent(String md) {
    List<Node> doc = Document().parse(md);

    // Enrich TailwindCSS styles
    _fix(doc);

    return renderToHtml(doc);
  }

  void _fix(List<Node> nodes) {
    for (var node in nodes) {
      if (node is Element) {
        switch (node.tag) {
          case 'h1':
            node.attributes['class'] =
                'text-4xl font-bold mt-8 mb-4 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
            break;
          case 'h2':
            node.attributes['class'] =
                'text-3xl font-semibold mt-8 mb-4 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
            break;
          case 'h3':
            node.attributes['class'] =
                'text-2xl font-semibold mt-6 mb-3 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
            break;
          case 'h4':
            node.attributes['class'] =
                'text-xl font-semibold mt-6 mb-2 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
            break;
          case 'h5':
            node.attributes['class'] =
                'text-lg font-semibold mt-4 mb-2 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
            break;
          case 'h6':
            node.attributes['class'] =
                'text-base font-semibold mt-4 mb-1 scroll-mt-20';
            node.attributes['id'] = node.textContent.toSlug();
          case 'p':
            node.attributes['class'] = 'mb-4 leading-7';
            break;
          case 'a':
            node.attributes['class'] = 'text-blue-600 hover:underline';
            if (node.attributes['href'] != null) {
              node.attributes['href'] = fixLink(node.attributes['href']!);
            }
            break;
          case 'ul':
            node.attributes['class'] = 'list-disc list-inside mb-4';
            break;
          case 'ol':
            node.attributes['class'] = 'list-decimal list-inside mb-4 ps-4';
            break;
          case 'pre':
            node.attributes['class'] =
                'bg-gray-100 border-2 border-gray-300 dark:border-gray-700 dark:bg-gray-800 text-red-400 p-4 rounded mb-4 overflow-x-auto';
            break;
          case 'blockquote':
            node.attributes['class'] =
                'border-l-4 border-gray-300 pl-4 italic text-gray-600 mb-4';
            break;
        }

        if (node.children != null && node.children!.isNotEmpty) {
          _fix(node.children!);
        }
      }
    }
  }

  String fixLink(String link) {
    if (link.startsWith('http://') || link.startsWith('https://')) {
      return link;
    }
    if (link.startsWith('#')) {
      return link;
    }

    if (link.endsWith('.md')) {
      return DataExtractor.fileNameToKey(link.replaceAll('.md', ''));
    }

    return link;
  }
}
