import 'package:flutter/material.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../../Model/Data_Models/inward_food_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final Order order;

  const OrderSummaryCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Order ID: ${order.orderId}'),
                  Text('Total Items: ${order.totalItems}'),
                  SizedBox(height: 16),
                  ...order.items.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name),
                        Text(
                          item.status.toUpperCase(),
                          style: TextStyle(
                            color: item.status == 'accepted' ? Colors.green :
                            item.status == 'rejected' ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
      
                ],
              ),
            ),
          ),
        OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.qr_code_scanner),
            label: Text('Scan New Order'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
