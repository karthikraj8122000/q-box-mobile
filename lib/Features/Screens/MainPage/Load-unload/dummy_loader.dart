import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/MainPage/Load-unload/unload-from-qbox.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';

import '../../../../Provider/order/order_qr_scanning_provider.dart';
import '../../../../Services/api_service.dart';
import '../../../../Services/toast_service.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';
import 'load-to-qbox.dart';

class LoadOrUnload extends StatefulWidget {
  static const String routeName = '/load-unload';
  const LoadOrUnload({Key? key}) : super(key: key);

  @override
  State<LoadOrUnload> createState() => _LoadOrUnloadState();
}

class _LoadOrUnloadState extends State<LoadOrUnload>
    with TickerProviderStateMixin {
  ApiService? apiService = ApiService();
  CommonService? commonService = CommonService();

  String qBoxBarcode = '';
  String foodBarcode = '';
  String qBoxOutBarcode = '';
  String qBoxOutStatus = '';

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      // Here you can access the current index
      _currentIndex = _tabController.index;
      print('Current Index: $_currentIndex');
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const BackButtonIcon(),
            ),
            title: const Text(
              'Remote Location Admin', // Set the title of the AppBar
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Adjust the font size of the title
            ),
            bottom:  TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.input),
                      SizedBox(width: 10,),
                      Text(
                        'LOAD', // Text for the "IN" tab
                        style: TextStyle(fontSize: 20), // Adjust the font size of the tab text
                      ),
                    ],
                  ), // Icon for the "IN" tab
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.output),
                      SizedBox(width: 10,),
                      Text(
                        'UNLOAD', // Text for the "IN" tab
                        style: TextStyle(fontSize: 20), // Adjust the font size of the tab text
                      ),
                    ],
                  ), // Icon for the "IN" tab
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildScanAndDisplayUI('Qbox', 'Scan Your QBox here', 'QBox ID : ', qBoxBarcode),
                    _buildScanAndDisplayUI('food', 'Scan Your Food here', 'Food ID : ', foodBarcode),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildScanAndDisplayUI('QboxOut', 'Scan Your Food here', 'Food ID : ', qBoxOutBarcode),
                  const SizedBox(height: 20,),
                  Text(qBoxOutStatus, style: const TextStyle(fontSize: 20, color: Colors.green),),
                ],
              ),
            ],
          ),

          // bottomNavigationBar: ElevatedButton(
          //     style: ButtonStyle(
          //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //         backgroundColor: (qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty) ?
          //         MaterialStateProperty.all(Colors.deepPurple) : MaterialStateProperty.all(Colors.deepPurple[300]),
          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //             const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.zero
          //             )
          //         )
          //     ),
          //   onPressed: (qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty) ? () => loadToQBox() : null,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(vertical: 20.0),
          //     child: Text('LOAD',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          //   ),
          // ),

          bottomNavigationBar: buildButton(
            _currentIndex == 0 ? 'LOAD' : 'UNLOAD',
            _currentIndex == 0 ? (qBoxBarcode.isNotEmpty && foodBarcode.isNotEmpty) : (qBoxOutBarcode.isNotEmpty),
            _currentIndex == 0 ? () => loadToQBox() : () => unloadFromQBox(),
          ),
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
          onTap: () => scanBarcode(name),
          // child: const Image(
          //   image: AssetImage('assets/qr_food.png'),
          // ),
          child: name == 'Qbox'
              ? const Image(
            image: AssetImage('assets/qr_box.png'),
          )
              : const Image(
            image: AssetImage('assets/qr_food.png'),
          ),

        ),
        Text(labelText,style: const TextStyle(color: Colors.deepPurple),),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(labelText2,style: const TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),),
              Text(
                barcodeValue,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButton(String name, bool condition, VoidCallback onPressedCallback) {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: condition ? MaterialStateProperty.all(Colors.deepPurple) : MaterialStateProperty.all(Colors.deepPurple[300]),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
              )
          )
      ),
      onPressed: condition ? onPressedCallback : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  loadToQBox() async {
    print('loadToQBox');
    Map<String, dynamic> body = {
      "uniqueCode": foodBarcode,
      "wfStageCd":11,
      "boxCellSno":qBoxBarcode,
      "qboxEntitySno": 3
    };
    print('$body');
    try {
      var result = await apiService?.post("8912", "masters","load_sku_in_qbox", body);
      if (result != null && result['data'] != null) {
        print('RESULT$result');
        qBoxBarcode = '';
        foodBarcode = '';
        commonService?.presentToast('Food Loaded inside the qbox');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {

    });
  }

  unloadFromQBox() async {
    Map<String, dynamic> body = {
      "uniqueCode": qBoxOutBarcode,
      "wfStageCd":12,
      "qboxEntitySno": 3
    };
    print('$body');
    try {
      var result = await apiService?.post("8912", "masters","unload_sku_from_qbox_to_hotbox", body);
      if (result != null && result['data'] != null) {
        print('RESULT$result');
        commonService?.presentToast('Food Unloaded from the qbox');
        qBoxOutBarcode = '';
      }else{
        commonService?.presentToast('Something went wrong....');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {

    });
  }

  Future<void> scanBarcode(String name) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if(name == 'Qbox'){
        setState(() {
          qBoxBarcode = barcodeScanRes;
          print('Scanned barcode: $foodBarcode');
        });
      }if (name == 'food') {
        setState(() {
          foodBarcode = barcodeScanRes;
          print('Scanned barcode: $foodBarcode');
        });
      }else if (name == 'QboxOut'){
        setState(() {
          qBoxOutBarcode = barcodeScanRes;
        });
      }
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }


}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 76.0;
  @override
  double get maxExtent => 76.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
