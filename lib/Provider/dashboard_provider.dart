import 'package:flutter/material.dart';

import '../Services/api_service.dart';
import '../Services/toast_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  List<dynamic> _qboxList = [];

  List<dynamic> get qboxLists => _qboxList;

Future<dynamic> getQboxes() async {
  print("hrllo");
  Map<String, dynamic> params = {"qboxEntitySno": 3};
  try {
    var result = await apiService.post(
        "8912", "masters", "get_box_cell_inventory", params);
    print("karthikqbox");
    print(result);
    if (result != null && result['data'] != null) {
      _qboxList = result['data'];
      notifyListeners();
    } else {
      commonService.errorToast('Failed at retrieving the food item.');
    }
  } catch (e) {
    debugPrint('$e');
    commonService
        .errorToast('An error occurred while retrieving the food item.');
  }
}
}