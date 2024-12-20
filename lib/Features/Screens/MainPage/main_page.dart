import 'package:flutter/material.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_screen/dispatch_screen.dart';
import 'package:qr_page/Features/Screens/MainPage/dispatch_history/history.dart';
import 'package:qr_page/Features/Screens/MainPage/storage_screen/storage_screen.dart';
import '../../../Utils/utils.dart';
import 'dart:math' as math;
import '../../../Widgets/Common/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/landing-page';
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _bubbleAnimation;
  Animation<double>? _scaleAnimation;

  final List<Widget> _screens = [
    FoodStorageScreen(),
    DispatchScreen(),
    DispatchHistoryScreen(),
    DispatchHistoryScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.local_shipping_outlined,
    Icons.history_outlined,
    Icons.person_outline,
  ];

  final List<String> _labels = ['Home', 'Dispatch', 'History', 'Profile'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bubbleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward(from: 0.0);
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleWillPop(context),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryText.withOpacity(0.08),
                offset: const Offset(0, -1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _bubbleAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 80),
                    painter: BubblePainter(
                      bubbleContext: _bubbleAnimation.value,
                      color: AppColors.buttonBgColor.withOpacity(0.15),
                      selectedIndex: _selectedIndex,
                      itemCount: _icons.length,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _icons.length,
                      (index) => _buildNavItem(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedBuilder(
          animation: _scaleAnimation!,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _scaleAnimation!.value : 1.0,
              child: SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isSelected)
                      AnimatedBuilder(
                        animation: _bubbleAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -8 * _bubbleAnimation.value),
                            child: Transform.rotate(
                              angle: 2 * math.pi * _bubbleAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.buttonBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _icons[index],
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    if (!isSelected)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _icons[index],
                            color: AppColors.navInactive,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              color: AppColors.navInactive,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final double bubbleContext;
  final Color color;
  final int selectedIndex;
  final int itemCount;

  BubblePainter({
    required this.bubbleContext,
    required this.color,
    required this.selectedIndex,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final itemWidth = size.width / itemCount;
    final centerX = itemWidth * selectedIndex + (itemWidth / 2);
    final centerY = size.height - 20;

    final path = Path();
    path.moveTo(0, size.height);

    // Draw bubble effect
    for (double x = 0; x < size.width; x++) {
      final distanceFromCenter = (x - centerX).abs();
      final influence = math.max(0, 1 - distanceFromCenter / (itemWidth * 1.5));
      final y = size.height -
          (30 * influence * bubbleContext) -
          (10 * math.sin(x / 20) * influence * bubbleContext);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    // Draw the bubbles
    final bubbleRadius = 4.0;
    final bubbleCount = 3;
    for (int i = 0; i < bubbleCount; i++) {
      final bubbleX = centerX + (i - 1) * 15 * bubbleContext;
      final bubbleY = centerY - 40 * bubbleContext;
      canvas.drawCircle(
        Offset(bubbleX, bubbleY),
        bubbleRadius * (1 - bubbleContext),
        paint,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate.bubbleContext != bubbleContext ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}