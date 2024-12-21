import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Theme/app_theme.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Widgets/Common/app_button.dart';
import '../../../../Widgets/Common/app_colors.dart';
import '../../../../Widgets/Common/app_text.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  State<DispatchScreen> createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Dispatch For Delivery', style: TextStyle(color: Colors.black),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildScannerCard(context, provider),
              const SizedBox(height: 20),
              _buildDispatchButton(provider, context),
              const SizedBox(height: 20),
              Expanded(
                child: _buildItemsList(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDispatchButton(FoodStoreProvider provider, BuildContext context) {
    final isEnabled = provider.scannedDispatchItem != null;
    return  ElevatedButton(
      onPressed: provider.scannedDispatchItem != null
          ? () => provider.dispatchFoodItem(context)
          : null,
      style: ElevatedButton.styleFrom(
          backgroundColor:
          provider.scannedDispatchItem != null ? AppTheme.appTheme : null,
          foregroundColor: provider.scannedDispatchItem != null
              ? Colors.white
              : Colors.grey[500]),
      child: Text('Dispatch Food Item'),
    );
  }


  Widget _buildItemsList(FoodStoreProvider provider) {
    return ListView.builder(
      itemCount: provider.storedItems.length,
      itemBuilder: (context, index) {
        final item = provider.storedItems[index];
        final isHighlighted = item.uniqueCode == provider.scannedDispatchItem;

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.appTheme.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isHighlighted
                ? Border.all(color: AppTheme.appTheme.withOpacity(0.3))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.green.withOpacity(0.2)
                    : AppTheme.appTheme.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isHighlighted ? Icons.check : Icons.fastfood,
                color: isHighlighted ? Colors.green : AppTheme.appTheme,
                size: 24,
              ),
            ),
            title: Text(
              item.uniqueCode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.rectangle_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Container: ${item.boxCellSno}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Stored: ${item.storageDate.toString().substring(0, 16)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerCard(BuildContext context, FoodStoreProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:  AppColors.paleYellow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.paleYellow.withOpacity(1.0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Scan Food Item to Dispatch',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:AppColors.paleYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666",
                  "Cancel",
                  true,
                  ScanMode.QR,
                );
                if (barcodeScanRes != '-1') {
                  provider.handleDispatchQRScan(context, barcodeScanRes);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 50, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    'Tap to Scan QR Code',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ).animate(
    onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 1800.ms),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: provider.scannedDispatchItem != null
                    ? AppTheme.appTheme.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: provider.scannedDispatchItem != null
                      ? AppTheme.appTheme.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Text(
                provider.scannedDispatchItem ?? 'No item scanned',
                style: TextStyle(
                  color: provider.scannedDispatchItem != null
                      ? AppTheme.appTheme
                      : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color overlayColor;
  final Color scannerColor;
  final Animation<double> animation;

  ScannerOverlayPainter({
    required this.overlayColor,
    required this.scannerColor,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final scanWindowSize = size.width * 0.8;
    final scanWindowOffset = (size.width - scanWindowSize) / 2;
    final scanWindowTop = (size.height - scanWindowSize) / 2;

    // Draw dark overlay
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final windowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            scanWindowOffset,
            scanWindowTop,
            scanWindowSize,
            scanWindowSize,
          ),
          const Radius.circular(12),
        ),
      );

    final path = Path.combine(
      PathOperation.difference,
      backgroundPath,
      windowPath,
    );

    canvas.drawPath(path, Paint()..color = overlayColor);

    // Draw corner markers
    final markerLength = scanWindowSize * 0.1;
    final markerPaint = Paint()
      ..color = scannerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Top left corner
    canvas.drawLine(
      Offset(scanWindowOffset, scanWindowTop + markerLength),
      Offset(scanWindowOffset, scanWindowTop),
      markerPaint,
    );
    canvas.drawLine(
      Offset(scanWindowOffset, scanWindowTop),
      Offset(scanWindowOffset + markerLength, scanWindowTop),
      markerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(scanWindowOffset + scanWindowSize - markerLength, scanWindowTop),
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop),
      markerPaint,
    );
    canvas.drawLine(
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop),
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop + markerLength),
      markerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(scanWindowOffset, scanWindowTop + scanWindowSize - markerLength),
      Offset(scanWindowOffset, scanWindowTop + scanWindowSize),
      markerPaint,
    );
    canvas.drawLine(
      Offset(scanWindowOffset, scanWindowTop + scanWindowSize),
      Offset(scanWindowOffset + markerLength, scanWindowTop + scanWindowSize),
      markerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(scanWindowOffset + scanWindowSize - markerLength, scanWindowTop + scanWindowSize),
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop + scanWindowSize),
      markerPaint,
    );
    canvas.drawLine(
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop + scanWindowSize),
      Offset(scanWindowOffset + scanWindowSize, scanWindowTop + scanWindowSize - markerLength),
      markerPaint,
    );

    // Draw scanning laser line
    final laserY = scanWindowTop + (scanWindowSize * animation.value);

    final laserGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        scannerColor.withOpacity(0.0),
        scannerColor,
        scannerColor.withOpacity(0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final laserRect = Rect.fromLTWH(
      scanWindowOffset,
      laserY - 1,
      scanWindowSize,
      2,
    );

    canvas.drawRect(
      laserRect,
      Paint()..shader = laserGradient.createShader(laserRect),
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) => true;
}

