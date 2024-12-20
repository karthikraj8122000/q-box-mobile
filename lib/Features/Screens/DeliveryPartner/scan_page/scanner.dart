import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

import 'delivery_scanner_provider.dart';

class Scanner extends StatefulWidget {
  static const String routeName = '/scanner';

  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}


class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScannerProvider()..getPurchaseId(),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<ScannerProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text('Scanner', style: TextStyle(color: Colors.white)),
              ),
              body: InwardDeliveryTab(),
            ),
          );
        },
      ),
    );
  }
}




class InwardDeliveryTab extends StatefulWidget {
  @override
  _InwardDeliveryTabState createState() => _InwardDeliveryTabState();
}


class _InwardDeliveryTabState extends State<InwardDeliveryTab> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScannerProvider>(context);
    return ListView(
      children: [
        if (provider.returnPurchaseList.isNotEmpty)
          Container(
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(text: 'Your '),
                        TextSpan(text: 'Q-box', style: TextStyle(color: Colors.red)),
                        TextSpan(text: ' Order Encrypted with QR.'),
                      ],
                    ),
                  ),
                ),

               Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: provider.returnPurchaseList.isNotEmpty
                        ? provider.returnPurchaseList[0]['partnerPurchaseOrderId']
                        : '',
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(text: 'Scan your '),
                        TextSpan(text: 'Q-box', style: TextStyle(color: Colors.red)),
                        TextSpan(text: ' Order here.'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: provider.returnPurchaseList.isNotEmpty
                          ? Text(
                          'Order Id : ${provider.returnPurchaseList[0]['partnerPurchaseOrderId']}\n',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                          : const Text(''),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        provider.change();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: provider.isShow
                      ? Column(
                    children: [
                      for (int i = 0; i < provider.value['purchaseOrderDtls'].length; i++)
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                            child: ListTile(
                              title: Text(
                                '${provider.value['purchaseOrderDtls'][i]['partnerFoodCode']}  (${provider.value['purchaseOrderDtls'][i]['orderQuantity'].toString()})',
                                style: const TextStyle(fontSize: 18, color: Colors.red),
                              ),
                              subtitle: Text(
                                '${DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.parse(provider.value['purchaseOrder']['deliveredTime']))}',
                                style: const TextStyle(fontSize: 14, color: Colors.black),
                              ),
                              leading: Image.asset(
                                "assets/chicken.png",
                                width: 55,
                                height: 55,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


