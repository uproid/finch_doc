import 'dart:convert';
import 'dart:io';
import 'package:finch/console.dart';
import 'package:finch_doc/controllers/home_controller.dart';
import 'package:finch/finch_tools.dart';
import 'package:finch/route.dart';
import 'package:finch_doc/core/languages.dart';
import 'package:finch_doc/core/string_extention.dart';
import 'package:markdown/markdown.dart';

class Extractor {
  static final routes = <FinchRoute>[];
  static final contents = <String, DataExtractor>{};

  static void init() {
    routes.clear();
    routes.addAll(makeDynamicRoutes());
  }

  static List<Map<String, dynamic>> allLanguages() {
    Map<String, Map<String, dynamic>> res = {};
    contents.keys.forEach((lang) {
      var langModel = languages[lang]!;
      res[lang] = langModel.toMap();
    });
    return res.values.toList();
  }

  static List<FinchRoute> makeDynamicRoutes() {
    var res = <FinchRoute>[];
    Directory dir = Directory(pathTo('./content'));

    var langDirs = dir.listSync().whereType<Directory>().where(
      (d) {
        var dirName = d.path.split(Platform.pathSeparator).last;
        return languages.keys.contains(dirName);
      },
    ).toList();
    langDirs.add(dir);

    for (var langDir in langDirs) {
      String lang = langDir == dir
          ? 'en'
          : langDir.path.split(Platform.pathSeparator).last;
      String langPath = langDir == dir ? '' : '$lang/';

      contents.putIfAbsent(lang, () => DataExtractor());

      var files = langDir
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
          '$langPath${file.fileFullName}',
          key,
          content,
        );

        contents.putIfAbsent(lang, () => DataExtractor());
        contents[lang]!.contents[key] = doc;

        doc.previous = contents[lang]!.contents.length > 1
            ? contents[lang]!
                .contents
                .values
                .elementAt(contents[lang]!.contents.values.length - 2)
            : null;

        doc.previous?.next = doc;

        res.add(FinchRoute(
          path: '$lang/$key',
          key: '$key',
          extraPath: [
            '$lang/${file.fileFullName}',
            if (lang == 'en') ...[
              file.fileFullName,
              '$lang/$key' == 'en/' ? '/' : key,
            ],
          ],
          methods: Methods.GET_ONLY,
          index: () async => HomeController().renderDocument(key),
        ));
      }
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

class DataExtractor {
  Map<String, ContentModel> contents = {};
  List<Map<String, dynamic>> _menus = [];

  List<Map<String, dynamic>> get menus {
    if (_menus.isNotEmpty) return _menus;
    _menus = contents.keys
        .map((k) => {
              'key': k,
              'title': contents[k]?.title ?? '',
              'meta': contents[k]?.meta ?? {},
            })
        .toList();
    return _menus;
  }
}

class ContentModel {
  String filename;
  String key;
  Map<String, dynamic> meta = {};
  String title = '';
  String html = '';
  String description = '';
  List<Map<String, dynamic>> index = [];

  ContentModel? next;
  ContentModel? previous;

  ContentModel(
    this.filename,
    this.key,
    String md,
  ) {
    /// Extract icon from front matter
    final frontMatterRegExp =
        RegExp(r'^---\s*\n(.*?)\n---\s*$', multiLine: true, dotAll: true);
    final match = frontMatterRegExp.firstMatch(md);

    if (match != null) {
      var metaString = match.group(1).toString().trim();
      if (metaString.startsWith('@meta:')) {
        metaString = metaString.replaceFirst('@meta:', '');
        try {
          meta = jsonDecode((metaString));
        } catch (e) {
          Console.e('Error parsing front matter JSON: $e');
        }
      }
    }

    /// Remove Hidden content from markdown
    md = md.replaceAll(frontMatterRegExp, '');

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
          'id': node.textContent.generateKey(),
          'title': node.textContent,
        });
      }
    }

    // Extract first text after first h tag as description
    for (var i = 0; i < doc.length; i++) {
      var node = doc[i];
      if (tags.contains(node.tag)) {
        // Look for next text node
        for (var j = i + 1; j < doc.length; j++) {
          var nextNode = doc[j];
          if (nextNode.tag == 'p') {
            description = nextNode.textContent.trim().removeHtmlTags();
            return;
          }
        }
      }
    }
    // Optimize description length
    if (description.length > 150) {
      description = description.substring(0, 150) + '...';
    }
  }

  String _initContent(String md) {
    List<Node> doc = Document().parse(md);
    _fix(doc);

    return renderToHtml(doc);
  }

  void _fix(List<Node> nodes) {
    for (var node in nodes) {
      if (node is Element) {
        switch (node.tag) {
          case 'h1':
            node.attributes['class'] =
                'md-header-tag text-4xl font-bold mt-8 mb-4 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
            break;
          case 'h2':
            node.attributes['class'] =
                'md-header-tag text-3xl font-semibold mt-8 mb-4 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
            break;
          case 'h3':
            node.attributes['class'] =
                'md-header-tag text-2xl font-semibold mt-6 mb-3 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
            break;
          case 'h4':
            node.attributes['class'] =
                'md-header-tag text-xl font-semibold mt-6 mb-2 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
            break;
          case 'h5':
            node.attributes['class'] =
                'md-header-tag text-lg font-semibold mt-4 mb-2 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
            break;
          case 'h6':
            node.attributes['class'] =
                'md-header-tag text-base font-semibold mt-4 mb-1 scroll-mt-20';
            node.attributes['id'] = node.textContent.generateKey();
          case 'p':
            node.attributes['class'] = 'mb-4 leading-7';
            break;
          case 'a':
            node.attributes['class'] =
                'text-blue-600 hover:underline dark:text-secondary-400';
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
            node.attributes['dir'] = 'ltr';
            break;
          case 'hr':
            node.attributes['class'] =
                'my-8 border-t border-gray-300 dark:border-gray-700 py-2';
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
      return Extractor.fileNameToKey(link.replaceAll('.md', ''));
    }

    return link;
  }
}
