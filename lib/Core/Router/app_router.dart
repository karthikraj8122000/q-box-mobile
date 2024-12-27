import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Features/Screens/MainPage/main_page.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/see_all_qbox_foods.dart';
import 'package:qr_page/Features/Screens/Splash/animated_splash.dart';
import 'package:qr_page/Provider/auth_provider.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey =
  GlobalKey<NavigatorState>(debugLabel: 'root');
  static GlobalKey<NavigatorState> get routerKey => _routerKey;
  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: AnimeSplashScreen.routeName, // Default splash screen
    routes: <RouteBase>[
      GoRoute(
        name: AnimeSplashScreen.routeName,
        path: AnimeSplashScreen.routeName,
        builder: (_, __) => const AnimeSplashScreen(),
      ),

      GoRoute(
        name: SeeAllQboxFoods.routeName,
        path: SeeAllQboxFoods.routeName,
        builder: (_, __) => const SeeAllQboxFoods(),
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
      GoRoute(
        path: '/',
        builder: (context, state) {
          final authProvider = Provider.of<AuthProvider>(context, listen: true);
          if (authProvider.isLoggedIn) {
            return const MainNavigationScreen();  // Navigate to the Scanner if logged in
          } else {
            return const LoginScreen();  // Otherwise, show the login page
          }
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
