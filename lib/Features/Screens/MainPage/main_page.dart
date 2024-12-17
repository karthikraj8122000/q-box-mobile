import 'package:flutter/material.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_screen/dispatch_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/history.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/storage_screen.dart';


class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/landing-page';
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    StorageScreen(),
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
    return Scaffold(
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
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}