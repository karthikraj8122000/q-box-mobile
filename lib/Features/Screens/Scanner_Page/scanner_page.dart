import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Widgets/Common/app_text.dart';
import '../../../Model/Data_Models/tab_model/tab_items_model.dart';
import '../../../Provider/scanner_provider.dart';
import '../../../Services/barcode_scanner_service.dart';
import '../../../Utils/utils.dart';
import '../../../Widgets/Custom/custom_outlined_button.dart';
import '../../../Widgets/Custom/custom_tabbar.dart';


class ScannerPage extends StatefulWidget {
  static const String routeName = '/scanner';
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TabItem> tabItems = [
    TabItem(label: 'LOAD', icon: Icons.input),
    TabItem(label: 'UNLOAD', icon: Icons.output),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context);
    return WillPopScope(
      onWillPop: handleWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white30,
          title: const Align(
            alignment: Alignment.topLeft,
            child: AppText(
              text: 'Remote Location Admin',
              fontSize: 20,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: CustomTabBar(
              tabController: _tabController,
              onTabSelected: (index) {
                  _tabController.index = index;
              }, tabItems: tabItems,
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScanAndDisplayUI(
                        'Qbox', '[ Tap to scan qbox ]', 'Scanned QBox ID : ',
                        scannerProvider.scannerModel.qBoxBarcode),
                    _buildScanAndDisplayUI(
                        'Food In', '[ Tap to scan food ]', 'Scanned Food ID : ',
                        scannerProvider.scannerModel.foodBarcode),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScanAndDisplayUI(
                      'Food Out', '[ Tap to scan food ]', 'Food ID : ',
                      scannerProvider.scannerModel.qBoxOutBarcode),
                  const SizedBox(height: 20),
                  AppText(
                    text:scannerProvider.scannerModel.qBoxOutStatus,
                    fontSize: 20,
                    color: Colors.green
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: buildOutlinedButton(
          _tabController.index == 0 ? 'LOAD TO QBOX' : 'UNLOAD FROM QBOX',
            _tabController.index == 0 ? Icons.input:Icons.output,
          _tabController.index == 0
              ? () => scannerProvider.loadToQBox()
              : () => scannerProvider.unloadFromQBox(),
        ),
      ),
    );
  }

  Widget _buildScanAndDisplayUI(String name, String labelText, String labelText2, String barcodeValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        AppText(text: name,color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700,),
        GestureDetector(
          onTap: () => _scanBarcode(name),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6, // Set width to 80% of screen width
            height: MediaQuery.of(context).size.width * 0.4, // Set height to 80% of screen width (to maintain aspect ratio)
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Match the border radius
              child: Image(
                image: name == 'Qbox'
                    ? const AssetImage('assets/qr4-removebg-preview.png')
                    :name == 'Food In'? const AssetImage('assets/qr3-removebg-preview.png'):const AssetImage('assets/qrscan.png'),
                fit: BoxFit.cover, // Fit the image to the container
              ),
            ),
          ),
        ),
        // const SizedBox(height: 10),
        AppText(text: labelText,color: Colors.black,fontSize: 14,),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(text: labelText2,fontSize: 18,color: Colors.deepPurple,fontWeight: FontWeight.bold),
            AppText(text: barcodeValue,fontSize: 18,color: Colors.deepPurple,fontWeight: FontWeight.bold),
          ],
        ),
      ],
    );
  }

  Future<void> _scanBarcode(String name) async {
    final scannerProvider = Provider.of<ScannerProvider>(context, listen: false);
    final barcodeScanRes = await BarcodeScannerService.scanBarcode();

    if (name == 'Qbox') {
      scannerProvider.updateQBoxBarcode(barcodeScanRes);
    } else if (name == 'food') {
      scannerProvider.updateFoodBarcode(barcodeScanRes);
    } else if (name == 'QboxOut') {
      scannerProvider.updateQBoxOutBarcode(barcodeScanRes);
    }
    print(barcodeScanRes);
  }
}