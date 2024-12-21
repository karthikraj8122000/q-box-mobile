import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';


class OrderScanningProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  CommonService commonService = CommonService();
  String _scanBarcode = 'Unknown';
  final String _scanSalesBarcode = 'Unknown';
  Map<String, dynamic> value = {};
  Map<String, dynamic> returnValue = {};
  bool isDisable = true;
  Timer? _debounce;

  String get scanBarcode => _scanBarcode;
  String get scanSalesBarcode => _scanSalesBarcode;

  Map<String, dynamic>? get orderDetails => value['purchaseOrder'];
  List<dynamic>? get orderItems => value['purchaseOrderDtls'];


  Map<String, dynamic>? get salesOrderDetails => returnValue['salesOrder'];
  List<dynamic>? get salesOrderItems => returnValue['salesOrderDtls'];

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      _scanBarcode = barcodeScanRes;
      notifyListeners();
      await get(_scanBarcode);
    } catch (e) {
      _scanBarcode = 'Failed to get platform version.';
      notifyListeners();
    }
  }



  void onChangeValidate(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      isDisable = text.isEmpty;
      notifyListeners();
    });
  }

  Future<void> get(String orderId) async {
    Map<String, dynamic> params = {"partnerPurchaseOrderId": orderId.isNotEmpty ? orderId : _scanSalesBarcode};
    var result = await apiService.post(
        "8912", "masters", "partner_channel_inward_delivery", params);
    if (result != null && result['data'] != null) {
      value = result['data'];
      print('value$value');
      if (value['purchaseOrderDtls'] != null) {
        commonService.presentToast('Order is Delivered');
      }else{
        commonService.presentToast('Invalid Order');
      }
    }

    _scanBarcode = "";
    notifyListeners();
  }

}


