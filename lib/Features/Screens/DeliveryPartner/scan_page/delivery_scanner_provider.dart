import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

import '../../../../Services/api_service.dart';

class ScannerProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  String _scanBarcode = 'Unknown';
  Map<String, dynamic> _value = {};
  Map<String, dynamic> _returnValue = {};
  List<dynamic> _returnPurchaseList = [];
  List<String> _decodedData = [];
  bool _scanData = false;
  List<dynamic> _items = [];
  bool _isShow = false;
  bool _isSalesShow = false;
  Barcode? _result;

  // Getters
  String get scanBarcode => _scanBarcode;
  Map<String, dynamic> get value => _value;
  Map<String, dynamic> get returnValue => _returnValue;
  List<dynamic> get returnPurchaseList => _returnPurchaseList;
  List<String> get decodedData => _decodedData;
  bool get scanData => _scanData;
  List<dynamic> get items => _items;
  bool get isShow => _isShow;
  bool get isSalesShow => _isSalesShow;
  Barcode? get result => _result;

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      _result = scanData;
      notifyListeners();
    });
  }

  void change() {
    _isShow = !_isShow;
    notifyListeners();
  }

  void salesChange() {
    _isSalesShow = !_isSalesShow;
    notifyListeners();
  }

  Future<void> getPurchaseId() async {
    print('sssss');
    Map<String, dynamic> params = {};
    var result = await apiService.post("8912", "masters", "search_purchase_order", params);
    print('result$result');
    if (result != null && result['data'] != null) {
      _returnPurchaseList = result['data'];
      await get();
      notifyListeners();
    } else {
      print('Error: result or result["data"] is null');
    }
    // notifyListeners();
  }

  Future<void> get() async {
    if (_returnPurchaseList.isNotEmpty) {
      Map<String, dynamic> params = {
        "partnerPurchaseOrderId": _returnPurchaseList[0]['partnerPurchaseOrderId']
      };
      var result = await apiService.post("8912", "masters", "partner_channel_inward_delivery", params);
      if (result != null && result['data'] != null) {
        _value = result['data'];
      } else {
        print('Error: result or result["data"] is null');
      }
      notifyListeners();
    }
  }

}


