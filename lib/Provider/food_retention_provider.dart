import 'package:flutter/material.dart';
import 'package:qr_page/Services/toast_service.dart';

import '../Model/Data_Models/Food_item/qbox_sku_inventory_item.dart';
import '../Model/Data_Models/scanner_model/scanner_model.dart';
import '../Services/api_service.dart';

class FoodRetentionProvider extends ChangeNotifier {
  List<FoodItem> storedItems = [];
  List<FoodItem> dispatchedItems = [];
  final CommonService commonService = CommonService();
  final ScannerModel _scannerModel = ScannerModel();
  final ApiService apiService = ApiService();

  ScannerModel get scannerModel => _scannerModel;

  void addStoredItem(FoodItem item) {
    storedItems.add(item);
    notifyListeners();
  }

  void addDispatchedItem(FoodItem item) {
    dispatchedItems.add(item);
    notifyListeners();
  }

  Future<void> loadToQBox() async {
    Map<String, dynamic> body = {
      "uniqueCode": _scannerModel.foodBarcode,
      "wfStageCd": 11,
      "boxCellSno": _scannerModel.qBoxBarcode,
      "qboxEntitySno": 3
    };
    try {
      print(body);
      // var result =
      //     await apiService.post("8912", "masters", "load_sku_in_qbox", body);
      // if (result != null && result['data'] != null) {
      //   _scannerModel.qBoxBarcode = '';
      //   _scannerModel.foodBarcode = '';
      //   commonService.presentToast('Food Loaded inside the qbox');
      // }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }
}
