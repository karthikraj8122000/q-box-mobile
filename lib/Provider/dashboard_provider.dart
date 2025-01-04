import 'package:flutter/material.dart';

import '../Services/api_service.dart';
import '../Services/toast_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  List<dynamic> _qboxList = [];
  bool _isLoading = true;
  String? _error;

  List<dynamic> get qboxLists => _qboxList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getQboxes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {"qboxEntitySno": 3};
      var result = await apiService.post(
          "8911", "masters", "get_box_cell_inventory", params);

      if (result != null && result['data'] != null) {
        _qboxList = result['data'].values.toList();
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      _error = 'An error occurred while retrieving the data.';
      debugPrint('$e');
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}