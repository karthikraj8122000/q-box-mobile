import 'package:flutter/material.dart';

import '../../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../../Widgets/Common/app_colors.dart';
import 'food_item_card.dart';
//
// class FoodItemsGrid extends StatelessWidget {
//   final List<InwardFoodModel> items;
//   final Function(InwardFoodModel) onScanPressed;
//
//   const FoodItemsGrid({
//     Key? key,
//     required this.items,
//     required this.onScanPressed,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverPadding(
//           padding: EdgeInsets.all(16),
//           sliver: SliverGrid(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 200.0,
//               mainAxisSpacing: 16.0,
//               crossAxisSpacing: 16.0,
//               childAspectRatio: 0.75,
//             ),
//             delegate: SliverChildBuilderDelegate(
//                   (BuildContext context, int index) {
//                 return FoodItemGridCard(
//                   item: items[index],
//                   onScanPressed: onScanPressed,
//                 );
//               },
//               childCount: items.length,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class FoodItemCard extends StatelessWidget {
  final InwardFoodModel item;
  final Function(InwardFoodModel) onScanPressed;

  const FoodItemCard({
    super.key,
    required this.item,
    required this.onScanPressed,
  });

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

    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.lightBlack))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: \$${item.price.toStringAsFixed(2)}'),
                  Text(
                    'Status: $statusText',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                  if (item.rejectionReason != null)
                    Text('Reason: ${item.rejectionReason}'),
                ],
              ),
              trailing: item.status == 'pending'
                  ? ElevatedButton(
                onPressed: () => onScanPressed(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintGreen,
                ),
                child: Text('Start Scanning'),
              )
                  : null,
            ),
            if (item.rejectionPhoto != null)
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.file(
                  item.rejectionPhoto!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}