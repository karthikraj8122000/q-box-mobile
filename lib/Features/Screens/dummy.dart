// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import '../../../../Provider/food_retention_provider.dart';
// import '../../../../Services/api_service.dart';
// import '../../../../Services/toast_service.dart';
//
// class QRScannerDialog extends StatefulWidget {
//   final bool isContainerScanner;
//
//   const QRScannerDialog({Key? key, required this.isContainerScanner}) : super(key: key);
//
//   @override
//   _QRScannerDialogState createState() => _QRScannerDialogState();
// }
//
// class _QRScannerDialogState extends State<QRScannerDialog> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   // Add a flash toggle state
//   bool _flashOn = false;
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Full screen QR view
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//             overlay: QrScannerOverlayShape(
//               borderColor: Theme.of(context).primaryColor,
//               borderRadius: 10,
//               borderLength: 30,
//               borderWidth: 10,
//               cutOutSize: MediaQuery.of(context).size.width * 0.8,
//             ),
//           ),
//
//           // Scan Result Overlay
//           if (result != null)
//             Positioned(
//               bottom: 20,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.8),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   'Scanned: ${result!.code}',
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//
//           // Control Buttons
//           Positioned(
//             top: 40,
//             left: 20,
//             child: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//
//           // Flash Toggle Button
//           Positioned(
//             top: 40,
//             right: 20,
//             child: IconButton(
//               icon: Icon(
//                   _flashOn ? Icons.flash_on : Icons.flash_off,
//                   color: Colors.white
//               ),
//               onPressed: () {
//                 controller?.toggleFlash();
//                 setState(() {
//                   _flashOn = !_flashOn;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         child: Icon(Icons.check),
//         onPressed: result != null
//             ? () => Navigator.of(context).pop(result!.code)
//             : null,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
//
// class StorageScreen extends StatefulWidget {
//   @override
//   _StorageScreenState createState() => _StorageScreenState();
// }
//
// class _StorageScreenState extends State<StorageScreen> {
//   // Text Controllers
//   final TextEditingController _containerController = TextEditingController();
//   final TextEditingController _foodItemController = TextEditingController();
//   final ApiService apiService = ApiService();
//   final CommonService commonService = CommonService();
//
//   // Scan Methods
//   Future<void> _scanContainer() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => QRScannerDialog(isContainerScanner: true),
//     );
//
//     if (result != null) {
//       setState(() {
//         _containerController.text = result;
//       });
//     }
//   }
//
//   Future<void> _scanFoodItem() async {
//     final result = await showDialog(
//       context: context,
//       builder: (context) => QRScannerDialog(isContainerScanner: false),
//     );
//
//     if (result != null) {
//       setState(() {
//         _foodItemController.text = result;
//       });
//     }
//   }
//
//   Future<void> _storeFoodItem() async {
//     if (_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty) {
//       Map<String, dynamic> body = {
//         "uniqueCode": _foodItemController.text,
//         "wfStageCd": 11,
//         "boxCellSno": _containerController.text,
//         "qboxEntitySno": 3
//       };
//
//       try {
//         var result = await apiService.post("8912", "masters", "load_sku_in_qbox", body);
//         print("result");
//         print(result);
//         if (result != null && result['data'] != null) {
//           _containerController.clear();
//           _foodItemController.clear();
//           commonService.presentToast('Food item stored successfully!');
//         }
//       } catch (e) {
//         print('Error: $e');
//         commonService.presentToast('Failed to store food item. Please try again.');
//       }
//     } else {
//       commonService.presentToast('Please fill in all fields.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Food Storage',style: TextStyle(color: Colors.white)),
//         backgroundColor: Theme.of(context).primaryColor,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // QBox ID Input with QR Scan
//             TextField(
//               controller: _containerController,
//               decoration: InputDecoration(
//                 labelText: 'QBox ID',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.qr_code_scanner),
//                   onPressed: _scanContainer,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Food Item Input with QR Scan
//             TextField(
//               controller: _foodItemController,
//               decoration: InputDecoration(
//                 labelText: 'Food Item',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.qr_code_scanner),
//                   onPressed: _scanFoodItem,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Store Button
//             ElevatedButton(
//               onPressed: _containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty ? () => _storeFoodItem():null,
//               style: ElevatedButton.styleFrom(
//                   backgroundColor:_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty? Theme.of(context).primaryColor : null,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   foregroundColor:_containerController.text.isNotEmpty && _foodItemController.text.isNotEmpty? Colors.white:Colors.grey[500]
//               ),
//               child: Text('Store Food Item'),
//             ),
//
//             // Stored Items List
//             Expanded(
//               child: Consumer<FoodRetentionProvider>(
//                 builder: (context, provider, child) {
//                   return provider.storedItems.length > 0 || provider.storedItems.isNotEmpty ? ListView.builder(
//                     itemCount: provider.storedItems.length,
//                     itemBuilder: (context, index) {
//                       final item = provider.storedItems[index];
//                       return ListTile(
//                         title: Text(item.name),
//                         subtitle: Text('Container: ${item.containerId}'),
//                         trailing: Text(
//                           'Stored: ${item.storageDate.toString().substring(0, 16)}',
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       );
//                     },
//                   ):Center(child: Text("No food items found",style: TextStyle(color: Colors.grey),));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }