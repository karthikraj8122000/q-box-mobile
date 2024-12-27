import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/food_store_provider.dart';
import '../../../../Widgets/Common/app_colors.dart';

class LoadQbox extends StatefulWidget {
  const LoadQbox({super.key});

  @override
  State<LoadQbox> createState() => _LoadQboxState();
}

class _LoadQboxState extends State<LoadQbox> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodStoreProvider>().getFoodItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardCard(context, provider),
          const SizedBox(height: 30),
          _buildScanningSection(provider, context),
          if (provider.foodItems.isNotEmpty)
            _buildMappedItems(provider)
          else
            _buildEnhancedEmptyState(),
        ],
      ),
    );
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
              'No Items to Dispatch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Store some items first before dispatching',
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

  Widget _buildMappedItems(FoodStoreProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          'Loaded Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: provider.foodItems.length,
          itemBuilder: (context, index) {
            if (provider.foodItems.isEmpty) {
              return Container();
            }
            final qbox = provider.foodItems[index];
            return _buildEnhancedItemCard(qbox, index);
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedItemCard(dynamic qbox, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
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
                  SizedBox(height: 8),
                  _buildItemDetail('QBox ID', qbox['boxCellSno'].toString()),
                  _buildItemDetail('Added', _formatDateTime(qbox['entryTime'])),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 900.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildItemDetail(String label, String value) {
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

  Widget _buildScanningSection(
      FoodStoreProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedScanCard(
                'Scan QBox',
                'Select storage container',
                AppColors.mintGreen,
                Icons.qr_code_scanner_rounded,
                provider.qboxId,
                () => provider.scanContainer(context),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedScanCard(
                'Scan Food Item',
                'Add item to selected container',
                AppColors.darkPaleYellow,
                Icons.fastfood_rounded,
                provider.foodItem,
                provider.qboxId != null
                    ? () => provider.scanFoodItem(context)
                    : null,
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
            ),
            SizedBox(height: 24),
          ],
        ),
        SizedBox(height: 16),
        _buildEnhancedStoreButton(provider, context),
      ],
    );
  }

  Widget _buildEnhancedScanCard(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    String? scannedValue,
    VoidCallback? onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: color,
                      ),
                    ),
                  ],
                ),
                if (scannedValue != null) ...[
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: color,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            scannedValue,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStoreButton(
      FoodStoreProvider provider, BuildContext context) {
    final isEnabled = provider.qboxId != null && provider.foodItem != null;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isEnabled
              ? [
                  AppColors.darkMintGreen,
                  AppColors.mintGreen.withOpacity(0.8),
                ]
              : [
                  Colors.grey[300]!,
                  Colors.grey[400]!,
                ],
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.mintGreen.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => provider.storeFoodItem(context) : null,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_box_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Store Food Item',
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
    ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildDashboardCard(BuildContext context, FoodStoreProvider provider) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), color: AppColors.mintGreen),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: Text(
                    "Load Food Item Details",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white),
                  ))
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
                    _buildStat('Total Items', '${provider.foodItems.length}'),
                    _buildVerticalDivider(),
                    _buildStat(
                        'Available Boxes', '${provider.qboxList.length}'),
                    _buildVerticalDivider(),
                    _buildStat('In Transit', '3'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0);
  }

  String _formatDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}";
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStat(String label, String value) {
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

 // Date _formatDate(DateTime date) {
 //    return '${date.day}/${date.month}/${date.year}';
 //  }
}
