import 'package:flutter/material.dart';
import '../Services/api_service.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  List<dynamic>  _purchaseOrder = [];
  final Set<int> _expandedIndices = {};
  List<dynamic> _salesOrder = [];


  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<int>  get expandedIndices => _expandedIndices;
  List<dynamic> get purchaseOrder => _purchaseOrder;
  List<dynamic> get salesOrder => _salesOrder;

  Future<void> fetchOutwardOrderItems() async {
    try{
      _isLoading = true;
      notifyListeners();

      Map<String, dynamic> params = {};
      var result = await _apiService.post(
        "8911",
        "masters",
        "partner_channel_outward_delivery_history",
        params,
      );

      if (result != null) {
        if (result is List) {
          _salesOrder = result;
        } else if (result is Map<String, dynamic>) {
          var data = result['data'];
          if (data is List) {
            _salesOrder = data;
          } else if (data is Map<String, dynamic>) {
            _salesOrder = [data];
          } else {
            _salesOrder = [];
          }
        } else {
          _salesOrder = [];
        }
      } else {
        _salesOrder = [];
      }
      _isLoading = false;
      notifyListeners();
    }catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInwardOrders() async {
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
      if (result != null) {
        if (result is List) {
          _purchaseOrder = result;
        } else if (result is Map<String, dynamic>) {
          var data = result['data'];
          if (data is List) {
            _purchaseOrder = data;
          } else if (data is Map<String, dynamic>) {
            _purchaseOrder = [data];
          } else {
            _purchaseOrder = [];
          }
        } else {
          _purchaseOrder = [];
        }
      } else {
        _purchaseOrder = [];
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