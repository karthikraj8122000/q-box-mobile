import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/load_history.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';
import '../../../../Widgets/Common/app_colors.dart';

class LoadQbox extends StatefulWidget {
  final int? qboxEntitySno;
  const LoadQbox({super.key, required this.qboxEntitySno});

  @override
  State<LoadQbox> createState() => _LoadQboxState();
}

class _LoadQboxState extends State<LoadQbox> {
  String qBoxBarcode = '';
  String foodBarcode = '';
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  bool get isReadyToLoad => qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty;
  final List<dynamic> _returnValue = [];
  List<dynamic> get returnValue => _returnValue;

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcode(String name) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#E11D48', 'Cancel', true, ScanMode.QR);
      if (barcodeScanRes != '-1') {
        setState(() {
          if (name == 'Compartment Scanner') {
            qBoxBarcode = barcodeScanRes;
          } else if (name == 'Food Scanner') {
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
        "uniqueCode": foodBarcode.trim(),
        "wfStageCd": 11,
        "boxCellSno": qBoxBarcode.trim(),
        "qboxEntitySno": widget.qboxEntitySno
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 18),
                          _buildWelcomeCard(),
                          SizedBox(height: 18),
                          _buildQuickActions(),
                          SizedBox(height: 18),
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
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildMainActionButton(),
    );
  }

  Widget _buildHeader() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QBox & Food Scanner',
              style: TextStyle(
                fontSize: isTablet?28:18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
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
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildWelcomeCard() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white
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
                    color: AppColors.mintGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Quick Scan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Start Scanning',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isTablet?24:18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Scan QR code to manage your inventory',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner,
              color: Colors.green,
              size: 45,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildQuickActions() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isTablet?20:18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        if(isTablet)
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                    'Compartment Scanner',
                    'Tap to scan',
                    Colors.red,
                    Colors.red,
                    'https://media.istockphoto.com/id/1667322455/photo/self-service-post-terminal-customer-entering-a-code-and-receiving-the-parcel.jpg?s=612x612&w=0&k=20&c=pWBLg0uIwsKBV4KpL2Hv3CztzaXvoKSv5t0wEoPh9ZE=',
                    Icons.qr_code_scanner
                ),
              ),
              Expanded(
                child: _buildActionCard(
                  'Food Scanner',
                  'Tap to scan',
                  Colors.orange.shade600,
                  Colors.orange,
                  'https://eu-images.contentstack.com/v3/assets/blta023acee29658dfc/blt8bf49a9b70f2d4a1/659ee76ab24208040a0e07de/QR-sustainability-GettyImages-1422209464-web.jpg',
                  Icons.qr_code_scanner,
                ),
              ),
            ],
          )
    else
          Column(
            children: [
              _buildActionCard(
                'Compartment Scanner',
                'Tap to scan',
                  Colors.red,
                  Colors.red,
                'https://media.istockphoto.com/id/1667322455/photo/self-service-post-terminal-customer-entering-a-code-and-receiving-the-parcel.jpg?s=612x612&w=0&k=20&c=pWBLg0uIwsKBV4KpL2Hv3CztzaXvoKSv5t0wEoPh9ZE=',
                Icons.qr_code_scanner
              ),
              _buildActionCard(
                'Food Scanner',
               'Tap to scan',
                Colors.green,
                Colors.green,
               'https://eu-images.contentstack.com/v3/assets/blta023acee29658dfc/blt8bf49a9b70f2d4a1/659ee76ab24208040a0e07de/QR-sustainability-GettyImages-1422209464-web.jpg',
               Icons.qr_code_scanner,
              ),
            ],
          )
      ],
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildActionCard(String title, String subtitle, Color bgColor,Color subtitleColor,String imageUrl,IconData icon) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return InkWell(
      onTap: () => scanBarcode(title),
      child: Container(
        margin: const EdgeInsets.only(left: 8, bottom: 8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: isTablet?80:50,
                  height: isTablet?80:50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isTablet?18:14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Scanned Result:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
        SizedBox(height: 8,),
        Container(
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
                  type: 'Food Code',
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
        ),
      ],
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
              SizedBox(height: 8,),
              Text(
                code,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w900
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
