import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/Login/login.dart';
import 'package:qr_page/Features/Screens/MainPage/main_page.dart';
import 'package:qr_page/Features/Screens/Splash/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey =
  GlobalKey<NavigatorState>(debugLabel: 'root');
  static GlobalKey<NavigatorState> get routerKey => _routerKey;
  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: MainNavigationScreen.routeName, // Default splash screen
    routes: <RouteBase>[
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
        path: MainNavigationScreen.routeName,
        name: MainNavigationScreen.routeName,
        builder: (_, __) => const MainNavigationScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
