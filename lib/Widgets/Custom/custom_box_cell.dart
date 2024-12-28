import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Provider/food_store_provider.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import '../Common/app_colors.dart';

class QboxCells extends StatefulWidget {
  const QboxCells({super.key});

  @override
  State<QboxCells> createState() => _QboxCellsState();
}

class _QboxCellsState extends State<QboxCells> {
  final int defaultQboxCount = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodStoreProvider>().getQboxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodStoreProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.mintGreen),
        );
      } else if (provider.qboxList.isNotEmpty) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getGridCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: null,
            childAspectRatio: 0.8,
          ),
          itemCount: provider.qboxList.isEmpty
              ? defaultQboxCount
              : provider.qboxList.length,
          itemBuilder: (context, index) {
            if (provider.qboxList.isEmpty) {
              return _buildEmptyQboxCard(index);
            }
            final qbox = provider.qboxList[index];
            return _buildQboxCard(qbox, index);
          },
        );
      } else {
        return Center(child: _buildEnhancedEmptyState());
      }
    });
  }

  int _getGridCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4; // Desktop
    } else if (width > 800) {
      return 3; // Tablet
    } else {
      return 3; // Mobile
    }
  }

  Widget _buildEnhancedEmptyState() {
    return Container(
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
            'No Qboxes found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms)
        .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1));
  }

  Widget _buildEmptyQboxCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          AppText(
            text: "Qbox ${index + 1} is empty",
            fontSize: 16,
            color: Colors.grey[600],
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: (900 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildQboxCard(dynamic qbox, int index) {
    final foodStatus = qbox['foodUniqueCode'];

    if (foodStatus != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // This makes the column wrap its content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage('assets/food.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    text: "QBox ${qbox['boxCellSno']}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  if (foodStatus != null) ...[
                    Flexible(
                      child: AppText(
                        text: "SKU: $foodStatus",
                        fontSize: 14,
                        color: Colors.grey[800],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: (900 + index * 100).ms)
              .slideY(begin: 0.2, end: 0);
        },
      );
    }

    // Empty state card
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Makes the column wrap its content
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    AppText(
                      text: "QBox ${qbox['boxCellSno']}",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const Text(
                      "Empty",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms)
            .then();
      },
    );
  }

}
