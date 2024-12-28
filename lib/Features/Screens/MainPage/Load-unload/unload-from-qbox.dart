import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/food_store_provider.dart';
import '../../../../Widgets/Common/app_colors.dart';

class UnloadQbox extends StatefulWidget {
  const UnloadQbox({super.key});

  @override
  State<UnloadQbox> createState() => _UnloadQboxState();
}

class _UnloadQboxState extends State<UnloadQbox> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDispatchStats(provider),
          const SizedBox(height: 30),
          _buildScanSection(context, provider),
          const SizedBox(height: 30),
          if (provider.scannedFoodItems.isNotEmpty)
            _buildScannedItems(provider)
          else
            _buildEnhancedEmptyState(),
        ],
      ),
    );
  }

  Widget _buildScannedItems(FoodStoreProvider provider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scanned Items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () => provider.clearScannedItems(),
                icon: Icon(Icons.clear_all, color: Colors.red),
                label: Text('Clear All', style: TextStyle(color: Colors.red)),
              ),
            ],
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: provider.scannedFoodItems.length,
              itemBuilder: (context, index) {
                final item = provider.scannedFoodItems[index];
                return _buildScannedItemCard(item, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannedItemCard(dynamic item, FoodStoreProvider provider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/food.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QBox ID: ${item['boxCellSno']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Added: ${_formatDateTime(item['entryTime'])}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                provider.scannedFoodItems.remove(item);
                provider.notifyListeners();
              },
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 900.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildEnhancedEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.darkPaleYellow.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                size: 64,
                color: AppColors.darkPaleYellow,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms)
                .then()
                .shake(hz: 2, curve: Curves.easeInOutCubic),
            SizedBox(height: 32),
            Text(
              'No Items to Unload',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Store some items first before unloading',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 800.ms)
          .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
    );
  }

  Widget _buildDispatchStats(FoodStoreProvider provider) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mintGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.sell_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready for sale',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      provider.foodItems.length > 1
                          ? '${provider.foodItems.length} Items'
                          : '${provider.foodItems.length} Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDispatchStat('Pending', '12'),
                _buildVerticalDivider(),
                _buildDispatchStat('In Transit', '5'),
                _buildVerticalDivider(),
                _buildDispatchStat('Delivered', '28'),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildDispatchStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildScanSection(BuildContext context, FoodStoreProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () async {
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
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkPaleYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.darkPaleYellow,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap to Scan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Scan food item QR code',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: provider.scannedDispatchItem != null
                        ? AppColors.mintGreen.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: provider.scannedDispatchItem != null
                          ? AppColors.mintGreen.withOpacity(0.3)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        provider.scannedDispatchItem != null
                            ? Icons.check_circle_rounded
                            : Icons.qr_code_2_rounded,
                        color: provider.scannedDispatchItem != null
                            ? AppColors.mintGreen
                            : Colors.grey[400],
                        size: 24,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          provider.scannedDispatchItem ?? 'No item scanned yet',
                          style: TextStyle(
                            color: provider.scannedDispatchItem != null
                                ? AppColors.mintGreen
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.scannedDispatchItem != null) ...[
                  SizedBox(height: 24),
                  _buildDispatchButton(provider, context),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildDispatchButton(
      FoodStoreProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.darkPaleYellow,
            AppColors.darkPaleYellow.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPaleYellow.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => provider.dispatchFoodItem(context),
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.outbox,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Unload Food Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableItems(FoodStoreProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Available Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
        SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
            mainAxisExtent: null,
          ),
          itemCount: provider.foodItems.length,
          itemBuilder: (context, index) {
            if (provider.foodItems.isEmpty) return Container();
            final qbox = provider.foodItems[index];
            return _buildEnhancedItemCard(qbox, index,provider);
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedItemCard(dynamic qbox, int index,FoodStoreProvider provider) {
    final isHighlighted = qbox['uniqueCode'] == provider.scannedDispatchItem;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/food.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'QBox ID: ${qbox['boxCellSno']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Added: ${_formatDateTime(qbox['entryTime'])}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.2, end: 0);
  }

  // Widget _buildEnhancedItemCard(dynamic qbox, int index,FoodStoreProvider provider) {
  //   final isHighlighted = qbox['uniqueCode'] == provider.scannedDispatchItem;
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: Colors.transparent),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 20,
  //           offset: Offset(0, 10),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 80,
  //             height: 80,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               image: DecorationImage(
  //                 image: AssetImage('assets/food.jpeg'),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 20),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 8),
  //                 _buildItemDetail('QBox ID', qbox['boxCellSno'].toString(),isHighlighted),
  //                 _buildItemDetail('Added', _formatDateTime(qbox['entryTime']),isHighlighted),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ).animate().fadeIn(duration: 900.ms).slideX(begin: 0.2, end: 0);
  // }
  //
  // Widget _buildEnhancedItemCard(dynamic item, FoodStoreProvider provider) {
  //   final isHighlighted = item.uniqueCode == provider.scannedDispatchItem;
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(
  //           color: isHighlighted ? AppColors.mintGreen : Colors.transparent),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 20,
  //           offset: Offset(0, 10),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 80,
  //             height: 80,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(16),
  //               image: DecorationImage(
  //                 image: AssetImage('assets/food.jpeg'),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 20),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   item.uniqueCode,
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 SizedBox(height: 8),
  //                 _buildItemDetail(
  //                   'QBox ID',
  //                   item.boxCellSno,
  //                   isHighlighted,
  //                 ),
  //                 _buildItemDetail(
  //                   'Added',
  //                   _formatDate(item.storageDate),
  //                   isHighlighted,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           if (isHighlighted)
  //             Container(
  //               padding: EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: AppColors.mintGreen.withOpacity(0.3),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 Icons.check_rounded,
  //                 color: AppColors.white,
  //                 size: 24,
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   ).animate().fadeIn(duration: 900.ms).slideX(begin: 0.2, end: 0);
  // }

  String _formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}";
  }

  Widget _buildItemDetail(String label, String value, bool isHighlighted) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
