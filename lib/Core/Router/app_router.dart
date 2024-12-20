import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/Login/new_login.dart';
import 'package:qr_page/Features/Screens/MainPage/main_page.dart';
import 'package:qr_page/Features/Screens/Splash/animated_splash.dart';

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
        name: AnimeSplashScreen.routeName,
        path: AnimeSplashScreen.routeName,
        builder: (_, __) => const AnimeSplashScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeName,
        builder: (_, __) => LoginScreen(),
      ),
      GoRoute(
        path: MainNavigationScreen.routeName,
        name: MainNavigationScreen.routeName,
        builder: (_, __) =>  MainNavigationScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
