import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_page/Theme/app_theme.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import '../../../../Model/Data_Models/Food_item/foot_item_model.dart';
import '../../../../Provider/food_retention_provider.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';

class FoodStorageScreen extends StatefulWidget {
  const FoodStorageScreen({super.key});

  @override
  _FoodStorageScreenState createState() => _FoodStorageScreenState();
}

class _FoodStorageScreenState extends State<FoodStorageScreen> {
  String? qboxId;
  String? foodItem;
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();

  Future<void> _scanContainer() async {
    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: true),
    );

    if (result != null) {
      setState(() {
        qboxId = result;
        foodItem = null;
      });
    }
  }

  Future<void> _scanFoodItem() async {
    if (qboxId == null || qboxId!.isEmpty) {
      commonService.presentToast('Please scan QBox ID first',backgroundColor: Colors.red);
      return;
    }

    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: false),
    );

    if (result != null) {
      setState(() {
        foodItem = result;
      });
    }
  }

  Future<dynamic> _storeFoodItem() async {
    if (qboxId != null &&
        qboxId!.isNotEmpty &&
        foodItem != null &&
        foodItem!.isNotEmpty) {
      final newFoodItem = FoodItem(
        boxCellSno: qboxId!,
        uniqueCode: foodItem!,
        wfStageCd: 11,
        qboxEntitySno: 3,
        storageDate: DateTime.now(),
      );
      Map<String, dynamic> body = newFoodItem.toMap();
      try {
        print("Request Body: $body");
        var result =
        await apiService.post("8912", "masters", "load_sku_in_qbox", body);
        if (result != null && result['data'] != null) {
          Provider.of<FoodRetentionProvider>(context, listen: false)
              .addStoredItem(newFoodItem);
          setState(() {
            qboxId = null;
            foodItem = null;
          });

          commonService.presentToast('Food item stored successfully!');
        } else {
          commonService
              .presentToast('Failed to store the food item. Please try again.');
        }
      } catch (e) {
        print('Error: $e');
        commonService
            .presentToast('An error occurred while storing the food item.');
      }
    } else {
      commonService.presentToast('Please provide valid QBox ID and Food Item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Storage'),
        backgroundColor: AppTheme.appTheme,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScanButton('Scan QBox ID', qboxId, () => _scanContainer()).animate()
            .fadeIn(duration: 1000.ms)
            .slide(begin: Offset(1, 0), end: Offset.zero),
            SizedBox(height: 16),
            // Disable food item scan if QBox ID is not scanned
            _buildScanButton(
                'Scan Food Item ID',
                foodItem,
               () => _scanFoodItem()
            ).animate()
                .fadeIn(duration: 1000.ms)
                .slide(begin: Offset(-1, 0), end: Offset.zero),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: (qboxId != null && foodItem != null)
                  ? () => _storeFoodItem()
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.appTheme,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                  foregroundColor: Colors.white),
              child: AppText(
                text: 'Store Food Item',
                fontSize: 14,
              ),
            ),
           SizedBox(height: 10,),
            Expanded(
              child: Consumer<FoodRetentionProvider>(
                builder: (context, provider, child) {
                  return provider.storedItems.isNotEmpty
                      ? ListView.builder(
                    itemCount: provider.storedItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.storedItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading:CircleAvatar(
                            backgroundColor: AppTheme.appTheme.withOpacity(0.2),
                            child: Icon(
                              Icons.fastfood,
                              color: AppTheme.appTheme,
                            ),
                          ),
                          title: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              item.uniqueCode,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Container: ${item.boxCellSno}'),
                              Text(
                                'Stored: ${item.storageDate.toString().substring(0, 16)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 48, color: AppTheme.appThemeLight),
                        SizedBox(height: 16),
                        Text(
                          'No food items found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Scan QBox ID and Food Item to store',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .shimmer(duration: 1500.ms)
                        .then(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton(String label, String? item, VoidCallback? onPressed) {
    return InkWell(
      onTap: () {
        if (onPressed == null) {
          if (label.contains('Scan Food Item ID')) {
            _scanFoodItem(); // This will show the toast
          }
        } else {
          onPressed();
        }
      },
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.grey.shade300 : AppTheme.boxBorder,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: onPressed == null
                ? Colors.grey
                : AppTheme.appThemeLight,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.qr_code_scanner,
                size: 64,
                color: onPressed == null
                    ? Colors.grey
                    : AppTheme.appThemeLight
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .shimmer(duration: 1500.ms)
                .then(),
            SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: onPressed == null
                    ? Colors.grey
                    : AppTheme.appThemeLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppText(
              text: item ?? '',
              fontSize: 14,
              color: Colors.black,
            ),
          ],
        ),
      )
    );
  }
}

class QRScannerDialog extends StatefulWidget {
  final bool isContainerScanner;

  const QRScannerDialog({Key? key, required this.isContainerScanner})
      : super(key: key);

  @override
  _QRScannerDialogState createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Add a flash toggle state
  bool _flashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Full screen QR view
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          // Scan Result Overlay
          if (result != null)
            Positioned(
              bottom: 100,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Scanned: ${result!.code}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Control Buttons
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Flash Toggle Button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white),
              onPressed: () {
                controller?.toggleFlash();
                setState(() {
                  _flashOn = !_flashOn;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.check),
        onPressed: result != null
            ? () => Navigator.of(context).pop(result!.code)
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
