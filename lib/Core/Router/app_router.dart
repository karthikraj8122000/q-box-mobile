import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/sub/delivery_status.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/sub/scan_qbox_unload.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/qr_scanner_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/main_page.dart';
import 'package:qr_page/Features/Screens/Splash/animated_splash.dart';
import 'package:qr_page/Provider/auth_provider.dart';

import '../../Features/Screens/MainPage/Dashboard/see_all_qbox_foods.dart';

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
        name: SeeAllQboxFoods.routeName,
        path: SeeAllQboxFoods.routeName,
        builder: (_, __) => const SeeAllQboxFoods(),
      ),



      GoRoute(
        name: ScanQBoxScreen.routeName,
        path: ScanQBoxScreen.routeName,
        builder: (_, __) => const ScanQBoxScreen(),
      ),

      GoRoute(
        name: DeliveryStatusScreen.routeName,
        path: DeliveryStatusScreen.routeName,
        builder: (_, __) => const DeliveryStatusScreen(),
      ),

      GoRoute(
        name: OrderQRScannerScreen.routeName,
        path: OrderQRScannerScreen.routeName,
        builder: (_, __) => const OrderQRScannerScreen(),
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
