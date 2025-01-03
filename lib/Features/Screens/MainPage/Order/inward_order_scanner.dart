import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../Provider/order/order_provider.dart';

class OrderScanner extends StatelessWidget {
  Future<void> _scanOrder(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (barcodeScanRes != '-1') {
      // Simulating API response
      String mockApiResponse = '''
      {
        "orderId": "1234",
        "foodItems": [
          {"name": "Biryani", "code": "12345", "status": "pending", "createdAt": "2023-05-10T12:00:00Z"},
          {"name": "Naan", "code": "67890", "status": "pending", "createdAt": "2023-05-10T12:01:00Z"}
        ],
        "createdAt": "2023-05-10T11:55:00Z"
      }
      ''';

      Map<String, dynamic> orderData = jsonDecode(mockApiResponse);

      Order order = Order(
        orderId: orderData['orderId'],
        foodItems: (orderData['foodItems'] as List).map((item) => FoodItem(
          name: item['name'],
          code: item['code'],
          status: item['status'],
          createdAt: DateTime.parse(item['createdAt']),
        )).toList(),
        createdAt: DateTime.parse(orderData['createdAt']),
      );

      Provider.of<OrderProvider>(context, listen: false).setOrder(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _scanOrder(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner),
          SizedBox(width: 8),
          Text('Scan QR'),
        ],
      ),
    );
  }
}
