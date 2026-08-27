import 'dart:io';
import 'package:finch/finch_tools.dart';
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

  Future<String> home() async {
    return renderPage('home');
  }

  Future<String> mcpServer() async {
    return renderPage('mcp-server');
  }

  Future<String> renderPage(String page) async {
    var lang = rq.getLanguage();

    var langModel = languages[lang] ?? languages['en']!;
    if (languages[lang] == null) {
      lang = 'en';
    }

    var content = Extractor.contents[lang]!.contents.entries.first.value;
    var menus = Extractor.contents[lang]!.menus;
    var contentLanguages = Extractor.allLanguages(currentContent: content);

    rq.addParam('key', pathNorm(rq.route?.path ?? '', endWithSlash: false));
    rq.addParam('configs', Extractor.configs);
    rq.addParam('description', content.description);
    rq.addParam('finchVersion', FinchApp.info.version);
    rq.addParam('language', langModel.toMap());
    rq.addParam('languages', contentLanguages);
    rq.addParam('menus', menus);

    return rq.renderView(
      path: 'template/pages/$page',
    );
  }

  Future<String> renderDocument(String key) async {
    var lang = rq.getLanguage();
    var isApi = enableApi && (rq.isApiEndpoint || rq.endpoint == 'api');

    var langModel = languages[lang] ?? languages['en']!;
    if (languages[lang] == null) {
      lang = 'en';
    }
    var content = Extractor.contents[lang]!.contents[key];

    if (content == null) {
      content = Extractor.contents[lang]!.contents.entries.first.value;
    }

    var menus = Extractor.contents[lang]!.menus;
    var contentLanguages = Extractor.allLanguages(currentContent: content);

    rq.addParam('content', content.html);
    rq.addParam('title', content.title);
    rq.addParam('index', content.index);
    rq.addParam('filename', content.filename);
    rq.addParam('key', content.key);
    rq.addParam('configs', Extractor.configs);
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
      toData: isApi,
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

  Future<String> sitemapXsl() async {
    rq.contentType = ContentType('text', 'xsl');
    return rq.renderView(path: 'template/sitemap-xsl');
  }

  Future<String> sitemap() async {
    var allLanguages = Extractor.contents.keys.toList();
    var urls = <Map<String, dynamic>>[];

    Map<String, dynamic> urlEntry(String loc, List<Map<String, String>> alternates) {
      return {
        'loc': loc,
        'alternates': alternates,
        'changefreq': 'weekly',
        'priority': '1.0',
      };
    }

    for (var lang in ['', ...allLanguages]) {
      urls.add(urlEntry(rq.url(lang.isEmpty ? '/' : '/$lang/'), [
        for (var subLang in allLanguages)
          {'hreflang': subLang, 'href': rq.url('/$subLang/')},
        {'hreflang': 'x-default', 'href': rq.url('')},
      ]));
    }

    var allContentsByKey = <String, Map<String, List<ContentModel>>>{};
    for (var lang in allLanguages) {
      Extractor.contents[lang]!.contents.forEach((key, content) {
        allContentsByKey.putIfAbsent(key, () => {});
        allContentsByKey[key]!.putIfAbsent(lang, () => []);
        allContentsByKey[key]![lang]!.add(content);
      });
    }

    allContentsByKey.forEach((key, contentsByLang) {
      var alternates = [
        for (var entry in contentsByLang.entries)
          for (var content in entry.value)
            {'hreflang': entry.key, 'href': rq.url('${entry.key}/${content.key}')},
        {'hreflang': 'x-default', 'href': rq.url('en/$key')},
      ];

      urls.add(urlEntry(rq.url('/$key'), alternates));

      contentsByLang.forEach((lang, contentList) {
        for (var _ in contentList) {
          urls.add(urlEntry(rq.url('$lang/$key'), alternates));
        }
      });
    });

    rq.contentType = ContentType('application', 'xml');
    rq.addParam('urls', urls);
    rq.addParam('xslHref', rq.url('/sitemap.xsl'));

    return rq.renderView(path: 'template/sitemap');
  }
}
