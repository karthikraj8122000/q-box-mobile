import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../Model/Data_Models/scanner_model/scanner_model.dart';
import '../Services/api_service.dart';
import '../Services/toast_service.dart';


class ScannerProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  final ScannerModel _scannerModel = ScannerModel();
  String _scanBarcode = 'Unknown';

  ScannerModel get scannerModel => _scannerModel;
  String get scanBarcode => _scanBarcode;

  void updateQBoxBarcode(String barcode) {
    _scannerModel.qBoxBarcode = barcode;
    notifyListeners();
  }

  void updateFoodBarcode(String barcode) {
    _scannerModel.foodBarcode = barcode;
    notifyListeners();
  }

  void updateQBoxOutBarcode(String barcode) {
    _scannerModel.qBoxOutBarcode = barcode;
    notifyListeners();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      _scanBarcode = barcodeScanRes;
      notifyListeners();
      // await get();
    } catch (e) {
      _scanBarcode = 'Failed to get platform version.';
      notifyListeners();
    }
  }

  Future<void> loadToQBox() async {
    Map<String, dynamic> body = {
      "uniqueCode": _scannerModel.foodBarcode,
      "wfStageCd": 11,
      "boxCellSno": _scannerModel.qBoxBarcode,
      "qboxEntitySno": 3
    };
    try {
      var result = await apiService.post("8912","masters","load_sku_in_qbox", body);
      if (result != null && result['data'] != null) {
        _scannerModel.qBoxBarcode = '';
        _scannerModel.foodBarcode = '';
        commonService.presentToast('Food Loaded inside the qbox');
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }

  Future<void> unloadFromQBox() async {
    Map<String, dynamic> body = {
      "uniqueCode": _scannerModel.qBoxOutBarcode,
      "wfStageCd": 12,
      "qboxEntitySno": 2
    };
    try {
      var result = await apiService.post("8912","masters","unload_sku_from_qbox_to_hotbox", body);
      if (result != null && result['data'] != null) {
        commonService.presentToast('Food Unloaded from the qbox');
        _scannerModel.qBoxOutBarcode = '';
      } else {
        commonService.presentToast('Something went wrong....');
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }
}