import 'package:finch_doc/core/data_extractor.dart';
import 'package:finch/route.dart';
import '../controllers/home_controller.dart';

Future<List<FinchRoute>> getFinchRoute(Request rq) async {
  final homeController = HomeController();

  return [
    ...DataExtractor.routes,
    FinchRoute(
      path: '/api',
      children: [
        FinchRoute(
          path: '/search',
          methods: Methods.GET_POST,
          index: homeController.search,
        ),
      ],
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
  ];
}
