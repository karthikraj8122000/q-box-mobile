import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Model/Data_Models/inward_food_model.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../Provider/order/scan_provider.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, orderProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Scanned Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                if (orderProvider.orders.isEmpty)
                  Center(child: Text('No orders scanned yet.'))
                else
                  ...orderProvider.orders.map((order) => _buildOrderCard(context, order)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Status')),
                  if (order.items.any((item) => item.rejectionReason != null))
                    DataColumn(label: Text('Reason')),
                ],
                rows: order.items.map((item) => DataRow(
                  cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                    DataCell(Text(item.status.toUpperCase())),
                    if (order.items.any((item) => item.rejectionReason != null))
                      DataCell(Text(item.rejectionReason ?? '-')),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showOrderDetails(context, order),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Text('Order ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(order.orderId),
                  Text(order.status),
                ],
              ),
              TableRow(
                children: [
                  Text('Total Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(order.totalItems.toString()),
                  Text(''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




//
  // Widget _buildFoodItemCard(InwardFoodModel item) {
  //   return Card(
  //     margin: EdgeInsets.only(bottom: 8),
  //     child: ListTile(
  //       title: Text(item.name),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Price: \$${item.price.toStringAsFixed(2)}'),
  //           if (item.rejectionReason != null)
  //             Text(
  //               'Rejection Reason: ${item.rejectionReason}',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //         ],
  //       ),
  //       trailing: Container(
  //         padding: EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: item.status == 'accepted' ? Colors.green : Colors.red,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Text(
  //           item.status.toUpperCase(),
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}