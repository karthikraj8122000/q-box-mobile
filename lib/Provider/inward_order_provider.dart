// Modified InwardOrderDtlProvider
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/Inward%20Order/qr_scanner_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/View%20Order/view_order.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Services/toast_service.dart';
import 'package:qr_page/Services/token_service.dart';

class InwardOrderDtlProvider extends ChangeNotifier {
  String _scanStatus = "notComplete";
  List _purchaseOrders = [];
  dynamic purchaseOrderId;
  final ApiService _apiService = ApiService();
  final CommonService commonService = CommonService();
  bool _isLoading = true;
  String? _error;
  final TokenService _tokenService = TokenService();
  String get scanStatus => _scanStatus;
  List get purchaseOrders => _purchaseOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void resetScan(BuildContext context) {
    _purchaseOrders = [];
    notifyListeners();
  }

  Future<void> scanOrderQR(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        await handleEntry(context, barcodeScanRes);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewOrder(
              partnerPurchaseOrderId:
                  barcodeScanRes, // Your purchase order number
            ),
          ),
        );
      }
    } catch (e) {
      _showError(context, 'Error scanning QR code: $e');
    }
  }

  Future<bool> validateManualEntry(List<String> digits) {
    return Future.value(digits.every((digit) => digit.isNotEmpty));
  }

  Future<void> handleManualEntry(
      BuildContext context, List<TextEditingController> controllers) async {
    final digits = controllers.map((c) => c.text).toList();

    if (await validateManualEntry(digits)) {
      final orderId = digits.join();
      await handleEntry(context, 'SWIGGY_$orderId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewOrder(
            partnerPurchaseOrderId:
                "SWIGGY_$orderId", // Your purchase order number
          ),
        ),
      );
      // GoRouter.of(context).push(ViewOrder.routeName);
      // if (_scanStatus == 'complete') {
      //   GoRouter.of(context).push(ViewOrder.routeName);
      // }
    } else {
      _showError(context, 'Please fill all fields');
    }
  }

  Future<dynamic> getTotalItems(String? partnerPurchaseOrderId) async {
    var entitySno = await _tokenService.getQboxEntitySno();
    print("receiveOrderSno$entitySno");
    const String endpoint = 'search_purchase_order';
    const String port = '8912';
    const String service = 'masters';
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      Map<String, dynamic> params = {
        'qboxEntitySno': entitySno,
        "partnerPurchaseOrderId": partnerPurchaseOrderId
      };
      print("partnerPurchaseOrderIddd $params");
      final response = await _apiService.post(port, service, endpoint, params);
      print("responsesssss $response");
      if (response != null && response['data'] != null) {
        _purchaseOrders = response['data'];
        print("purchaseOrderssss$_purchaseOrders");
        notifyListeners();
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

  void _showError(BuildContext context, String message) {
    commonService.errorToast(message);
  }

  Future<void> handleEntry(BuildContext context, String orderId) async {
    const String endpoint = 'partner_channel_inward_delivery';
    const String port = '8912';
    const String service = 'masters';

    final Map<String, dynamic> requestBody = {
      'partnerPurchaseOrderId': orderId,
    };

    try {
      final response =
          await _apiService.post(port, service, endpoint, requestBody);
      print("response$response");
      if (response['data'] != null &&
          response['data']["purchaseOrder"] != null) {
        await getTotalItems(requestBody['partnerPurchaseOrderId']);
        _scanStatus = 'complete';
        notifyListeners();
      }
    } catch (error) {
      _showError(context, 'Failed to process order: $error');
    }
  }
}
