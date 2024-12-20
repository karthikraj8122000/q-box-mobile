import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Common/app_button.dart';
import '../../../../Widgets/Common/app_text.dart';

class FoodStorageScreen extends StatelessWidget {
  const FoodStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildStatCards(provider),
                const SizedBox(height: 24),
                _buildScanButtons(provider, context),
                const SizedBox(height: 24),
                _buildStoreButton(provider, context),
                const SizedBox(height: 24),
                _buildStoredItemsList(provider),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600], size: 30),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hello, Karthik',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Have a nice day!',
                  // 'Food Storage',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.delivery_dining, color: Colors.grey[400], size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStatCards(FoodStoreProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
              color: Colors.blue.shade50,
              icon: Icons.inventory_2_outlined,
              title: 'Total Items',
              value: '${provider.storedItems.length}',
              titleColor: Colors.black,
              iconColor: Colors.black,
              valueColor: Colors.black
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
              color: Colors.green.shade50,
              icon: Icons.grid_view,
              title: 'Available Qbox',
              value: '${100 - provider.storedItems.length}',
              titleColor: Colors.black,
              iconColor: Colors.black,
              valueColor: Colors.black
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    required Color titleColor,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow:[
                  BoxShadow(color:Colors.black,blurRadius: 1,spreadRadius: 0)
                ]
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: titleColor),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanButtons(FoodStoreProvider provider, BuildContext context) {
    return Column(
      children: [
        _buildScanButton(
            'Scan QBox ID',
            provider.qboxId,
                () async {
              final result = await showDialog(
                context: context,
                builder: (context) => QRScannerDialog(isContainerScanner: true),
              );
              if (result != null) {
                provider.scanContainer(context);
              }
            },

            AppColors.mintGreen,
            context
        ).animate(
            onPlay: (controller) =>
                controller.repeat(reverse: true))
            .shimmer(duration: 1500.ms),
        const SizedBox(height: 10),
        _buildScanButton(
            'Scan Food Item ID',
            provider.foodItem,
            provider.qboxId != null
                ? () => provider.scanFoodItem(context)
                : null,
            AppColors.paleYellow,
            context
        ).animate(
            onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 1800.ms),
      ],
    );
  }

  Widget _buildScanButton( String label,
      String? item,
      VoidCallback? onPressed,
      Color color,BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
          onTap: () {
            if (onPressed == null) {
              if (label.contains('Scan Food Item ID')) {
                provider.scanFoodItem(context); // This will show the toast
              }
            } else {
              onPressed();
            }
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.qr_code_scanner, color:label == "Scan QBox ID"? Colors.green:Colors.yellow[800]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _buildStoreButton(FoodStoreProvider provider, BuildContext context) {
    final isEnabled = provider.qboxId != null && provider.foodItem != null;
    return  ElevatedButton(
      onPressed: (provider.qboxId != null && provider.foodItem != null)
          ? () => provider.storeFoodItem(context)
          : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          backgroundColor: AppColors.softPink,
          textStyle: TextStyle(fontSize: 18),
          foregroundColor: Colors.white),
      child: AppText(
        text: 'Store Food Item',
        fontSize: 14,
      ),
    );
  }

  Widget _buildStoredItemsList(FoodStoreProvider provider) {
    if (provider.storedItems.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No food items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan QBox ID and Food Item to store',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Colors.blue.shade300,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.storedItems.length,
      itemBuilder: (context, index) {
        final item = provider.storedItems[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent, // Optional: Set a background color
                    child: ClipOval(
                      child: Image.asset(
                        'assets/food.jpeg',
                        fit: BoxFit.cover, // Ensures the image covers the entire circle
                        width: 50, // Match the diameter of the CircleAvatar
                        height: 50,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.uniqueCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Container: ${item.boxCellSno}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Stored: ${item.storageDate.toString().substring(0, 16)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}


class QRScannerDialog extends StatefulWidget {
  final bool isContainerScanner;

  const QRScannerDialog({Key? key, required this.isContainerScanner})
      : super(key: key);

  @override
  _QRScannerDialogState createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> with WidgetsBindingObserver {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _flashOn = false;
  bool _isProcessing = false;
  StreamSubscription? _scanSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null) return;

    // App state lifecycle management
    if (state == AppLifecycleState.resumed) {
      controller?.resumeCamera();
    } else if (state == AppLifecycleState.inactive) {
      controller?.pauseCamera();
    } else if (state == AppLifecycleState.paused) {
      controller?.pauseCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Ensure we cancel any existing subscription
    _scanSubscription?.cancel();

    // Add debounce to prevent multiple rapid scans
    _scanSubscription = controller.scannedDataStream
        .distinct() // Only emit if the new value is different from the previous
        .debounceTime(const Duration(milliseconds: 500)) // Add debounce
        .listen((scanData) {
      if (!_isProcessing && mounted && result == null) {
        setState(() {
          _isProcessing = true;
          result = scanData;
        });

        // Pause camera after successful scan
        controller.pauseCamera();
      }
    });
  }

  void _resetScanner() {
    if (mounted) {
      setState(() {
        result = null;
        _isProcessing = false;
      });
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clean up before popping
        await controller?.pauseCamera();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 20,
                borderLength: 40,
                borderWidth: 12,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            // Blur overlay
            if (result != null)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            // Header
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(
                      Icons.arrow_back,
                          () async {
                        await controller?.pauseCamera();
                        Navigator.pop(context);
                      },
                      Colors.white,
                    ),
                    Text(
                      widget.isContainerScanner ? 'Scan QBox' : 'Scan Food Item',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildControlButton(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                          () async {
                        try {
                          await controller?.toggleFlash();
                          setState(() {
                            _flashOn = !_flashOn;
                          });
                        } catch (e) {
                          // Handle flash error silently
                        }
                      },
                      Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            // Success overlay
            if (result != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF8fbc8f),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Scan Successful!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "ID: ${result?.code ?? ''}",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context, result?.code);
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text('Continue'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              backgroundColor: const Color(0xFF8fbc8f),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _resetScanner,
                            icon: const Icon(Icons.refresh, color: Colors.black87),
                            label: const Text(
                              'Try Again',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              backgroundColor: const Color(0xFFf2db8e),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}