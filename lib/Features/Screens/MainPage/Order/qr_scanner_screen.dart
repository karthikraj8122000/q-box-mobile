import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import 'package:qr_page/Widgets/Common/divider_text.dart';
import '../../../../Provider/order/scan_provider.dart';

class OrderQRScannerScreen extends StatelessWidget {
  const OrderQRScannerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 200,
                    color: AppColors.lightBlack,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Scan for order',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Scan a QR code or manually enter a code to order food',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text('Scan QR Code'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.lightBlack,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: () => _scanQR(context),
                  ),
                  SizedBox(height: 16),

                ],
              ),
            ),
            CustomDivider(text: "OR"),
            SizedBox(
              // width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.keyboard),
                  label: Text('Enter Code Manually'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlack,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () => _showManualEntryDialog(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> _scanQR(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan QR code')),
      );
      return;
    }

    if (barcodeScanRes == '-1') {
      return;
    }
    _processQRCode(context, barcodeScanRes);
  }

  void _showManualEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String enteredCode = '';
        return AlertDialog(
          title: Text('Enter Code'),
          content: TextField(
            onChanged: (value) {
              enteredCode = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter the food order code',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color: AppColors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBgColor
              ),
              child: Text('Submit'),
              onPressed: () {
                if (enteredCode.isNotEmpty) {
                  Navigator.of(context).pop();
                  _processCode(context, enteredCode);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _processCode(BuildContext context, String code) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    scanProvider.addScanResult(code);
    _showResultDialog(context, code);
  }

  void _processQRCode(BuildContext context, String qrCode) {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    scanProvider.addScanResult(qrCode);
    _showResultDialog(context, qrCode);
  }

  void _showResultDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Successfully'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scanned Code:'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  code,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Provider.of<ScanProvider>(context, listen: false)
                    .updateScanStatus(code, 8);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order item rejected')),
                );
              },
              child: Text('Reject'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBgColor
              ),
              child: Text('Accept'),
              onPressed: () {
                Provider.of<ScanProvider>(context, listen: false)
                    .updateScanStatus(code, 9);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order item accepted')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

