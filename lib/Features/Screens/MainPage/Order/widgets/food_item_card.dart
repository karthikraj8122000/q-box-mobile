import 'package:flutter/material.dart';

import '../../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../../Widgets/Common/app_colors.dart';

class FoodItemGridCard extends StatelessWidget {
  final InwardFoodModel item;
  final Function(InwardFoodModel) onScanPressed;

  const FoodItemGridCard({
    Key? key,
    required this.item,
    required this.onScanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (item.status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = 'Accepted';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Pending';
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.rejectionPhoto != null)
            Container(
              height: 120,
              width: double.infinity,
              child: Image.file(
                item.rejectionPhoto!,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(
                Icons.fastfood,
                size: 50,
                color: Colors.grey[400],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (item.rejectionReason != null) ...[
                    SizedBox(height: 4),
                    Text(
                      'Reason: ${item.rejectionReason}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  Spacer(),
                  if (item.status == 'pending')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => onScanPressed(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mintGreen,
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text('Start Scanning'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}