import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/order/scan_provider.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        if (scanProvider.scanResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No orders found',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: scanProvider.scanResults.length,
          itemBuilder: (context, index) {
            final result = scanProvider.scanResults[index];
            final status = scanProvider.getStatusDescription(result.status);
            final statusColor = result.status == 9
                ? Colors.green
                : result.status == 8
                    ? Colors.red
                    : Colors.grey;

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
                    _buildDetailRow('Order ID', '12'),
                    _buildDetailRow('Sku code', result.code),
                    _buildDetailRow('Status', status, isStatus: true, statusColor: statusColor),
                    // _buildDetailRow('Date', DateTime.timestamp() as String),
                    // _buildDetailRow('Items','1'),
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false, bool isBold = false, TextStyle? textStyle,Color? statusColor}) {
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
                color:statusColor ?? Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
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

