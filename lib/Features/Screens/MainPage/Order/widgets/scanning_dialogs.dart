import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../Model/Data_Models/inward_food_model.dart';
import '../../../../../Widgets/Common/app_colors.dart';


class ScanningDialogs {
  static Future<void> showScanningDialog(
      BuildContext context,
      InwardFoodModel item,
      Function(InwardFoodModel) onScanPressed,
      ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan Food Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Food Item: ${item.name}'),
              Text('Price: \$${item.price.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => onScanPressed(item),
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Start Scanning'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintGreen,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(color: AppColors.black),),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showAcceptRejectDialog(
      BuildContext context,
      InwardFoodModel item,
      String scannedCode,
      Function(InwardFoodModel, String) onAccept,
      Function(InwardFoodModel, String) onReject,
      ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Food Item Scanned'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Food Item: ${item.name}'),
              Text('Price: \$${item.price.toStringAsFixed(2)}'),
              Text('Scanned Code: $scannedCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => onReject(item, scannedCode),
              child: Text('Reject', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => onAccept(item, scannedCode),
              child: Text('Accept', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showRejectionDialog(
      BuildContext context,
      InwardFoodModel item,
      Function(String?, File?) onSubmit,
      ) async {
    final ImagePicker _picker = ImagePicker();
    String? reason;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rejection Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Reason for rejection'),
                onChanged: (value) => reason = value,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintGreen),
                onPressed: () async {
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    onSubmit(reason, File(photo.path));
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Take Photo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(color: AppColors.black),),
            ),
            TextButton(
              onPressed: () {
                if (reason != null && reason!.isNotEmpty) {
                  onSubmit(reason, null);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit',style: TextStyle(color: AppColors.black),),
            ),
          ],
        );
      },
    );
  }
}