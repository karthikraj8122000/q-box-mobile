import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qbox/Utils/utils.dart';
import 'package:qbox/Widgets/Common/app_text.dart';
import '../../../Model/Data_Models/tab_model/tab_items_model.dart';
import '../../../Provider/scanner_provider.dart';
import '../../../Widgets/Custom/custom_gradient_button.dart';
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
          title: const Align(
            alignment: Alignment.topLeft,
            child: AppText(
              text: 'Remote Location Admin',
              fontSize: 20,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
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
                        'Qbox', 'Scan Your QBox here', 'QBox ID : ',
                        scannerProvider.scannerModel.qBoxBarcode),
                    _buildScanAndDisplayUI(
                        'food', 'Scan Your Food here', 'Food ID : ',
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
                      'QboxOut', 'Scan Your Food here', 'Food ID : ',
                      scannerProvider.scannerModel.qBoxOutBarcode),
                  const SizedBox(height: 20),
                  Text(
                    scannerProvider.scannerModel.qBoxOutStatus,
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: buildGradientButton(
          _tabController.index == 0 ? 'LOAD' : 'UNLOAD',
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
        GestureDetector(
          // onTap: () => scanBarcode(name),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Set width to 80% of screen width
            height: MediaQuery.of(context).size.width * 0.5, // Set height to 80% of screen width (to maintain aspect ratio)
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Match the border radius
              child: Image(
                image: name == 'Qbox'
                    ? const AssetImage('assets/qr_box.png')
                    : const AssetImage('assets/qr_food.png'),
                fit: BoxFit.cover, // Fit the image to the container
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(labelText, style: const TextStyle(color: Colors.deepPurple)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(labelText2, style: const TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(barcodeValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
  // Future<void> _scanBarcode(String name) async {
  //   final scannerProvider = Provider.of<ScannerProvider>(context, listen: false);
  //   final barcodeScanRes = await BarcodeScannerService.scanBarcode();
  //
  //   if (name == 'Qbox') {
  //     scannerProvider.updateQBoxBarcode(barcodeScanRes);
  //   } else if (name == 'food') {
  //     scannerProvider.updateFoodBarcode(barcodeScanRes);
  //   } else if (name == 'QboxOut') {
  //     scannerProvider.updateQBoxOutBarcode(barcodeScanRes);
  //   }
  //   print(barcodeScanRes);
  // }
}