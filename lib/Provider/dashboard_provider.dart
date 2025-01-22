import 'package:flutter/material.dart';

import '../Services/api_service.dart';
import '../Services/toast_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  List<dynamic> _qboxList = [];
  List<dynamic> _hotboxCountList = [];
  List<dynamic> _currentInventoryCountlist = [];
  bool _isLoading = true;
  String? _error;
  final List<dynamic> _outwardOrderList = [
    {"name":"Biriyani","count":8},
    {"name":"Sambar","count":12},
  ];

  List<dynamic> get qboxLists => _qboxList;
  List<dynamic> get hotboxCountList => _hotboxCountList;
  List<dynamic> get currentInventoryCountlist => _currentInventoryCountlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get outwardOrderList => _outwardOrderList;

  Future<void> getQboxes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {"qboxEntitySno": 26};
      var result = await apiService.post(
          "8911", "masters", "get_box_cell_inventory", params);

      if (result != null && result['data'] != null) {
        _qboxList = result['data'].values.toList();
        print('_qboxList$_qboxList');
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      _error = 'An error occurred while retrieving the data.';
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getCurrentInventoryCount() async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //
  //     Map<String, dynamic> params = {"qboxEntitySno": 26,"transactionDate": "2025-01-09"};
  //     var result = await apiService.post(
  //         "8911", "masters", "get_sku_dashboard_counts", params);
  //
  //     if (result != null && result['data'] != null) {
  //       _currentInventoryCountlist = result['data'];
  //       print('_currentInventoryCountlist$_currentInventoryCountlist');
  //     } else {
  //       _error = 'Failed to retrieve the data.';
  //       commonService.errorToast(_error!);
  //     }
  //   } catch (e) {
  //     _error = 'An error occurred while retrieving the data.';
  //     debugPrint('$e');
  //     commonService.errorToast(_error!);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> getHotboxCount() async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //
  //     Map<String, dynamic> params = {"qboxEntitySno": 26,"transactionDate": "2025-01-09"};
  //     var result = await apiService.post(
  //         "8911", "masters", "get_hotbox_count", params);
  //
  //     if (result != null && result['data'] != null) {
  //       _hotboxCountList = result['data']['hotbox_counts'];
  //       print('_hotboxCountlist$_hotboxCountList');
  //     } else {
  //       _error = 'Failed to retrieve the data.';
  //       commonService.errorToast(_error!);
  //     }
  //   } catch (e) {
  //     _error = 'An error occurred while retrieving the data.';
  //     debugPrint('$e');
  //     commonService.errorToast(_error!);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

}