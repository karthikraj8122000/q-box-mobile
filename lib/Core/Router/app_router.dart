import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_app/Features/Screens/Home/home.dart';
import 'package:testing_app/Features/Screens/Login/login.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GlobalKey<NavigatorState> get routerKey => _routerKey;

  static final GoRouter _router = GoRouter(
      navigatorKey: _routerKey,
      debugLogDiagnostics: true,
      initialLocation: LoginPage.routeName,
      routes: <RouteBase>[
        GoRoute(
            name: LoginPage.routeName,
            path: LoginPage.routeName,
            builder: (_, __) => const LoginPage()),
        GoRoute(
            path: HomePage.routeName,
            name: HomePage.routeName,
            builder: (_, __) => const HomePage())
      ]);

  static GoRouter get router => _router;

}
