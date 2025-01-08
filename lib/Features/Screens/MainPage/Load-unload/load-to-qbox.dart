import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/load_history.dart';

import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';
import '../../../../Widgets/Common/app_colors.dart';

class LoadQbox extends StatefulWidget {
  const LoadQbox({super.key});

  @override
  State<LoadQbox> createState() => _LoadQboxState();
}

class _LoadQboxState extends State<LoadQbox> {
  String qBoxBarcode = '';
  String foodBarcode = '';
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  bool get isReadyToLoad => qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty;

  Future<void> scanBarcode(String name) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#E11D48', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        setState(() {
          if (name == 'Compartment') {
            qBoxBarcode = barcodeScanRes;
          } else if (name == 'Food Item') {
            foodBarcode = barcodeScanRes;
          }
        });
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  loadToQBox() async {
    try {
      print('loadToQBox');
      Map<String, dynamic> body = {
        "uniqueCode": foodBarcode,
        "wfStageCd": 11,
        "boxCellSno": qBoxBarcode,
        "qboxEntitySno": 20
      };

      print('$body');
      var result = await apiService.post("8912", "masters", "load_sku_in_qbox", body);
      if (result != null && result['data'] != null) {
        print('RESULT$result');
        String loadingMessage = result['data']['skuloading'];

        if (loadingMessage == 'inside qbox') {
          qBoxBarcode = '';
          foodBarcode = '';
          commonService.presentToast('Food Loaded inside the qbox');
        } else if (loadingMessage == 'this box is already Loaded') {
          commonService.errorToast('This box is already loaded');
        } else if (loadingMessage == 'Invalid Loaded') {
          commonService.errorToast('Invalid loading attempt');
        } else {
          // Handle any other unexpected messages
          commonService.presentToast('Unexpected response: $loadingMessage');
        }
      } else {
        commonService.presentToast('No data received from server');
      }
    } catch (e) {
      print('Error: $e');
      commonService.presentToast('An error occurred: ${e.toString()}');
    }
    setState(() {
    });
  }
  //
  // loadToQBox() async {
  //
  //   try {
  //     print('loadToQBox');
  //     Map<String, dynamic> body = {
  //       "uniqueCode": foodBarcode,
  //       "wfStageCd":11,
  //       "boxCellSno":qBoxBarcode,
  //       "qboxEntitySno": 20
  //     };
  //
  //     print('$body');
  //     var result = await apiService.post("8912", "masters","load_sku_in_qbox", body);
  //     if (result != null && result['data'] != null) {
  //       print('RESULT$result');
  //       qBoxBarcode = '';
  //       foodBarcode = '';
  //       commonService.presentToast('Food Loaded inside the qbox');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  //   setState(() {
  //
  //   });
  // }
  // Future<void> loadToQBox() async {
  //   debugPrint("storeFoodItem called");
  //   if(qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty){
  //     Map<String, dynamic> body = {
  //       "uniqueCode": foodBarcode,
  //       "wfStageCd": 11,
  //       "boxCellSno": qBoxBarcode,
  //       "qboxEntitySno": 20
  //     };
  //     try {
  //       var result = await apiService.post("8912", "masters", "load_sku_in_qbox", body);
  //       if (result != null && result['data'] != null) {
  //         qBoxBarcode = '';
  //         foodBarcode = '';
  //         commonService.presentToast('Food Loaded inside the qbox no $qBoxBarcode');
  //       }
  //       else {
  //         commonService
  //             .errorToast('Failed to store the food item. Please try again.');
  //       }
  //     } catch (e) {
  //       commonService
  //           .presentToast('An error occurred while storing the food item.');
  //     }
  //     setState(() {});
  //   }
  //   else{
  //     commonService.presentToast('Please provide valid QBox ID and Food Item.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeCard(),
                          SizedBox(height: 32),
                          _buildQuickActions(),
                          SizedBox(height: 32),
                          buildMergedHistoryCard(
                            qBoxBarcode,
                            foodBarcode,
                            Icons.inventory, // or whatever icon you use for container
                            Icons.fastfood,  // or whatever icon you use for food
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildMainActionButton(),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEF2F2),
            Colors.white,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QBox & Food Scanner',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mintGreen,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Manage your inventory easily',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: AppColors.mintGreen),
                  onPressed: () {
                    GoRouter.of(context).push(NotificationHistoryScreen.routeName);
                  },
                ),
              ),
              if (isReadyToLoad)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mintGreen, Color(0xFFBE123C)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.mintGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Quick Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Start Scanning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Scan QR code to manage your inventory',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner,
              color: AppColors.mintGreen,
              size: 32,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Compartment',
                Icons.qr_code_scanner_rounded,
                'Scan compartment QR',
                Color(0xFFFEE2E2),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                'Food Item',
                Icons.fastfood_rounded,
                'Scan food item',
                Color(0xFFFEE2E2),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildActionCard(String title, IconData icon, String subtitle, Color bgColor) {
    return InkWell(
      onTap: () => scanBarcode(title),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.mintGreen, size: 24),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildMergedHistoryCard(String containerCode, String foodCode, IconData containerIcon, IconData foodIcon) {
    if (containerCode.isEmpty && foodCode.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (containerCode.isNotEmpty)
            _buildItemRow(
              type: 'Compartment',
              code: containerCode,
              icon: containerIcon,
              onDelete: () {
                setState(() {
                  qBoxBarcode = '';
                });
              },
            ),
          if (containerCode.isNotEmpty && foodCode.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1),
            ),
          if (foodCode.isNotEmpty)
            _buildItemRow(
              type: 'Food',
              code: foodCode,
              icon: foodIcon,
              onDelete: () {
                setState(() {
                  foodBarcode = '';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required String type,
    required String code,
    required IconData icon,
    required VoidCallback onDelete,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.mintGreen, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                code,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildMainActionButton() {
    final bool isEnabled = qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty;
    return FloatingActionButton.extended(
      onPressed: isEnabled ? loadToQBox : null,
      backgroundColor: isEnabled ? AppColors.mintGreen : Colors.grey[300],
      label: Row(
        children: [
          Icon(Icons.add_box_rounded),
          SizedBox(width: 8),
          Text('Load Item'),
        ],
      ),
    ).animate().fadeIn(duration: 900.ms);
  }
}