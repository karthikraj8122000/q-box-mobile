import 'package:flutter/material.dart';

import '../../../../Widgets/Common/app_colors.dart';
class AppTheme {
  static final ThemeData zomatoInspiredTheme = ThemeData(
    primaryColor: Color(0xFFFF4E4E),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Color(0xFFFF4E4E),
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFFF4E4E),
      primary: Color(0xFFFF4E4E),
      secondary: Color(0xFFFF6B6B),
    ),
  );
}
