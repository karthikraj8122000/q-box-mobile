import 'package:flutter/material.dart';
import 'package:qr_page/Provider/order/food_view_screen.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final statusColor = widget.order['orderStatusCd'] == 2
        ? Color(0xFF4CAF50)
        : Color(0xFFFFA726);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodViewScreen(
                purchaseOrderSno: widget.order['purchaseOrderSno'], // Your purchase order number
              ),
            ),
          );
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Decorative Header
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen
                      // gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     AppColors.mintGreen,
                      //     AppColors.mintGreen.withGreen(180),
                      //   ],
                      // ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order Details',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Track your delivery status',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Order Content
                  Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID and Status Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ID',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '#${widget.order['partnerPurchaseOrderId']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusBadge(statusColor),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Info Cards Section


                       Row(
                         children: [
                           Expanded(child: _buildInfoCard(
                             icon: Icons.delivery_dining,
                             title: 'Delivery Partner',
                             value: widget.order['deliveryPartner1name'],
                             color: Color(0xFF2196F3),
                           ),),
                           Expanded(child: SizedBox(width: 100,)),

                           Expanded(child:_buildInfoCard(
                             icon: Icons.restaurant_menu,
                             title: 'Restaurant',
                             value: widget.order['restaurant1name'],
                             color: Color(0xFFE91E63),
                           ), )
                         ],
                       ),
                        SizedBox(height: 16),

                        _buildInfoCard(
                          icon: Icons.store,
                          title: 'QBox Entity',
                          value: widget.order['qboxEntity1name'],
                          color: Color(0xFF9C27B0),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            // Expanded(
                            //   child: _buildActionButton(
                            //     icon: Icons.refresh,
                            //     label: 'Try Again',
                            //     onPressed: () {
                            //       Provider.of<ScanProvider>(context, listen: false)
                            //           .resetOrder();
                            //     },
                            //     isPrimary: false,
                            //   ),
                            // ),
                            // SizedBox(width: 16),
                            // Expanded(
                            //   child: _buildActionButton(
                            //     icon: Icons.save,
                            //     label: 'Save Order',
                            //     onPressed: () {
                            //       setState(() {
                            //         _showSummary = true;
                            //       });
                            //     },
                            //     isPrimary: true,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Order Summary
                  if (_showSummary)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: OrderSummaryCard(order: widget.order),
                    ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Color statusColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Text(
            _getOrderStatus(widget.order['orderStatusCd']),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary ? AppColors.mintGreen : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isPrimary
                ? null
                : Border.all(color: AppColors.mintGreen, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : AppColors.mintGreen,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : AppColors.mintGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getOrderStatus(int statusCd) {
    switch (statusCd) {
      case 1:
        return 'Pending';
      case 2:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}

// Previous OrderCard implementation remains the same until the OrderSummaryCard...

class OrderSummaryCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderSummaryCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.summarize,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),

          // Summary Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryItem(
                  title: 'Delivery Time',
                  value: '30-45 mins',
                  icon: Icons.access_time,
                ),
                SizedBox(height: 12),
                _buildSummaryItem(
                  title: 'Order Type',
                  value: 'Delivery',
                  icon: Icons.local_shipping,
                ),
                SizedBox(height: 12),
                _buildSummaryItem(
                  title: 'Payment Method',
                  value: 'Online Payment',
                  icon: Icons.payment,
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),
                _buildPriceRow('Subtotal', '₹${_calculateSubtotal()}'),
                SizedBox(height: 8),
                _buildPriceRow('Delivery Fee', '₹40.00'),
                SizedBox(height: 8),
                _buildPriceRow('Taxes', '₹${_calculateTax()}'),
                SizedBox(height: 16),
                Divider(thickness: 2),
                SizedBox(height: 16),
                _buildPriceRow(
                  'Total',
                  '₹${_calculateTotal()}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.mintGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.mintGreen,
            size: 16,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.grey.shade900 : Colors.grey.shade600,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.mintGreen : Colors.grey.shade900,
          ),
        ),
      ],
    );
  }

  String _calculateSubtotal() {
    // Mock calculation - replace with actual logic
    return '450.00';
  }

  String _calculateTax() {
    // Mock calculation - replace with actual logic
    return '45.00';
  }

  String _calculateTotal() {
    // Mock calculation - replace with actual logic
    return '535.00';
  }
}