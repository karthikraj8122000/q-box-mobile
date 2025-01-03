import 'package:flutter/foundation.dart';

class FoodItem {
  final String name;
  final String code;
  String status;
  final DateTime createdAt;

  FoodItem({
    required this.name,
    required this.code,
    this.status = 'pending',
    required this.createdAt,
  });
}

class Order {
  final String orderId;
  final List<FoodItem> foodItems;
  final DateTime createdAt;
  bool isScanning;

  Order({
    required this.orderId,
    required this.foodItems,
    required this.createdAt,
    this.isScanning = false,
  });
}

class OrderProvider with ChangeNotifier {
  Order? _currentOrder;
  bool _showOrderDetails = false;

  Order? get currentOrder => _currentOrder;
  bool get showOrderDetails => _showOrderDetails;

  void setOrder(Order order) {
    _currentOrder = order;
    _showOrderDetails = false;
    notifyListeners();
  }

  void updateFoodItemStatus(String code, String status) {
    if (_currentOrder != null) {
      final index = _currentOrder!.foodItems.indexWhere((item) => item.code == code);
      if (index != -1) {
        _currentOrder!.foodItems[index].status = status;
        _showOrderDetails = true;
        notifyListeners();
      }
    }
  }

  void setScanning(bool scanning) {
    if (_currentOrder != null) {
      _currentOrder!.isScanning = scanning;
      notifyListeners();
    }
  }
}

