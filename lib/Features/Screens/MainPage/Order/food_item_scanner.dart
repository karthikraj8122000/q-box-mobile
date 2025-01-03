import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../Provider/order/order_provider.dart';

class FoodItemScanner extends StatelessWidget {
  Future<void> _scanFoodItem(BuildContext context) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.setScanning(true);

    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeScanRes != '-1') {
      _showAcceptRejectDialog(context, barcodeScanRes);
    } else {
      orderProvider.setScanning(false);
    }
  }

  void _showAcceptRejectDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Food Item Scanned'),
          content: Text('Do you want to accept or reject this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .updateFoodItemStatus(barcode, 'accepted');
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .updateFoodItemStatus(barcode, 'rejected');
                Navigator.of(context).pop();
              },
              child: Text('Reject'),
            ),
          ],
        );
      },
    ).then((_) {
      Provider.of<OrderProvider>(context, listen: false).setScanning(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        if (provider.currentOrder == null) {
          return SizedBox.shrink();
        }
        return ElevatedButton(
          onPressed: () => _scanFoodItem(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner),
              SizedBox(width: 8),
              Text('Scan Food Item'),
            ],
          ),
        );
      },
    );
  }
}