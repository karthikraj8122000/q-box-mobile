import 'package:flutter/material.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/load-unload-main.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/order_qr_scanner.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_screen/dispatch_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_history/history.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/storage_screen.dart';
import '../../../Utils/utils.dart';
import 'dart:math' as math;
import '../../../Widgets/Common/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/landing-page';
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FoodStorageScreen(),
    LoadOrUnload(),
    InwardOrder(),
    // DispatchScreen(),
    DispatchHistoryScreen(),
  ];

  // List of navigation items
  final List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home_outlined, label: 'Home', selectedIcon: Icons.home),
    NavigationItem(icon: Icons.outbox, label: 'Load/Unload', selectedIcon: Icons.outbox),
    NavigationItem(icon: Icons.shopping_cart, label: 'Inward Order', selectedIcon: Icons.shopping_cart),
    // NavigationItem(icon: Icons.outbox, label: 'Unload', selectedIcon: Icons.outbox),
    NavigationItem(icon: Icons.history, label: 'History', selectedIcon: Icons.history),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleWillPop(context),
      child: Scaffold(
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomAppBar(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_items.length, (index) {
                    return _buildNavItem(_items[index], index);
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationItem item, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mintGreen.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.icon,
              color: isSelected ? AppColors.mintGreen : Colors.grey,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected ? AppColors.mintGreen : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(item.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.selectedIcon,
  });
}