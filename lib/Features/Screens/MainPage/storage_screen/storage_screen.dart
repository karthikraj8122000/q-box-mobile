import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/see_all_qbox_foods.dart';
import 'package:qr_page/Provider/auth_provider.dart';
import 'package:qr_page/Services/token_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../Provider/food_store_provider.dart';

class FoodStorageScreen extends StatefulWidget {
  const FoodStorageScreen({super.key});

  @override
  State<FoodStorageScreen> createState() => _FoodStorageScreenState();
}

class _FoodStorageScreenState extends State<FoodStorageScreen>
    with SingleTickerProviderStateMixin {
  final TokenService tokenService = TokenService();
  var userData;
  String? fullName;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    var user = await tokenService.getUser();
    userData = json.decode(user);
    fullName = userData['fullName'];
    setState(() {});
    print("usersssssss");
    print(fullName);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          _buildBackground(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('QBox Store',
                        style: TextStyle(color: Colors.black)),
                  ),
                  background: Container(color: Colors.grey[100]),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: AppColors.mintGreen,
                        ),
                        onPressed: () {
                          authProvider.logout();
                          GoRouter.of(context).push(LoginScreen.routeName);
                        }),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDashboardCard(context, provider),
                      const SizedBox(height: 30),
                      _buildScanningSection(provider, context),
                      const SizedBox(height: 30),
                      if (provider.storedItems.isNotEmpty) ...[
                        _buildStoredItemsHeader(context, provider),
                        _buildStoredItemsGrid(provider),
                        const SizedBox(height: 30),
                      ] else
                        _buildEnhancedEmptyState(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
            Colors.grey[100]!,
          ],
        ),
      ),
    );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          fullName ?? '--',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
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
                    _buildStat('Total Items', '${provider.storedItems.length}'),
                    _buildVerticalDivider(),
                    _buildStat('Available Boxes', '24'),
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

  Widget _buildStoredItemsHeader(
      BuildContext context, FoodStoreProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Stored Items',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (provider.storedItems.length > 4)
          TextButton.icon(
            onPressed: () =>
                GoRouter.of(context).push(SeeAllQboxFoods.routeName),
            icon: Icon(Icons.grid_view_rounded, size: 20),
            label: Text('View All'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mintGreen,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStoredItemsGrid(FoodStoreProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: provider.storedItems.length,
      itemBuilder: (context, index) {
        final item = provider.storedItems[index];
        return _buildEnhancedItemCard(item, index);
      },
    );
  }

  // Widget _buildStoredItemsGrid(FoodStoreProvider provider) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       width: provider.storedItems.length * 200.0, // Adjust width based on your needs
  //       child: GridView.builder(
  //         shrinkWrap: true,
  //         physics: AlwaysScrollableScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           crossAxisSpacing: 16,
  //           mainAxisSpacing: 16,
  //           childAspectRatio: 0.8,
  //         ),
  //         itemCount: provider.storedItems.length,
  //         itemBuilder: (context, index) {
  //           final item = provider.storedItems[index];
  //           return _buildEnhancedItemCard(item, index);
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  Widget _buildEnhancedItemCard(dynamic item, int index) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/food.jpeg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.uniqueCode,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'QBox ID: ${item.boxCellSno}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Stored at: ${_formatDate(item.storageDate)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _getTimeAgo(item.storageDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: (900 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
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
                color: AppColors.mintGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                size: 64,
                color: AppColors.mintGreen,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms)
                .then()
                .shake(hz: 2, curve: Curves.easeInOutCubic),
            SizedBox(height: 32),
            Text(
              'Qbox Storage is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Start by scanning a QBox and adding food items',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            // _buildEmptyStateSteps(),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 800.ms)
          .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
    );
  }
}
