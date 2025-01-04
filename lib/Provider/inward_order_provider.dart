import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_page/Services/api_service.dart';

class InwardOrderDtlProvider extends ChangeNotifier {
  String _scanStatus = "complete";
  List _purchaseOrders = [];
  final ApiService _apiService = ApiService();

  // Getters
  String get scanStatus => _scanStatus;
  List get purchaseOrders => _purchaseOrders;

  void resetScan() {
    _scanStatus = "notComplete";
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
        handleEntry(context, barcodeScanRes);
      }
    } catch (e) {
      _showError(context, 'Error scanning QR code: $e');
    }
  }

  Future<void> getTotalItems() async {
    const String endpoint = 'search_purchase_order';
    const String port = '8912';
    const String service = 'masters';

    try {
      final response = await _apiService.post(port, service, endpoint, {});
      _scanStatus = 'complete';
      _purchaseOrders = response['data'];
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to fetch totalItems: $error');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleEntry(BuildContext context, String orderId) async {
    const String endpoint = 'partner_channel_inward_delivery';
    const String port = '8912';
    const String service = 'masters';

    final Map<String, dynamic> requestBody = {
      'partnerPurchaseOrderId': orderId,
    };

    try {
      final response = await _apiService.post(port, service, endpoint, requestBody);

      if (response['data'] != null && response['data']["purchaseOrder"] != null) {
        await getTotalItems();
        _scanStatus = 'complete';
        notifyListeners();
      }
    } catch (error) {
      _showError(context, 'Failed to process order: $error');
    }
  }
}