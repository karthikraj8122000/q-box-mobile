import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/order_qr_scanning_provider.dart';

class Scanning extends StatefulWidget {
  static const String routeName = '/scanning';
  const Scanning({super.key});

  @override
  State<Scanning> createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _orderIdController;
  late AnimationController _animationController;
  late Animation<Offset> _lineAnimation;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _orderIdController = TextEditingController();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _lineAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _widthAnimation = Tween<double>(begin: 2.0, end: 100.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _orderIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderScanningProvider(),
      child: Consumer<OrderScanningProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Customer Order",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor:Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Card(
                  elevation: 5,  // Add shadow effect to create card view
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),  // Rounded corners for the card
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Scan QR Code'),
                      Tab(text: 'Manual Entry'),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 3,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScannerTab(provider),
                    _buildManualEntryTab(provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerTab(OrderScanningProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Position the QR code within the frame',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: provider.scanQR,
                    child: Container(
                     width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.orange.withOpacity(0.3), width: 2),
                          right: BorderSide(color: Colors.orange.withOpacity(0.3), width: 2),
                          bottom: BorderSide(color: Colors.orange.withOpacity(0.3), width: 2),
                          left: BorderSide(color: Colors.orange.withOpacity(0.3), width: 2),
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0)
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_2,
                                size: 150,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Positioned(
                                    // bottom: _lineAnimation.value.dy * 10,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: _widthAnimation.value,
                                      height: 2,
                                      color: Colors.orange.withOpacity(0.0),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Text('Tap to scan order QR',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildOrderDetails(provider),
        ],
      ),
    );
  }

  Widget _buildManualEntryTab(OrderScanningProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Manual Entry',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter the order ID manually',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: _orderIdController,
                    onChanged: provider.onChangeValidate,
                    decoration: InputDecoration(
                      hintText: 'Enter Order ID',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: provider.isDisable
                        ? null
                        : () => provider.get(_orderIdController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Search Order'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildOrderDetails(provider),
        ],
      ),
    );
  }


  Widget _buildOrderDetails(OrderScanningProvider provider) {
    if (provider.orderItems == null) return SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Order ID', provider.orderDetails!['partnerPurchaseOrderId']),
            _buildDetailRow('Status', 'Processing', isStatus: true),
            _buildDetailRow('Date', provider.orderDetails!['deliveredTime']),
            _buildDetailRow('Items', provider.orderItems!.length.toString()),
            Divider(height: 32),
            _buildDetailRow(
              'Total Amount',
              '\$245.00',
              isBold: true,
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {

              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('View Full Details'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false, bool isBold = false, TextStyle? textStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isBold ? 16 : 14,
            ),
          ),
          if (isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                ),
              ),
            )
          else
            Text(
              value,
              style: textStyle ?? TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
