import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../Model/Data_Models/dashboard_model/dashboard_model.dart';

// class QBoxGrid extends StatelessWidget {
//   final List<dynamic> qboxLists;
//   final double cellHeight;
//   final double fontSize;
//   final int entityInfraSno;
//
//   const QBoxGrid({
//     required this.qboxLists,
//     required this.cellHeight,
//     required this.fontSize,
//     required this.entityInfraSno,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Filter QBoxes based on EntityInfraSno
//     final filteredQboxes = qboxLists.where(
//             (qbox) => qbox['EntityInfraSno'] == entityInfraSno
//     ).toList();
//
//     // Find max row and column numbers
//     int maxRow = 0;
//     int maxColumn = 0;
//     for (var qbox in filteredQboxes) {
//       maxRow = max(maxRow, qbox['rowNo'] as int);
//       maxColumn = max(maxColumn, qbox['columnNo'] as int);
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: maxColumn,
//           childAspectRatio: 1,
//           mainAxisSpacing: 8,
//           crossAxisSpacing: 8,
//         ),
//         itemCount: maxRow * maxColumn,
//         itemBuilder: (context, index) {
//           final row = (index ~/ maxColumn) + 1;
//           final column = (index % maxColumn) + 1;
//
//           // Find QBox at this position
//           final qbox = filteredQboxes.firstWhere(
//                 (qbox) => qbox['rowNo'] == row && qbox['columnNo'] == column,
//             orElse: () => {
//               'rowNo': row,
//               'columnNo': column,
//               'qboxId': null,
//               'foodCode': '',
//               'foodName': 'EMPTY',
//               'logo': null,
//               'EntityInfraSno': entityInfraSno,
//             },
//           );
//
//           return _buildGridCell(QBox.fromMap(qbox), cellHeight, fontSize, index);
//         },
//       ),
//     );
//   }
//
//   Widget _buildGridCell(QBox qbox, double cellHeight, double fontSize, int index) {
//     bool isFilled = qbox.foodCode.isNotEmpty;
//
//     return TweenAnimationBuilder(
//       duration: Duration(milliseconds: 500 + (index * 100)),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, double value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Opacity(
//             opacity: value,
//             child: child,
//           ),
//         );
//       },
//       child: InkWell(
//         onTap: () {
//           if (isFilled) {
//             _showItemDetails(context, qbox);
//           } else {
//             _showEmptyItemDetails(context, qbox);
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: isFilled ? const Color(0xFF2ECC71) : Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isFilled ? const Color(0xFF27AE60) : Colors.grey[300]!,
//               width: 1.5,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: isFilled
//                     ? const Color(0xFF2ECC71).withOpacity(0.3)
//                     : Colors.grey.withOpacity(0.15),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'R${qbox.rowNo}-C${qbox.columnNo}',
//                 style: TextStyle(
//                   color: isFilled ? Colors.white : Colors.black,
//                   fontSize: fontSize,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 '${qbox.qboxId ?? ""}',
//                 style: TextStyle(
//                   color: isFilled ? Colors.white : Colors.black,
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//

