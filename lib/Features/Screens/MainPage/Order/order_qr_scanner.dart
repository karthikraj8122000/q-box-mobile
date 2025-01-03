import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/qr_scanner_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/scan_history_screen.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import '../../../../Provider/order/order_qr_scanning_provider.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';

class InwardOrder extends StatefulWidget {
  final VoidCallback onSendItemPressed;
  static const String routeName = '/scanning';
  const InwardOrder({super.key, required this.onSendItemPressed});

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
          ),
        ),
      ),
    );
  }
}

