import 'package:go_router/go_router.dart';
import 'package:yutter/src/routes/home.dart';

class RouterProvider {
  const RouterProvider();

  GoRouter get router =>
      GoRouter(initialLocation: HomeRoute.path, routes: [HomeRoute.route]);
}
