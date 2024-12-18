import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Theme/app_theme.dart';

import '../../../../Model/Data_Models/Food_item/qbox_sku_inventory_item.dart';
import '../../../../Provider/food_retention_provider.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  _DispatchScreenState createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  final dispatchController = MobileScannerController();
  String? scannedDispatchItem;
  bool isProcessingScan = false;
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();

  void _handleDispatchQRScan(Barcode barcode) async {
    if (isProcessingScan) return; // Prevent multiple triggers
    setState(() {
      isProcessingScan = true; // Lock processing
    });

    final scannedValue = barcode.rawValue;
    print("Karthik");
    print(scannedValue);
    final provider = Provider.of<FoodRetentionProvider>(context, listen: false);
    final isMatched =
        provider.storedItems.any((item) => item.uniqueCode == scannedValue);
    if (isMatched) {
      setState(() {
        scannedDispatchItem = scannedValue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Container found: $scannedValue'),
          backgroundColor: AppTheme.appTheme,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No Container found!'),
            backgroundColor: Colors.redAccent),
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

  void _dispatchFoodItem(BuildContext context) async {
    if (scannedDispatchItem != null) {
      final provider =
          Provider.of<FoodRetentionProvider>(context, listen: false);

      try {
        var itemToDispatch = provider.storedItems.firstWhere(
          (item) => item.uniqueCode == scannedDispatchItem,
          orElse: () => throw Exception('Item not found'),
        );

        // Prepare API body using the `FoodItem` data
        Map<String, dynamic> body = {
          "uniqueCode": itemToDispatch.uniqueCode,
          "wfStageCd": 12,
          "qboxEntitySno": 2,
        };

        // Call the API endpoint to unload the item
        var result = await apiService.post(
            "8912", "masters", "unload_sku_from_qbox_to_hotbox", body);

        if (result != null && result['data'] != null) {
          provider.dispatchedItems.add(itemToDispatch);
          provider.storedItems.remove(itemToDispatch);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Food item dispatched successfully!'),
              backgroundColor: AppTheme.appTheme,
            ),
          );
          // Clear the scannedDispatchItem after successful API call
          setState(() {
            scannedDispatchItem = null;
          });
        } else {
          commonService.presentToast(
              'Failed to dispatch the food item. Please try again.');
        }
      } catch (e) {
        print('Error: $e');
        commonService
            .presentToast('An error occurred while dispatching the food item.');
      }
    } else {
      // Show validation message if scannedDispatchItem is null
      commonService.presentToast('No scanned food item to dispatch.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Dispatch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.appTheme,
        iconTheme: IconThemeData(color: Colors.white),
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Scan Food Item to Dispatch',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    SizedBox(
                      height: 10,
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
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      scannedDispatchItem != null ? AppTheme.appTheme : null,
                  foregroundColor: scannedDispatchItem != null
                      ? Colors.white
                      : Colors.grey[500]),
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
                      final isHighlighted = item.uniqueCode == scannedDispatchItem;
                      return Card(
                        color: isHighlighted ? AppTheme.selectedCardTheme:null,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                            AppTheme.appTheme.withOpacity(0.2),
                            child: Icon(isHighlighted ? Icons.check:
                              Icons.fastfood,
                              color:isHighlighted? Colors.green:AppTheme.appTheme,
                            ),
                          ),
                          title: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              item.uniqueCode,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
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
//
// ListTile(
// title: Text(item.uniqueCode, style: TextStyle(
// color: isHighlighted ? Colors.green : Colors.black,
// fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
// ),),
// subtitle: Text('Container: ${item.boxCellSno}',style: TextStyle(color: isHighlighted ? Colors.green :Colors.black),),
// trailing: Text('Stored: ${item.storageDate.toString().substring(0, 16)}',style: TextStyle(color: isHighlighted ? Colors.green :Colors.black),),
// );
