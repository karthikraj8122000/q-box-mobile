import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../Theme/app_theme.dart';

class RevolveAroundCardAnimation extends StatefulWidget {
  final Widget child;
  final bool isHighlighted;

  const RevolveAroundCardAnimation({
    super.key,
    required this.child,
    this.isHighlighted = false
  });

  @override
  _RevolveAroundCardAnimationState createState() => _RevolveAroundCardAnimationState();
}

class _RevolveAroundCardAnimationState extends State<RevolveAroundCardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Adjust speed as needed
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void didUpdateWidget(RevolveAroundCardAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Stop or start animation based on highlighted state
    if (!widget.isHighlighted) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isHighlighted) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            widget.child,
            // Small circular indicator revolving around the card
            Positioned(
              child: Transform.translate(
                offset: Offset(
                    math.cos(_rotationAnimation.value) * 150,
                    math.sin(_rotationAnimation.value) * 50
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppTheme.appTheme,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
