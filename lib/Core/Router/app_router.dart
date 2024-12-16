import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/Home/home.dart';
import 'package:qr_page/Features/Screens/Login/login.dart';
import 'package:qr_page/Features/Screens/Splash/splash_screen.dart';

import '../../Features/Screens/Scanner_Page/scanner_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey =
  GlobalKey<NavigatorState>(debugLabel: 'root');

  static GlobalKey<NavigatorState> get routerKey => _routerKey;

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: ScannerPage.routeName, // Default splash screen
    routes: <RouteBase>[
      // Splash Screen Route
      GoRoute(
        name: SplashScreen.routeName,
        path: SplashScreen.routeName,
        builder: (_, __) => const SplashScreen(),
      ),
      // Login Page Route
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routeName,
        builder: (_, __) => const LoginPage(),
      ),
      // Home Page Route
      GoRoute(
        path: HomePage.routeName,
        name: HomePage.routeName,
        builder: (_, __) => const HomePage(),
      ),

      GoRoute(
          path: ScannerPage.routeName,
          name: ScannerPage.routeName,
          builder: (_, __) =>  ScannerPage())
    ],
  );

  static GoRouter get router => _router;
}
