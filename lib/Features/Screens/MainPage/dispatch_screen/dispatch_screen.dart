import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/food_retention_provider.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  _DispatchScreenState createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  final dispatchController = MobileScannerController();
  String? scannedDispatchItem;

  void _handleDispatchQRScan(Barcode barcode) {
    setState(() {
      scannedDispatchItem = barcode.rawValue;
    });
  }

  void _dispatchFoodItem(BuildContext context) {
    if (scannedDispatchItem != null) {
      final provider = Provider.of<FoodRetentionProvider>(context, listen: false);

      // Find the item to dispatch
      var itemToDispatch = provider.storedItems.firstWhere(
              (item) => item.name == scannedDispatchItem,
          orElse: () => throw Exception('Item not found')
      );

      provider.dispatchedItems.add(itemToDispatch);
      provider.storedItems.remove(itemToDispatch);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food item dispatched successfully!'))
      );

      // Reset scan state
      setState(() {
        scannedDispatchItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Dispatch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Scan Food Item to Dispatch',
                        style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(
                      height: 200,
                      child: MobileScanner(
                        controller: dispatchController,
                        onDetect: (capture) {
                          final barcode = capture.barcodes.first;
                          _handleDispatchQRScan(barcode);
                        },
                      ),
                    ),
                    Text(scannedDispatchItem ?? 'No item scanned')
                  ],
                ),
              ),
            ),

            ElevatedButton(
              onPressed: scannedDispatchItem != null
                  ? () => _dispatchFoodItem(context)
                  : null,
              child: Text('Dispatch Food Item'),
            ),

            // Optional: List of currently stored items
            Consumer<FoodRetentionProvider>(
              builder: (context, provider, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.storedItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.storedItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Container: ${item.containerId}'),
                        trailing: Text('Stored: ${item.storageDate}'),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}