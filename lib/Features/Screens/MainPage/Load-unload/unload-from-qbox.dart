import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Common/app_colors.dart';
import 'load_history.dart';

class UnloadQbox extends StatefulWidget {
  final int? qboxEntitySno;
  const UnloadQbox({super.key,required this.qboxEntitySno});

  @override
  State<UnloadQbox> createState() => _UnloadQboxState();
}

class _UnloadQboxState extends State<UnloadQbox> {
  String qBoxOutBarcode = '';
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  bool get isReadyToLoad => qBoxOutBarcode.isNotEmpty;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('qboxEntityll${widget.qboxEntitySno}');
    });
  }



  unloadFromQBox() async {
    Map<String, dynamic> body = {
      "uniqueCode": qBoxOutBarcode,
      "wfStageCd":12,
      "qboxEntitySno": 22
    };
    try {
      var result = await apiService.post("8912", "masters","unload_sku_from_qbox_to_hotbox", body);
      if (result != null && result['data'] != null) {
        print('RESULT$result');
        commonService.presentToast('Food Unloaded from the qbox');
        qBoxOutBarcode = '';
      }else{
        commonService.presentToast('Something went wrong....');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
    });
  }

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        qBoxOutBarcode = barcodeScanRes;
      });
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 30),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildWelcomeCard(),
              const SizedBox(height: 30),
              _buildScanSection(context, provider),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unload Food Item',
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
                icon: Icon(Icons.notifications_outlined,
                    color: AppColors.mintGreen),
                onPressed: () {
                  GoRouter.of(context)
                      .push(NotificationHistoryScreen.routeName);
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

  Widget _buildScanSection(BuildContext context, FoodStoreProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () => scanBarcode(),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkPaleYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.darkPaleYellow,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap to Scan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Scan food item QR code',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppColors.mintGreen.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                if (qBoxOutBarcode.isNotEmpty && qBoxOutBarcode != '-1') ...[
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: qBoxOutBarcode.isNotEmpty
                          ? AppColors.mintGreen.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: qBoxOutBarcode.isNotEmpty
                            ? AppColors.mintGreen.withOpacity(0.3)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          qBoxOutBarcode.isNotEmpty
                              ? Icons.check_circle_rounded
                              : Icons.qr_code_2_rounded,
                          color: qBoxOutBarcode.isNotEmpty
                              ? AppColors.mintGreen
                              : Colors.grey[400],
                          size: 24,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            qBoxOutBarcode ?? 'No item scanned yet',
                            style: TextStyle(
                              color: qBoxOutBarcode.isNotEmpty
                                  ? AppColors.mintGreen
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildDispatchButton(provider, context),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildDispatchButton(FoodStoreProvider provider, BuildContext context) {
    final isEnabled = qBoxOutBarcode.isNotEmpty;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isEnabled
              ? [
                  AppColors.darkMintGreen,
                  AppColors.mintGreen.withOpacity(0.8),
                ]
              : [
                  Colors.grey[300]!,
                  Colors.grey[400]!,
                ],
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.mintGreen.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => unloadFromQBox() : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.outbox,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Unload Food Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
