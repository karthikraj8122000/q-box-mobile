import 'package:flutter/material.dart';
import 'package:qbox/Theme/app_theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextStyle? fontStyle;
 final TextStyle? style;

  const AppText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.fontStyle,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(fontSize: fontSize,color: color),
    );
  }
}