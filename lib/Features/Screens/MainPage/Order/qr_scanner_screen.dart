import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_page/Widgets/Common/divider_text.dart';
import '../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../Provider/order/scan_provider.dart';
import '../../../../Widgets/Common/app_colors.dart';

class OrderQRScannerScreen extends StatefulWidget {
  const OrderQRScannerScreen({Key? key}) : super(key: key);

  @override
  State<OrderQRScannerScreen> createState() => _OrderQRScannerScreenState();
}

class _OrderQRScannerScreenState extends State<OrderQRScannerScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

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

  Future<void> _scanOrderQR(BuildContext context) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        _fetchOrderDetails(context, barcodeScanRes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning QR code: $e')),
      );
    }
  }

  void _fetchOrderDetails(BuildContext context, String orderId) async {
    final orderProvider = Provider.of<ScanProvider>(context, listen: false);
    try {
      await orderProvider.fetchOrderDetails(orderId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching order details: $e')),
      );
    }
  }

  void _handleManualEntry() {
    String orderId = _controllers.map((c) => c.text).join();
    if (orderId.length == 6) {
      _fetchOrderDetails(context, orderId);
    }
  }

  Future<void> _scanItemQR(String itemId) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        Provider.of<ScanProvider>(context, listen: false)
            .updateFoodItemQRCode(itemId, barcodeScanRes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item QR scanned successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning QR code: $e')),
      );
    }
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

  Widget _buildOrderDetails(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text('Order ID: ${order.orderId}'),
        Text('Total Items: ${order.totalItems}'),
        SizedBox(height: 16),
        Text(
          'Food Items:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...order.items.where((item) => item.status == 'pending').map((item) => _buildFoodItemCard(item)).toList(),
      ],
    );
  }

  Widget _buildFoodItemCard(InwardFoodModel item) {
    bool isScanned = item.qrCode != null;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(item.name),
            subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
            trailing: item.status == 'pending' ? ElevatedButton.icon(
              onPressed: () => _scanItemQR(item.id),
              icon: Icon(Icons.qr_code_scanner),
              label: Text('Scan QR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mintGreen,
              ),
            ) : null,
          ),
          if (item.status == 'pending' && isScanned)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateItemStatus(item.id, 'accepted'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showRejectDialog(item.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Reject'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _updateItemStatus(String itemId, String status, {String? reason, File? photo}) {
    Provider.of<ScanProvider>(context, listen: false).updateFoodItemStatus(
      itemId,
      status,
      reason: reason,
      photo: photo,
    );
  }

  Future<void> _rescanFoodItem(String itemId) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanRes != '-1') {
        // Update the food item with the new scanned data
        Provider.of<ScanProvider>(context, listen: false).updateFoodItemQRCode(itemId, barcodeScanRes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning QR code: $e')),
      );
    }
  }

  Future<void> _showRejectDialog(String itemId) async {
    final TextEditingController _reasonController = TextEditingController();
    File? _photo;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Reason for rejection',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  _photo = File(image.path);
                }
              },
              child: Text('Take Photo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintGreen, foregroundColor: AppColors.white),
            onPressed: () {
              _updateItemStatus(
                itemId,
                'rejected',
                reason: _reasonController.text,
                photo: _photo,
              );
              Navigator.pop(context);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Consumer<ScanProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!orderProvider.isOrderScanned) ...[
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
                        onPressed: () => _scanOrderQR(context),
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text('Scan Now'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.black,
                        ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     _buildOTPFields(),
                      SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () => _handleManualEntry(),
                        label: Text('Submit'),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(Icons.arrow_forward),
                        style: ElevatedButton.styleFrom(

                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (orderProvider.isOrderScanned && orderProvider.currentOrder != null) ...[
                _buildOrderDetails(orderProvider.currentOrder!),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintGreen, padding: EdgeInsets.symmetric(vertical: 12)),
                  onPressed: () => orderProvider.resetOrder(),
                  child: Text('Scan New Order'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

