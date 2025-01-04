import 'package:flutter/material.dart';

import '../Services/api_service.dart';
import '../Services/toast_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  List<dynamic> _qboxList = [];

  List<dynamic> get qboxLists => _qboxList;

  Future<void> getQboxes() async {
    print("Fetching Qboxes...");
    Map<String, dynamic> params = {"qboxEntitySno": 20};
    try {
      var result = await apiService.post(
          "8911", "masters", "get_box_cell_inventory", params);
      print("API Response: $result");
      if (result != null && result['data'] != null) {
        _qboxList = result['data'].values.toList();
        print("Updated _qboxList: $_qboxList");
        notifyListeners();
      } else {
        commonService.errorToast('Failed to retrieve the data.');
      }
    } catch (e) {
      debugPrint('$e');
      commonService.errorToast('An error occurred while retrieving the data.');
    }
  }


}