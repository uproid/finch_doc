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
      key: 'home.mcpserver.index',
      path: '/mcp-server',
      extraPath: languages.keys.map((lang) => '/$lang/mcp-server/').toList(),
      methods: Methods.ALL,
      index: homeController.mcpServer,
    ),
    ...Extractor.routes,
    FinchRoute(
      path: '/api/search',
      methods: Methods.GET_POST,
      index: homeController.search,
    ),
    FinchRoute(
      path: '/app/includes.js',
      methods: Methods.ALL,
      index: IncludeJsController().index,
    ),
    FinchRoute(
      path: '/robots.txt',
      methods: Methods.ALL,
      index: homeController.robots,
    ),
    FinchRoute(
      path: '/sitemap.xml',
      methods: Methods.ALL,
      index: homeController.sitemap,
    ),
    FinchRoute(
      path: '/mcp',
      methods: Methods.ALL,
      index: mcpDocController.index,
    ),
  ];
}
