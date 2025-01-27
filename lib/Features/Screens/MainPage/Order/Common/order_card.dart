import 'package:flutter/material.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/Common/food_view_screen.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final statusColor =widget.order['orderStatusCd'] == 36? Colors.grey: widget.order['orderStatusCd'] == 37
        ? Color(0xFF4CAF50):widget.order['orderStatusCd'] == 37?Colors.orange :widget.order['orderStatusCd'] == 43?Colors.red:Colors.red;

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
        child:Card(
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
                                        fontSize: isTablet?20:18,
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
                                      fontSize: isTablet?20:14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // _buildStatusBadge(statusColor),
                          ],
                        ),
                        SizedBox(height: 32),
                      if(isTablet)
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
                       )
                        else
                        Column(
                          children: [
                            _buildInfoCard(
                              icon: Icons.delivery_dining,
                              title: 'Delivery Partner',
                              value: widget.order['deliveryPartner1name'],
                              color: Color(0xFF2196F3),
                            ),
                            SizedBox(height: 16),
                            _buildInfoCard(
                              icon: Icons.restaurant_menu,
                              title: 'Restaurant',
                              value: widget.order['restaurant1name'],
                              color: Color(0xFFE91E63),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.store,
                          title: 'QBox Entity',
                          value: widget.order['qboxEntity1name'],
                          color: Color(0xFF9C27B0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Color statusColor) {
    print("status:${widget.order['orderStatusCd']}");
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

  String _getOrderStatus(int statusCd) {
    switch (statusCd) {
      case 36:
        return 'In Process';
      case 37:
        return 'Completed';
      case 38:
        return 'Conflicted Order';
      case 43:
        return 'Partially Rejected';
      default:
        return 'Unknown';
    }
  }
}

