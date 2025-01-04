// lib/screens/order/order_qr_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/widgets/food_items_grid.dart';
import 'package:qr_page/Provider/order/order_card.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

import '../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../Provider/order/scan_provider.dart';
import '../../../../Widgets/Common/divider_text.dart';
import 'widgets/food_item_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/scanning_dialogs.dart';

class OrderQRScannerScreen extends StatefulWidget {
  static const String routeName = '/order-scan';
  const OrderQRScannerScreen({super.key});

  @override
  State<OrderQRScannerScreen> createState() => _OrderQRScannerScreenState();
}

class _OrderQRScannerScreenState extends State<OrderQRScannerScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _showSummary = false;
  String scan = "notComplete";
  List purchaseOrder = [];


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void resetScan() {
    setState(() {
      scan = "notComplete";
      purchaseOrder = [];
      // Clear the text controllers
      for (var controller in _controllers) {
        controller.clear();
      }
    });
  }

  Future<void> _scanOrderQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        // _fetchOrderDetails(barcodeScanRes);
        _handleEntry(barcodeScanRes);
      }
    } catch (e) {
      _showError('Error scanning QR code: $e');
    }
  }

  _getTotalItems() async {
    final String endpoint = 'search_purchase_order';
    final String port = '8912'; // Replace with your port
    final String service = 'masters'; // Replace with your service
    try {
      final apiService = ApiService();
      final response = await apiService.post(port, service, endpoint, {});
      print("object${response}");
      setState(() {
        scan = 'complete';
        purchaseOrder = response['data'];
      });
      // Extract totalItems from the response
      // return response['data'] ?? [];
    } catch (error) {
      throw Exception('Failed to fetch totalItems: $error');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleManualEntry() {
    String orderId = _controllers.map((c) => c.text).join();
    _handleEntry(orderId);
    // if (orderId.length == 6) {
    //   _fetchOrderDetails(orderId);
    // }
  }

  void _handleEntry(orderId) async {
    final String endpoint = 'partner_channel_inward_delivery';
    final String port = '8912'; // Replace with your actual port
    final String service = 'masters'; // Replace with your actual service
    final String scannedOrPunchedValue =
        orderId; // Replace with the actual value entered by the user

    final Map<String, dynamic> requestBody = {
      'partnerPurchaseOrderId': scannedOrPunchedValue,
    };

    try {
      final apiService = ApiService();
      final response =
          await apiService.post(port, service, endpoint, requestBody);
      print('API Response: $response');
      if (response['data'] != null &&
          response['data']["purchaseOrder"] != null) {
        _getTotalItems();
        scan = 'complete';
        setState(() {});
        // _fetchOrderDetails(scannedOrPunchedValue);
      }
    } catch (error) {
      // Handle error response
      print('API Error: $error');
      // Show error message to user if necessary
    }
  }

  Future<void> _handleScanItem(InwardFoodModel item) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1' && mounted) {
        Navigator.of(context).pop(); // Close scanning dialog
        _handleAcceptReject(item, barcodeScanRes);
      }
    } catch (e) {
      _showError('Error scanning QR code: $e');
    }
  }

  void _handleAcceptReject(InwardFoodModel item, String scannedCode) {
    ScanningDialogs.showAcceptRejectDialog(
      context,
      item,
      scannedCode,
      (item, code) {
        // Handle Accept
        Provider.of<ScanProvider>(context, listen: false)
            .updateFoodItemStatus(item.id, 'accepted');
        Navigator.of(context).pop();
      },
      (item, code) {
        // Handle Reject
        Navigator.of(context).pop();
        _handleRejection(item);
      },
    );
  }

  void _handleRejection(InwardFoodModel item) {
    ScanningDialogs.showRejectionDialog(
      context,
      item,
      (reason, photo) {
        Provider.of<ScanProvider>(context, listen: false).updateFoodItemStatus(
          item.id,
          'rejected',
          reason: reason,
          photo: photo,
        );
      },
    );
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 5) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialScanView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/qrscan.jpg",
                height: 120,
              ),
              SizedBox(height: 16),
              Text(
                'Scan QR Code',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                'Use your phone to scan the QR code.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mintGreen),
                onPressed: _scanOrderQR,
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scan Now'),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        CustomDivider(text: "OR"),
        SizedBox(height: 24),
        Text(
          'Manual Entry',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOTPFields(),
              SizedBox(height: 24),
              OutlinedButton.icon(
                iconAlignment: IconAlignment.end,
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mintGreen),
                onPressed: _handleManualEntry,
                icon: Icon(Icons.arrow_forward),
                label: Text('Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (scan == "notComplete")
                _buildInitialScanView()
              else if (scan == "complete")
                purchaseOrder.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(

                          onPressed: () => resetScan(),
                          icon: Icon(Icons.qr_code_scanner),
                          label: Text('Scan New Order'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                            backgroundColor: AppColors.mintGreen,
                          ),
                        ),
                        SizedBox(
                                          height: MediaQuery.of(context).size.height ,  // You can adjust the height as needed
                                          child: ListView.builder(
                        itemCount: purchaseOrder.length,
                        itemBuilder: (context, index) {
                          return OrderCard(order:purchaseOrder[index]);
                        },
                                          ),
                                        ),
                      ],
                    )
                    : Container(),  // Empty container if the list is empty
            ],
          ),
        );
      },
    );
  }

}

