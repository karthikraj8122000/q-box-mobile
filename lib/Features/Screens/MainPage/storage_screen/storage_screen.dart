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
import 'package:qr_page/Widgets/Common/app_text.dart';
import 'package:qr_page/Widgets/Custom/custom_box_cell.dart';
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
    final provider = Provider.of<FoodStoreProvider>(context);
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDashboardCard(context, provider),
                      const SizedBox(height: 30),
                      AppText(text: "Inventory", fontSize: 20,fontWeight: FontWeight.bold,),
                      const SizedBox(height: 30),
                      QboxCells()
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
                    _buildStat('Total Items', '${provider.foodItems.length}'),
                    _buildVerticalDivider(),
                    _buildStat('Available Boxes', '${provider.qboxList.length}'),
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
