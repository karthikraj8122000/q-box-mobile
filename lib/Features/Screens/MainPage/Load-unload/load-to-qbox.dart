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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDashboardCard(context, provider),
                const SizedBox(height: 30),
                _buildScanningSection(provider, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningSection(FoodStoreProvider provider, BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

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
        if (isTablet)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(width: 24),
              Expanded(
                child: _buildEnhancedScanCard(
                  'Scan Food Item',
                  'Add item to selected container',
                  AppColors.darkPaleYellow,
                  Icons.fastfood_rounded,
                  provider.foodItem,
                  provider.qboxId != null ? () => provider.scanFoodItem(context) : null,
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildEnhancedScanCard(
                'Scan QBox',
                'Select storage container',
                AppColors.mintGreen,
                Icons.qr_code_scanner_rounded,
                provider.qboxId,
                    () => provider.scanContainer(context),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
              SizedBox(height: 16),
              _buildEnhancedScanCard(
                'Scan Food Item',
                'Add item to selected container',
                AppColors.darkPaleYellow,
                Icons.fastfood_rounded,
                provider.foodItem,
                provider.qboxId != null ? () => provider.scanFoodItem(context) : null,
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final double iconSize = isTablet ? 32 : 28;
        final double fontSize = isTablet ? 18 : 16;
        final double subtitleFontSize = isTablet ? 14 : 12;

        return Container(
          width: double.infinity,
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
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isTablet ? 16 : 12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(icon, color: color, size: iconSize),
                        ),
                        SizedBox(width: isTablet ? 20 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (scannedValue != null) ...[
                      SizedBox(height: isTablet ? 20 : 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: color,
                              size: isTablet ? 24 : 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                scannedValue,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: subtitleFontSize,
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
      },
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
                    _buildStat('Total Items', '${provider.storedItems.length}'),
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
}

