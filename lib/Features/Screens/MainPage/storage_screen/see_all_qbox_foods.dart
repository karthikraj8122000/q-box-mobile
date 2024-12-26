import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Common/app_colors.dart';

class SeeAllQboxFoods extends StatefulWidget {
  static const String routeName = '/all-foods';
  const SeeAllQboxFoods({super.key});

  @override
  State<SeeAllQboxFoods> createState() => _SeeAllQboxFoodsState();
}

class _SeeAllQboxFoodsState extends State<SeeAllQboxFoods> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: AppColors.black),
            // expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('All Foods', style: TextStyle(color: Colors.black)),
              background: Container(color: Colors.grey[100]),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                if (provider.storedItems.isEmpty) {
                  return _buildEmptyState();
                }
                final item = provider.storedItems[index];
                return _buildItemCard(item, provider);
              },
              childCount: provider.storedItems.isEmpty ? 1 : provider.storedItems.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'There are no items to dispatch',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Scan QBox ID and Food Item to dispatch',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.buttonBgColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: AppColors.buttonBgColor.withOpacity(0.2),
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5))
              .shake(hz: 2, curve: Curves.easeInOutCubic),
        ),
      ],
    );
  }

  Widget _buildItemCard(dynamic item, FoodStoreProvider provider) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'assets/food.jpeg',
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            Expanded(
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
                    'QBox Id: ${item.boxCellSno ?? '--'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Stored: ${item.storageDate.toString().substring(0, 16)}',
                    style: TextStyle(color:Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
