import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/qr_scanner_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/scan_history_screen.dart';
import '../../../../Provider/order/order_qr_scanning_provider.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';

class InwardOrder extends StatefulWidget {
  static const String routeName = '/scanning';
  const InwardOrder({Key? key}) : super(key: key);

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
      TabItem(title: 'Orders', icon: Icons.shopping_cart_rounded),
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
    return ChangeNotifierProvider(
      create: (_) => OrderScanningProvider(),
      child: Consumer<OrderScanningProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Inward Order', style: TextStyle(color: Colors.black)),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      OrderQRScannerScreen(),
                      ScanHistoryScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ModernTabBar(
        controller: _tabController,
        tabItems: _tabItems,
        onTap: (index) {
          print('Tapped on tab $index');
        },
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

