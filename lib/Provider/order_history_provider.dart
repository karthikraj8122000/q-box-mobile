import 'package:flutter/material.dart';
import '../Services/api_service.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  List<dynamic>  _purchaseOrder = [];
  final Set<int> _expandedInwardIndices = {};
  final Set<int> _expandedOutwardIndices = {};
  List<dynamic> _salesOrder = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<int>  get expandedInwardIndices => _expandedInwardIndices;
  Set<int>  get expandedOutwardIndices => _expandedOutwardIndices;
  List<dynamic> get purchaseOrder => _purchaseOrder;
  List<dynamic> get salesOrder => _salesOrder;

  Future<void> fetchOutwardOrderItems(int qboxEntitySno) async {
    try{
      _isLoading = true;
      notifyListeners();
      Map<String, dynamic> params = {
        "qboxEntitySno":qboxEntitySno
      };

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

  Future<void> fetchInwardOrders(int qboxEntitySno) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {
        "qboxEntitySno":qboxEntitySno
      };

      var result = await _apiService.post(
          "8911",
          "masters",
          "partner_channel_inward_delivery_history",
          params
      );

      if (result != null && result['data'] != null && result['data']['myOrders'] != null) {
        print("inwardOrderResult:${result['data']}");
        _purchaseOrder = result['data']['myOrders'];
        print("inwardOrder:$_purchaseOrder");
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

  // Future<void> fetchInwardOrders(int qboxEntitySno) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //     Map<String, dynamic> params = {
  //       "qboxEntitySno":qboxEntitySno
  //     };
  //
  //     var result = await _apiService.post(
  //         "8911",
  //         "masters",
  //         "partner_channel_inward_delivery_history",
  //         params
  //     );
  //     print("resultss$result");
  //     if (result != null) {
  //       if (result is List) {
  //         _purchaseOrder = result;
  //       } else if (result is Map<String, dynamic>) {
  //         var data = result['data'];
  //         if (data is List) {
  //           _purchaseOrder = data;
  //         } else if (data is Map<String, dynamic>) {
  //           _purchaseOrder = [data];
  //         } else {
  //           _purchaseOrder = [];
  //         }
  //       } else {
  //         _purchaseOrder = [];
  //       }
  //     } else {
  //       _purchaseOrder = [];
  //     }
  //     _isLoading = false;
  //     notifyListeners();
  //
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}