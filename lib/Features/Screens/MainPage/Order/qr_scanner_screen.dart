
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../Provider/inward_order_provider.dart';
import '../../../../Widgets/Common/divider_text.dart';
import 'order_card.dart';

class OrderQRScannerScreen extends StatefulWidget {
  static const String routeName = '/order-scan';
  const OrderQRScannerScreen({super.key});

  @override
  State<OrderQRScannerScreen> createState() => _OrderQRScannerScreenState();
}

class _OrderQRScannerScreenState extends State<OrderQRScannerScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InwardOrderDtlProvider>().getTotalItems();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
            (index) => Container(
          width: 60,
          margin: EdgeInsets.all(12),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                _focusNodes[index + 1].requestFocus();
              }
              if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialScanView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/qrscan.jpg",
                height: 120,
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
                'Use your phone to scan the QR code.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mintGreen),
                onPressed: () => context.read<InwardOrderDtlProvider>().scanOrderQR(context),
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scan Now'),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        CustomDivider(text: "OR"),
        SizedBox(height: 24),
        Text(
          'Manual Entry',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter last 4-digit order id',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightBlack),
                textAlign: TextAlign.center,
              ),
              _buildOTPFields(),
              SizedBox(height: 24),
              OutlinedButton.icon(
                iconAlignment: IconAlignment.end,
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mintGreen),
                onPressed: () {
                  final orderId = _controllers.map((c) => c.text).join();
                  context.read<InwardOrderDtlProvider>().handleEntry(context, orderId);
                },
                icon: Icon(Icons.download_done),
                label: Text('Submit'),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                iconAlignment: IconAlignment.end,
                icon: Icon(Icons.arrow_forward),
                label: Text('Go To Orders'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: AppColors.mintGreen),
                onPressed: () => context.read<InwardOrderDtlProvider>().getTotalItems(),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InwardOrderDtlProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.scanStatus == "notComplete")
                _buildInitialScanView()
              else if (provider.scanStatus == "complete")
                provider.purchaseOrders.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => provider.resetScan(),
                      icon: Icon(Icons.qr_code_scanner),
                      label: Text('Scan New Order'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        backgroundColor: AppColors.mintGreen,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: provider.purchaseOrders.length,
                        itemBuilder: (context, index) {
                          return OrderCard(order: provider.purchaseOrders[index]);
                        },
                      ),
                    ),
                  ],
                )
                    : Container(),
            ],
          ),
        );
      },
    );
  }
}