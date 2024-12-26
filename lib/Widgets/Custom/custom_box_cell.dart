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
  final int defaultQboxCount = 12;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodStoreProvider>().getQboxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodStoreProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mintGreen),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getGridCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: provider.qboxList.isEmpty ? defaultQboxCount : provider.qboxList.length,
          itemBuilder: (context, index) {
            if (provider.qboxList.isEmpty) {
              return _buildEmptyQboxCard(index);
            }
            final qbox = provider.qboxList[index];
            return _buildQboxCard(qbox, index);
          },
        );
      },
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return 4; // Desktop
    } else if (width > 800) {
      return 3; // Tablet
    } else {
      return 4; // Mobile
    }
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
      child: Center(child: Text("Qbox Cell: ${qbox['boxCellSno']}")),
    )
        .animate()
        .fadeIn(duration: (900 + index * 100).ms)
        .slideY(begin: 0.2, end: 0);
  }
}