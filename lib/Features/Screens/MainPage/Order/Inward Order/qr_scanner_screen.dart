import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../../Provider/inward_order_provider.dart';
import '../../../../../Widgets/Common/divider_text.dart';
import '../Common/order_card.dart';
import '../View Order/view_order.dart';

class OrderQRScannerScreen extends StatefulWidget {
  static const String routeName = '/order-scan';
  const OrderQRScannerScreen({super.key});

  @override
  State<OrderQRScannerScreen> createState() => _OrderQRScannerScreenState();
}

class _OrderQRScannerScreenState extends State<OrderQRScannerScreen> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust the width of each OTP field based on screen width
        double fieldWidth = constraints.maxWidth * 0.12; // Adjust as needed
        double fieldMargin = constraints.maxWidth * 0.02; // Adjust as needed

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
                (index) => Container(
              width: fieldWidth.clamp(40.0, 70.0), // Minimum and maximum width limits
              margin: EdgeInsets.symmetric(horizontal: fieldMargin),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mintGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mintGreen, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 1 && index < 4) {
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
      },
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
              ElevatedButton.icon(
                iconAlignment: IconAlignment.start,
                icon: Icon(Icons.qr_code_scanner),
                label: Text('Scan Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: AppColors.mintGreen,
                ),
                onPressed: () {
                  context.read<InwardOrderDtlProvider>().scanOrderQR(context);
                },
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
                'Enter last 5-digit order id',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlack,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildOTPFields(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: AppColors.mintGreen,
                ),
                onPressed: () {
                  context
                      .read<InwardOrderDtlProvider>()
                      .handleManualEntry(context, _controllers);
                },
                child: Text('Submit'),
              ),

              SizedBox(height: 30),
             OutlinedButton.icon(
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_forward),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 24),
                      foregroundColor: AppColors.mintGreen,
                      side: BorderSide(color: AppColors.mintGreen)
                  ),
                  onPressed: (){
                    GoRouter.of(context).push(ViewOrder.routeName);
                  },
                  label: Text("Go To Orders")
              )
            ],
          ),
        ),
      ],
    );
  }

  void onScanComplete(String scannedOrderId) {
    GoRouter.of(context).push(
      ViewOrder.routeName,
      extra: scannedOrderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInitialScanView(),
            ],
          ),
        ),
      ),
    );
  }
}
