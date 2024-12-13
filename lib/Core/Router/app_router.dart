import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qbox_app/Features/Screens/Home/home.dart';
import 'package:qbox_app/Features/Screens/Login/login.dart';
import 'package:qbox_app/Features/Screens/Scanner_Page/scanner_page.dart';
import 'package:qbox_app/Features/Screens/Splash/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GlobalKey<NavigatorState> get routerKey => _routerKey;

  static final GoRouter _router = GoRouter(
      navigatorKey: _routerKey,
      debugLogDiagnostics: true,
      initialLocation: ScannerPage.routeName,
      routes: <RouteBase>[
        GoRoute(
            name: SplashScreen.routeName,
            path: SplashScreen.routeName,
            builder: (_, __) => const SplashScreen()),
        GoRoute(
            name: LoginPage.routeName,
            path: LoginPage.routeName,
            builder: (_, __) => const LoginPage()),
        GoRoute(
            path: HomePage.routeName,
            name: HomePage.routeName,
            builder: (_, __) => const HomePage()),
        GoRoute(
            path: ScannerPage.routeName,
            name: ScannerPage.routeName,
            builder: (_, __) => const ScannerPage())
      ]);

  static GoRouter get router => _router;

}
