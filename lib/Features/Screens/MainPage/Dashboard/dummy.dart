// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_page/Model/Data_Models/dashboard_model/dashboard_model.dart';
//
// class DashboardProvider extends ChangeNotifier {
//   bool _isLoading = true;
//   String? _error;
//   List<dynamic> _qboxLists = [];
//   List<InventoryItem> _inventoryItems = [];
//   Map<String, dynamic>? _foodCountData;
//   Map<String, dynamic>? _inventoryData;
//
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<dynamic> get qboxLists => _qboxLists;
//   List<InventoryItem> get inventoryItems => _inventoryItems;
//   Map<String, dynamic>? get foodCountData => _foodCountData;
//   Map<String, dynamic>? get inventoryData => _inventoryData;
//
//   Future<void> loadData() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await Future.wait([
//         _loadInventoryData(),
//         _loadQboxes(),
//       ]);
//
//       _isLoading = false;
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//     }
//     notifyListeners();
//   }
//
//
//
//
//
//   void resetData() {
//     _isLoading = true;
//     _error = null;
//     _qboxLists = [];
//     _inventoryItems = [];
//     _foodCountData = null;
//     _inventoryData = null;
//     notifyListeners();
//   }
// }