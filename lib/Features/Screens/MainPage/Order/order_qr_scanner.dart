import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/qr_scanner_screen.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import '../../../../Provider/order/order_qr_scanning_provider.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';

class InwardOrder extends StatefulWidget {

  static const String routeName = '/scanning';
  const InwardOrder({super.key});

  @override
  State<InwardOrder> createState() => _InwardOrderState();
}

class _InwardOrderState extends State<InwardOrder> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<TabItem> _tabItems;

  @override
  void initState() {
    super.initState();
    _tabItems = [
      TabItem(title: 'Scan QR', icon: Icons.qr_code_scanner_rounded),
      TabItem(title: 'SKU Details', icon: Icons.edit),
    ];
    _tabController = TabController(length: _tabItems.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkWrapper(
      child: ChangeNotifierProvider(
        create: (_) => OrderScanningProvider(),
        child: Consumer<OrderScanningProvider>(
          builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Text('Inward Order Receiving', style: TextStyle(color: Colors.black)),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child:OrderQRScannerScreen(),
              ),
            ),
            // floatingActionButton: Tooltip(
            //   message: 'Scan New Order',
            //   child: SizedBox(
            //     width: 70, // Adjust width for larger size
            //     height: 70, // Adjust height for larger size
            //     child: Container(
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           begin: Alignment.topLeft,
            //           end: Alignment.bottomRight,
            //           colors: [
            //             AppColors.mintGreen,
            //             AppColors.mintGreen.withGreen(180),
            //           ],
            //         ),
            //         shape: BoxShape.rectangle,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.25), // Increase opacity for more visible shadow
            //             spreadRadius: 5, // Increased spread for a larger shadow area
            //             blurRadius: 20,  // Higher blur for a softer but prominent shadow
            //             offset: Offset(4, 4), // Adjusted for balanced shadow position
            //           ),
            //         ],
            //         borderRadius: BorderRadius.circular(12), // Rounded corners
            //       ),
            //       child: FloatingActionButton(
            //         elevation: 0,
            //         onPressed: () {
            //           setState(() {
            //             _scannerKey.currentState?.resetScan();
            //           });
            //         },
            //         backgroundColor: Colors.transparent, // Allow gradient to be visible
            //         child: Icon(Icons.qr_code, size: 40, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }
}
