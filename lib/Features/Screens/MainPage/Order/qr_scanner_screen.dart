// lib/screens/order/order_qr_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/widgets/food_items_grid.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

import '../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../Provider/order/scan_provider.dart';
import '../../../../Widgets/Common/divider_text.dart';
import 'widgets/food_item_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/scanning_dialogs.dart';

class OrderQRScannerScreen extends StatefulWidget {
  const OrderQRScannerScreen({super.key});

  @override
  State<OrderQRScannerScreen> createState() => _OrderQRScannerScreenState();
}

class _OrderQRScannerScreenState extends State<OrderQRScannerScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _showSummary = false;

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

  Future<void> _scanOrderQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        _fetchOrderDetails(barcodeScanRes);
      }
    } catch (e) {
      _showError('Error scanning QR code: $e');
    }
  }

  void _fetchOrderDetails(String orderId) async {
    final orderProvider = Provider.of<ScanProvider>(context, listen: false);
    try {
      await orderProvider.fetchOrderDetails(orderId,orderProvider.currentOrder!.totalItems);
    } catch (e) {
      _showError('Error fetching order details: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleManualEntry() {
    String orderId = _controllers.map((c) => c.text).join();
    if (orderId.length == 6) {
      _fetchOrderDetails(orderId);
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
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.mintGreen),
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
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.mintGreen),
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

  Widget _buildOrderView(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Order Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        ...order.items.map(
              (item) => FoodItemCard(
            item: item,
            onScanPressed: (item) {
              ScanningDialogs.showScanningDialog(
                context,
                item,
                _handleScanItem,
              );
            },
          ),
        ),
        SizedBox(height: 16),
        if (_showSummary)
          OrderSummaryCard(order: order)
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Provider.of<ScanProvider>(context, listen: false).resetOrder();
                },
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.black,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showSummary = true;
                  });
                },
                icon: Icon(Icons.save),
                label: Text('Save Order'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: AppColors.mintGreen,
                  foregroundColor: AppColors.white,
                ),
              ),

            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!orderProvider.isOrderScanned)
                _buildInitialScanView()
              else if (orderProvider.currentOrder != null)
                _buildOrderView(orderProvider.currentOrder!),
            ],
          ),
        );
      },
    );
  }
}