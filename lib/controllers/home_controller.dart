import 'dart:io';
import 'package:finch_doc/core/configs.dart';
import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/route.dart';
import 'package:finch_doc/core/languages.dart';

class HomeController extends Controller {
  HomeController();

  @override
  Future<String> index() async {
    return rq.renderHtml(html: "Hello world from Home Controller");
  }

  Future<String> error404() async {
    rq.addParam('content',
        '<h1>404 - Page Not Found</h1><p>The page you are looking for does not exist.</p>');
    rq.addParam('title', '404 - Page Not Found');
    rq.addParam('index', []);
    rq.addParam('filename', "content.filename");
    rq.addParam('key', "content.key");
    rq.addParam('configs', contentConfigs);
    rq.addParam('meta', {});
    rq.addParam('description', "content.description");
    rq.addParam('finchVersion', FinchApp.info.version);
    var menus = Extractor.contents['en']!.menus;
    rq.addParam('language', languages[rq.getLanguage()]!.toMap());
    rq.addParam('languages', Extractor.allLanguages());
    rq.addParam('menus', menus);

    return rq.renderView(
      path: 'template/error',
    );
  }

  Future<String> renderDocument(String key) async {
    var lang = rq.getLanguage();

    /// Allowed languages only
    var allowedLanguages = Extractor.allLanguages();
    if (allowedLanguages.indexWhere((element) => element['code'] == lang) ==
        -1) {
      lang = 'en';
    }

    var langModel = languages[lang] ?? languages['en']!;
    if (languages[lang] == null) {
      lang = 'en';
    }
    var content = Extractor.contents[lang]!.contents[key];

    if (content == null) {
      content = Extractor.contents[lang]!.contents['readme']!;
    }

    var menus = Extractor.contents[lang]!.menus;
    var contentLanguages = Extractor.allLanguages(currentContent: content);

    rq.addParam('content', content.html);
    rq.addParam('title', content.title);
    rq.addParam('index', content.index);
    rq.addParam('filename', content.filename);
    rq.addParam('key', content.key);
    rq.addParam('configs', contentConfigs);
    rq.addParam('meta', content.meta);
    rq.addParam('description', content.description);
    rq.addParam('finchVersion', FinchApp.info.version);
    rq.addParam('language', langModel.toMap());
    rq.addParam('languages', contentLanguages);
    rq.addParam('menus', menus);

    if (content.next != null) {
      rq.addParam('next', {
        'title': content.next?.title,
        'key': content.next?.key,
        'description': content.next?.description,
        'meta': content.next?.meta,
      });
    }
    if (content.previous != null) {
      rq.addParam('previous', {
        'title': content.previous?.title,
        'key': content.previous?.key,
        'description': content.previous?.description,
        'meta': content.previous?.meta,
      });
    }

    return rq.renderView(
      path: 'template/document',
    );
  }

  Future<String> search() async {
    var query = rq.get<String>('q', def: '').trim();

    var results = <ContentModel, int>{};

    if (query.isNotEmpty) {
      Extractor.contents[rq.getLanguage()]!.contents.forEach((key, content) {
        String combined = (content.title + content.html).toLowerCase();
        String searchQuery = query.toLowerCase();
        int count = RegExp.escape(searchQuery).allMatches(combined).length;
        if (count > 0) {
          results[content] = count;
        }
      });
    }
    //Sort results by count descending
    var sortedEntries = results.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    return rq.renderData(data: {
      'count': results.length,
      'data': sortedEntries
          .map((e) => {
                'title': e.key.title,
                'key': e.key.key,
                'description': e.key.description,
                'meta': e.key.meta,
              })
          .toList(),
    });
  }

  Future<String> robots() async {
    return rq.renderString(
      text: '''User-agent: *
Allow: /
Sitemap: ${rq.url('/sitemap.xml')}
''',
      contentType: ContentType.text,
    );
  }

  Future<String> sitemap() async {
    var sitemapEntries = StringBuffer();

    var allLanguages = Extractor.contents.keys;
    var allContentsByKey = <String, Map<String, List<ContentModel>>>{};
    for (var lang in allLanguages) {
      var contents = Extractor.contents[lang]!.contents;
      contents.forEach((key, content) {
        allContentsByKey.putIfAbsent(key, () => {});
        allContentsByKey[key]!.putIfAbsent(lang, () => []);
        allContentsByKey[key]![lang]!.add(content);
      });
    }

    allContentsByKey.forEach((key, contents) {
      sitemapEntries.writeln('\t<url>');
      sitemapEntries.writeln('\t\t<loc>${rq.url('/${key}')}</loc>');
      contents.forEach((lang, contentList) {
        for (var content in contentList) {
          sitemapEntries.writeln(
              '\t\t<xhtml:link rel="alternate" hreflang="$lang" href="${rq.url('${lang}/${content.key}')}" />');
        }
      });
      sitemapEntries.writeln(
          '\t\t<xhtml:link rel="alternate" hreflang="x-default" href="${rq.url('en/${key}')}" />');
      sitemapEntries.writeln('\t\t<changefreq>weekly</changefreq>');
      sitemapEntries.writeln('\t\t<priority>1.0</priority>');
      sitemapEntries.writeln('\t</url>');

      contents.forEach((lang, contentList) {
        for (var _ in contentList) {
          sitemapEntries.writeln('\t<url>');
          sitemapEntries.writeln('\t\t<loc>${rq.url('$lang/${key}')}</loc>');
          contents.forEach((lang, contentList) {
            for (var content in contentList) {
              sitemapEntries.writeln(
                  '\t\t<xhtml:link rel="alternate" hreflang="$lang" href="${rq.url('${lang}/${content.key}')}" />');
            }
          });
          sitemapEntries.writeln(
              '\t\t<xhtml:link rel="alternate" hreflang="x-default" href="${rq.url('en/${key}')}" />');
          sitemapEntries.writeln('\t\t<changefreq>weekly</changefreq>');
          sitemapEntries.writeln('\t\t<priority>1.0</priority>');
          sitemapEntries.writeln('\t</url>');
        }
      });
    });

    return rq.renderString(
      text: '''<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml">
$sitemapEntries
</urlset>''',
      contentType: ContentType('application', 'xml'),
    );
  }
}
