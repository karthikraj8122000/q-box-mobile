import 'package:flutter/material.dart';
import 'package:qr_page/Services/toast_service.dart';

import '../Model/Data_Models/Food_item/foot_item_model.dart';
import '../Model/Data_Models/scanner_model/scanner_model.dart';
import '../Services/api_service.dart';

class FoodRetentionProvider extends ChangeNotifier {
  List<FoodItem> storedItems = [];
  List<FoodItem> dispatchedItems = [];
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();

  void addStoredItem(FoodItem item) {
    storedItems.add(item);
    notifyListeners();
  }

  void addDispatchedItem(FoodItem item) {
    dispatchedItems.add(item);
    notifyListeners();
  }
}
