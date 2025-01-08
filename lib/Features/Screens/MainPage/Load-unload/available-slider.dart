import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Widgets/Common/rich_text.dart';
import '../../../../Provider/dashboard_provider.dart';
import '../../../../Widgets/Common/app_colors.dart';

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({Key? key}) : super(key: key);

  @override
  _WelcomeCardState createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isHolding = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().getQboxes();
      _startTimer();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      if (!_isHolding && _pageController.hasClients) {
        final provider = context.read<DashboardProvider>();
        if (provider.qboxLists.isNotEmpty && provider.qboxLists[1]['qboxes'] != null) {
          final nextPage = ((_currentPageIndex + 1) % provider.qboxLists[1]['qboxes'].length).toInt();
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.mintGreen));
        }
        if (provider.error != null) {
          return Container(
            color: AppColors.mintGreen,
            child: Center(child: Text("Something went wrong!")),
          );
        }
        if (provider.qboxLists.isEmpty || provider.qboxLists[1]['qboxes'] == null) {
          return Container(
            color: AppColors.mintGreen,
            child: Center(child: Text("No QBoxes available")),
          );
        }

        final qboxes = provider.qboxLists[1]['qboxes'];

        return GestureDetector(
          onLongPressStart: (_) => setState(() => _isHolding = true),
          onLongPressEnd: (_) => setState(() => _isHolding = false),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.mintGreen.withOpacity(0.8), AppColors.mintGreen],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: qboxes.length,
                    onPageChanged: (index) => setState(() => _currentPageIndex = index),
                    itemBuilder: (context, index) {
                      final item = qboxes[index];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                          }
                          return Center(
                            child: SizedBox(
                              height: Curves.easeInOut.transform(value) * 150,
                              width: Curves.easeInOut.transform(value) * 300,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTwoText(
                                firstText: "QBox ID: ",
                                secondText: "${item['qboxId']}",
                                fontSize: 24,
                                firstColor: AppColors.black,
                                secondColor: AppColors.mintGreen,
                              ),
                              SizedBox(height: 10),
                              AppTwoText(
                                firstText: "Location: ",
                                secondText: "Row ${item['rowNo']} - Column ${item['columnNo']}",
                                fontSize: 18,
                                firstColor: AppColors.black,
                                secondColor: AppColors.mintGreen,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    qboxes.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPageIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPageIndex == index ? Colors.white : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                if (_isHolding) ...[
                  SizedBox(height: 8),
                  Text(
                    'Hold to pause',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
      },
    );
  }
}

