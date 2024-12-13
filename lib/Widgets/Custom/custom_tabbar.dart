import 'package:flutter/material.dart';
import '../../Model/Data_Models/tab_model/tab_items_model.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int) onTabSelected;
  final List<TabItem> tabItems; // List of tab items

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.onTabSelected,
    required this.tabItems, // Accept tab items
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      onTap: onTabSelected,
      indicatorColor: Colors.pinkAccent,
      tabs: tabItems.map((tabItem) {
        return Tab(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tabItem.icon),
              const SizedBox(width: 10),
              Text(tabItem.label, style: const TextStyle(fontSize: 20)),
            ],
          ),
        );
      }).toList(),
    );
  }
}