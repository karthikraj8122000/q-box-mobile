import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';
import '../../../../Widgets/Common/app_colors.dart';

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
      "qboxEntitySno": 26
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInitialScanView(context,provider),
          // _buildScanSection(context, provider),
        ],
      ),
    );
  }

  Widget _buildInitialScanView(BuildContext context, FoodStoreProvider provider) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/qrscan.jpg",
                    width: isTablet?250:180,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Scan QR Code',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Scan the QR code to unload food from Qbox.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    iconAlignment: IconAlignment.start,
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text('Scan Now'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: AppColors.mintGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    onPressed: () => scanBarcode(),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (qBoxOutBarcode.isNotEmpty && qBoxOutBarcode != '-1') ...[
          SizedBox(height: 24),
          _buildOrderDetails(provider,qBoxOutBarcode),
        ],
      ],
    );
  }

  Widget _buildDispatchButton(FoodStoreProvider provider, BuildContext context) {
    final isEnabled = qBoxOutBarcode.isNotEmpty;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:isEnabled?  Colors.green:Colors.grey[300]!,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => unloadFromQBox() : null,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Text(
              'Confirm Unload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails(FoodStoreProvider provider,String scannedResult) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBlack),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Food Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Qbox ID', '#1234567'),
          _buildDetailRow('Food Code', scannedResult),
          const SizedBox(height: 30),
          _buildDispatchButton(provider, context),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Handle order confirmation
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor:Colors.green,
          //       padding: const EdgeInsets.symmetric(vertical: 15),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: const Text(
          //       'Confirm Unload',
          //       style: TextStyle(fontSize: 18),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
