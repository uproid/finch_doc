import 'package:finch_doc/controllers/mcp_doc_controller.dart';
import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch/route.dart';
import 'package:finch_doc/core/languages.dart';
import '../controllers/home_controller.dart';

final homeController = HomeController();
final mcpDocController = McpDocController();

Future<List<FinchRoute>> getFinchRoute() async {
  return [
    FinchRoute(
      key: 'home.index',
      path: '/',
      extraPath: languages.keys.map((lang) => '/$lang/').toList(),
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.home,
    ),
    FinchRoute(
      key: 'home.mcpserver.index',
      path: '/mcp-server',
      extraPath: languages.keys.map((lang) => '/$lang/mcp-server/').toList(),
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.mcpServer,
    ),
    ...Extractor.routes,
    FinchRoute(
      path: '/api/search',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.search,
    ),
    FinchRoute(
      path: '/app/includes.js',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: IncludeJsController().index,
    ),
    FinchRoute(
      path: '/robots.txt',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.robots,
    ),
    FinchRoute(
      path: '/sitemap.xml',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.sitemap,
    ),
    FinchRoute(
      path: '/sitemap.xsl',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: homeController.sitemapXsl,
    ),
    FinchRoute(
      path: '/mcp',
      methods: const [Methods.GET, Methods.POST, Methods.HEAD, Methods.OPTIONS],
      index: mcpDocController.index,
    ),
  ];
}
