import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../Model/Food_item/qbox_sku_inventory_item.dart';
import '../../../../Provider/food_retention_provider.dart';

class QRScannerDialog extends StatefulWidget {
  final bool isContainerScanner;

  const QRScannerDialog({Key? key, required this.isContainerScanner}) : super(key: key);

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
              bottom: 20,
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
              icon: Icon(
                  _flashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white
              ),
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

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  // Text Controllers
  final TextEditingController _containerController = TextEditingController();
  final TextEditingController _foodItemController = TextEditingController();

  // Scan Methods
  Future<void> _scanContainer() async {
    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: true),
    );

    if (result != null) {
      setState(() {
        _containerController.text = result;
      });
    }
  }

  Future<void> _scanFoodItem() async {
    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: false),
    );

    if (result != null) {
      setState(() {
        _foodItemController.text = result;
      });
    }
  }

  // Store Food Item Method
  void _storeFoodItem() {
    if (_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty) {
      final provider = Provider.of<FoodRetentionProvider>(context, listen: false);
      provider.addStoredItem(FoodItem(
          name: _foodItemController.text,
          containerId: _containerController.text,
          storageDate: DateTime.now()
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Food item stored successfully!'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      _containerController.clear();
      _foodItemController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Storage',style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container ID Input with QR Scan
            TextField(
              controller: _containerController,
              decoration: InputDecoration(
                labelText: 'Container ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: _scanContainer,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Food Item Input with QR Scan
            TextField(
              controller: _foodItemController,
              decoration: InputDecoration(
                labelText: 'Food Item',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: _scanFoodItem,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Store Button
            ElevatedButton(
              onPressed: _containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty ? () => _storeFoodItem():null,
              style: ElevatedButton.styleFrom(
                backgroundColor:_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty? Theme.of(context).primaryColor : null,
                padding: EdgeInsets.symmetric(vertical: 15),
                foregroundColor:_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty? Colors.white:Colors.grey[500]
              ),
              child: Text('Store Food Item'),
            ),

            // Stored Items List
            Expanded(
              child: Consumer<FoodRetentionProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.storedItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.storedItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Container: ${item.containerId}'),
                        trailing: Text(
                          'Stored: ${item.storageDate.toString().substring(0, 16)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}