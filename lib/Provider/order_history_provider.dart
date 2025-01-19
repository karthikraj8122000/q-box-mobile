import 'package:flutter/material.dart';
import '../Services/api_service.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _inwardOrdersList = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _purchaseOrder;
  final Set<int> _expandedIndices = {};

  List<dynamic> get inwardOrdersList => _inwardOrdersList;
  Map<String, dynamic>? get purchaseOrder => _purchaseOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<int>  get expandedIndices => _expandedIndices;

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {};
      var result = await _apiService.post(
          "8911",
          "masters",
          "partner_channel_inward_delivery_history",
          params
      );
      print("resultss$result");

      if (result != null && result['data'] != null) {
        if (result['data'] is Map) {
          var dataMap = result['data'] as Map<String, dynamic>;
          _purchaseOrder = dataMap['purchaseOrder'] as Map<String, dynamic>?;
          _inwardOrdersList = dataMap['purchaseOrderDtls'] as List? ?? [];
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}