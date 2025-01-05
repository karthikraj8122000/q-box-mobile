import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Core/Router/bottom_bar_routes.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/main/delivery_tracking.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/sub/delivery_status.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/sub/scan_qbox_unload.dart';
import 'package:qr_page/Features/Screens/MainPage/Dashboard/dashboard.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/load-unload-main.dart';
import 'package:qr_page/Features/Screens/MainPage/Order%20History/history.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/order_qr_scanner.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/qr_scanner_screen.dart';
import 'package:qr_page/Features/Screens/Splash/animated_splash.dart';
import 'package:qr_page/Provider/auth_provider.dart';

import '../../Features/Screens/MainPage/Dashboard/see_all_qbox_foods.dart';
import '../../Widgets/Common/app_nav_bar.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _routerKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _mainMenuNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'main-menu');
  static GlobalKey<NavigatorState> get routerKey => _routerKey;

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: AnimeSplashScreen.routeName,
    observers: [
      GoRouterObserver(),
    ],// Default splash screen
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

      ShellRoute(
        navigatorKey: _mainMenuNavigatorKey,
        builder: (_, __, child) {
          print('child$child');
          return Scaffold(
              body: AppNavBar(child: child));
        },
        routes: <RouteBase>[
          ...AppBottomBarRoutes.mainMenuRoutes,
        ],
      ),
    ],
  );

  static void navigateToHomeView() {
    _router.replaceNamed(Dashboard.routeName);
    _router.goNamed(Dashboard.routeName);
  }

  static void navigateToLoadUnload() {
    return _router.go(LoadOrUnload.routeName);
  }

  static void navigateToInwardOrder() {
    return _router.go(InwardOrder.routeName);
  }

  static void navigateToDelivery() {
    return _router.go(DeliveryTrackingScreen.routeName);
  }

  static void navigateToHistory() {
    return _router.go(HistoryScreen.routeName);
  }


  static GoRouter get router => _router;
}


class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('1111');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('2222');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('3333');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('4444');
  }
}

