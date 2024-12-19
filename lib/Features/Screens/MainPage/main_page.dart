import 'package:flutter/material.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_screen/dispatch_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_history/history.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/storage_screen.dart';
import 'package:qr_page/Theme/app_theme.dart';

import '../../../Utils/utils.dart';


class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/landing-page';
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FoodStorageScreen(),
    DispatchScreen(),
    DispatchHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleWillPop(context),
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Storage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.departure_board),
              label: 'Dispatch',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.appTheme,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}