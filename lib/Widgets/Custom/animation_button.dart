import 'package:flutter/material.dart';

class GradientWiperButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const GradientWiperButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  _GradientWiperButtonState createState() => _GradientWiperButtonState();
}

class _GradientWiperButtonState extends State<GradientWiperButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.withOpacity(1 - _animation.value), Colors.purple.withOpacity(1 - _animation.value)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 18))),
              );
            },
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ],
      ),
    );
  }
}