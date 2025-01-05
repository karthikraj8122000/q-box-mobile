import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/MainPage/Customer%20Delivery/main/delivery_tracking.dart';
import 'package:qr_page/Features/Screens/MainPage/Dashboard/dashboard.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/load-unload-main.dart';
import 'package:qr_page/Features/Screens/MainPage/Order%20History/history.dart';
import '../../Features/Screens/MainPage/Order/order_qr_scanner.dart';
import 'app_bootom_bar.dart';
import 'app_colors.dart';
import 'app_text.dart'; // Make sure you import this


class AppNavBar extends StatefulWidget {
  const AppNavBar({
    required this.child,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('AppNavBar'));

  final child;

  @override
  _AppNavBarState createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('object ${widget.child}');
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppBottomBar(
        opacity: .2,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int? index) => _onTap(context, index ?? 0),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
        elevation: 8,
        hasInk: true,
        items: _navigationItems,
      ),
    );
  }

  static const _navigationItems = <AppBottomBarItem>[
    AppBottomBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      title: "Home",
    ),
    AppBottomBarItem(
      icon: Icon(Icons.outbox),
      activeIcon: Icon(Icons.outbox),
      title: "Load/Unload",
    ),
    AppBottomBarItem(
      icon: Icon(Icons.shopping_cart),
      activeIcon: Icon(Icons.shopping_cart),
      title:"Inward Order",
    ),
    AppBottomBarItem(
      icon: Icon(Icons.delivery_dining),
      activeIcon: Icon(Icons.delivery_dining_rounded),
      title: "Delivery",
    ),
    AppBottomBarItem(
      icon: Icon(Icons.history),
      activeIcon: Icon(Icons.history),
      title: "History",
    ),

  ];

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(Dashboard.routeName)) {
      return 0;
    }
    if (location.startsWith(LoadOrUnload.routeName)) {
      return 1;
    }
    if (location.startsWith(InwardOrder.routeName)) {
      return 2;
    }
    if (location.startsWith(DeliveryTrackingScreen.routeName)) {
      return 3;
    }
    if (location.startsWith(HistoryScreen.routeName)) {
      return 4;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    print("_onTap index ${index}");
    switch (index) {
      case 0:
        GoRouter.of(context).go(Dashboard.routeName);
        break;
      case 1:
        GoRouter.of(context).go(LoadOrUnload.routeName);
        break;
      case 2:
        GoRouter.of(context).go(InwardOrder.routeName);
      case 3:
        GoRouter.of(context).go(DeliveryTrackingScreen.routeName);
      case 4:
        GoRouter.of(context).go(HistoryScreen.routeName);
        break;

    }
  }
}
