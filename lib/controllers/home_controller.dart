import 'dart:io';

import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/route.dart';

class HomeController extends Controller {
  HomeController();

  @override
  Future<String> index() async {
    return rq.renderHtml(html: "Hello world from Home Controller");
  }

  Future<String> renderDocument(String key) async {
    var content = DataExtractor.contents[key]!;

    rq.addParam('content', content.html);
    rq.addParam('title', content.title);
    rq.addParam('index', content.index);
    rq.addParam('menus', DataExtractor.menus);
    rq.addParam('filename', content.filename);
    rq.addParam('github', 'https://github.com/uproid/finch');
    rq.addParam('meta', content.meta);
    rq.addParam('description', content.description);
    rq.addParam('finchVersion', FinchApp.info.version);

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
      DataExtractor.contents.forEach((key, content) {
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
    var sitemapEntries = DataExtractor.contents.values.map((content) {
      return '''  <url>
    <loc>${rq.url('/${content.key}')}</loc>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
  </url>''';
    }).join('\n');

    return rq.renderString(
      text: '''<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$sitemapEntries
</urlset>''',
      contentType: ContentType('application', 'xml'),
    );
  }
}
