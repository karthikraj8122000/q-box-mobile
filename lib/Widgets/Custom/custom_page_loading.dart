import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color shadowColor;
  final Color progressColor;
  final double borderRadius;
  final double blurRadius;
  final double offsetY;

  const LoadingIndicatorWidget({
    Key? key,
    this.message = 'Loading...',
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.progressColor = Colors.green,
    this.borderRadius = 12.0,
    this.blurRadius = 10.0,
    this.offsetY = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.05),
            blurRadius: blurRadius,
            offset: Offset(0, offsetY),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
