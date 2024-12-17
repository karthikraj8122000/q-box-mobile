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
  bool isProcessingScan = false;

  void _handleDispatchQRScan(Barcode barcode) async {
    if (isProcessingScan) return; // Prevent multiple triggers
    setState(() {
      isProcessingScan = true; // Lock processing
    });

    final scannedValue = barcode.rawValue;
    print("Karthik");
    print(scannedValue);
    final provider = Provider.of<FoodRetentionProvider>(context, listen: false);
    final isMatched = provider.storedItems.any((item) => item.containerId == scannedValue);
    if (isMatched) {
      setState(() {
        scannedDispatchItem = scannedValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Container found: $scannedValue'), backgroundColor: Theme.of(context).primaryColor,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Container found!'),backgroundColor:Colors.redAccent),
      );
      setState(() {
        scannedDispatchItem = null;
      });
    }

    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isProcessingScan = false; // Unlock processing
    });
  }


  void _dispatchFoodItem(BuildContext context) {
    if (scannedDispatchItem != null) {
      final provider = Provider.of<FoodRetentionProvider>(context, listen: false);
      var itemToDispatch = provider.storedItems.firstWhere(
              (item) => item.containerId == scannedDispatchItem,
          orElse: () => throw Exception('Item not found')
      );
      provider.dispatchedItems.add(itemToDispatch);
      provider.storedItems.remove(itemToDispatch);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food item dispatched successfully!'),backgroundColor: Theme.of(context).primaryColor)
      );

      setState(() {
        scannedDispatchItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Food Dispatch',style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Scan Food Item to Dispatch',
                        style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 10,),
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
                    SizedBox(height: 10,),
                    Text(scannedDispatchItem ?? 'No item scanned')
                  ],
                ),
              ),
            ),

            ElevatedButton(
              onPressed: scannedDispatchItem != null
                  ? () => _dispatchFoodItem(context)
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor:scannedDispatchItem != null ? Theme.of(context).primaryColor : null,
                  foregroundColor: scannedDispatchItem != null  ? Colors.white:Colors.grey[500]
              ),
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
                      final isHighlighted = item.containerId == scannedDispatchItem;

                      return ListTile(
                        title: Text(item.name, style: TextStyle(
                          color: isHighlighted ? Colors.green : Colors.black,
                          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                        ),),
                        subtitle: Text('Container: ${item.containerId}',style: TextStyle(color: isHighlighted ? Colors.green :Colors.black),),
                        trailing: Text('Stored: ${item.storageDate.toString().substring(0, 16)}',style: TextStyle(color: isHighlighted ? Colors.green :Colors.black),),
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