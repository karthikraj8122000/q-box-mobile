import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Services/toast_service.dart';

import '../../Model/Data_Models/inward_food_model.dart';


class ScanProvider with ChangeNotifier {

  Order? _currentOrder;
  bool _isOrderScanned = false;
  List<Order> _orders = [];

  Order? get currentOrder => _currentOrder;
  bool get isOrderScanned => _isOrderScanned;
  List<Order> get orders => _orders;
  final CommonService commonService = CommonService();

  Future<void> fetchOrderDetails(String orderId) async {
    // Simulated API call
    await Future.delayed(Duration(seconds: 1));
    _currentOrder = Order(
      orderId: orderId,
      totalItems: 3,
      items: [
        InwardFoodModel(id: '1', name: 'Pizza', price: 10.99, qrCode: 'PIZZA001'),
        InwardFoodModel(id: '2', name: 'Burger', price: 8.99, qrCode: 'BURGER001'),
        InwardFoodModel(id: '3', name: 'Fries', price: 3.99, qrCode: 'FRIES001'),
      ],
    );
    _isOrderScanned = true;
    notifyListeners();
  }

  void updateFoodItemStatus(String itemId, String status, {String? reason, File? photo}) {
    if (_currentOrder != null) {
      final index = _currentOrder!.items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _currentOrder!.items[index].status = status;
        _currentOrder!.items[index].rejectionReason = reason;
        _currentOrder!.items[index].rejectionPhoto = photo;
        notifyListeners();
      }
    }
  }

  void resetOrder() {
    if (_currentOrder != null) {
      _orders.add(_currentOrder!);
    }
    _currentOrder = null;
    _isOrderScanned = false;
    notifyListeners();
  }


  void updateFoodItemQRCode(String itemId, String newQRCode) {
    if (_currentOrder != null) {
      final index = _currentOrder!.items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _currentOrder!.items[index].qrCode = newQRCode;
        notifyListeners();
      }
    }
  }

  bool isItemScanned(String itemId) {
    return _currentOrder?.items
        .firstWhere((item) => item.id == itemId)
        .qrCode != null;
  }

  bool canAcceptRejectItem(String itemId) {
    if (_currentOrder == null) return false;
    final item = _currentOrder!.items.firstWhere((item) => item.id == itemId);
    return item.qrCode != null && item.status == 'pending';
  }
}
