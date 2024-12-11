import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final TextStyle? fontStyle;
 final TextStyle? style;

  const AppText({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign,
    this.fontStyle,
    this.style
  });

  @override
  Widget build(BuildContext context) {

     TextStyle textStyle = style ?? Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize);
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle,
    );
  }
}