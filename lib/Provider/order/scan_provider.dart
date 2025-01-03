import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Services/toast_service.dart';
import '../../Model/Data_Models/inward_food_model.dart';

class ScanProvider with ChangeNotifier {
  Order? _currentOrder;
  bool _isOrderScanned = false;
  List<Order> _orders = [];
  final ApiService apiService = ApiService();
  String _scanBarcode = 'Unknown';
  Map<String, dynamic> value = {};
  String _scanSalesBarcode = 'Unknown';

  Order? get currentOrder => _currentOrder;
  bool get isOrderScanned => _isOrderScanned;
  List<Order> get orders => _orders;
  final CommonService commonService = CommonService();
  String get scanBarcode => _scanBarcode;
  String get scanSalesBarcode => _scanSalesBarcode;

  Future<void> fetchOrderDetails(String partnerPurchaseOrderId, List<Order> items) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentOrder = Order(
      partnerPurchaseOrderId: partnerPurchaseOrderId,
      deliveryPartnerName: 'Delivery Partner Name', // Replace with actual data
      qboxEntityName: 'QBox Entity Name', // Replace with actual data
      restaurantName: 'Restaurant Name', // Replace with actual data
      purchaseOrderSno: 0,
      qboxEntitySno: 0,
      restaurantSno: 0,
      deliveryPartnerSno: 0,
      orderStatusCd: 1, // Example status code
      orderedBy: 0,
      mealTimeCd: 0,
    );
    _isOrderScanned = true;
    notifyListeners();
  }

  void updateFoodItemStatus(String itemId, String status, {String? reason, File? photo}) {
    // if (_currentOrder != null) {
    //   final index = _currentOrder!.items.indexWhere((item) => item.id == itemId);
    //   if (index != -1) {
    //     _currentOrder!.items[index].status = status;
    //     _currentOrder!.items[index].rejectionReason = reason;
    //     _currentOrder!.items[index].rejectionPhoto = photo;
    //     notifyListeners();
    //   }
    // }
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
      // final index = _currentOrder!.items.indexWhere((item) => item.id == itemId);
      // if (index != -1) {
      //   // _currentOrder!.items[index].qrCode = newQRCode;
      //   notifyListeners();
      // }
    }
  }

  // bool isItemScanned(String itemId) {
  //   return _currentOrder?.items
  //       .firstWhere(
  //           (item) => item.id == itemId,
  //       orElse: () => OrderItem(id: itemId, status: 'pending') // dummy item
  //   )
  //       ?.qrCode != null;
  // }

  // bool canAcceptRejectItem(String itemId) {
  //   if (_currentOrder == null) return false;
  //   // final item = _currentOrder!.items.firstWhere((item) => item.id == itemId, orElse: () =>OrderItem(id: itemId, status: 'pending'));
  //   // return item != null && item.qrCode != null && item.status == 'pending';
  // }

  Future<void> getInwardOrder(String orderId) async {
    Map<String, dynamic> params = {"partnerPurchaseOrderId": orderId.isNotEmpty ? orderId : _scanSalesBarcode};
    var result = await apiService.post(
        "8912", "masters", "partner_channel_inward_delivery", params);
    if (result != null && result['data'] != null) {
      value = result['data'];
      if (value['purchaseOrderDtls'] != null) {
        _currentOrder = Order.fromJson(value['purchaseOrderDtls']);
        commonService.presentToast('Order is Delivered');
      } else {
        commonService.presentToast('Invalid Order');
      }
    }
    _scanBarcode = "";
    notifyListeners();
  }
}

