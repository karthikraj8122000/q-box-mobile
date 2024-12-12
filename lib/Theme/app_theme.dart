import 'package:flutter/material.dart';
import 'package:qbox_app/Theme/app_text_theme.dart';
import 'package:qbox_app/Widgets/Common/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.lightScaffoldBackgroundColor,
    primaryColor: AppColors.lightPrimaryColor,
    brightness: Brightness.light,
    // textTheme: AppTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.lightBackgroundColor,
        foregroundColor: AppColors.darkPrimaryVariantColor,
        actionsIconTheme:
            IconThemeData(color: AppColors.darkPrimaryVariantColor),
        iconTheme: IconThemeData(color: AppColors.darkPrimaryVariantColor)),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.blue, // Default background color
      //       foregroundColor: Colors.white, // Default text/icon color
      //       textStyle: const TextStyle(fontSize: 16),
      //       padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
      //     // Default text style
      //   ),
      // )
  );

  static final darkTheme = ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.darkPrimaryVariantColor,
      primaryColor: AppColors.darkPrimaryColor,
      brightness: Brightness.dark,
      // textTheme: AppTextTheme.darkTextTheme,
      appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.lightBackgroundColor,
          foregroundColor: AppColors.darkPrimaryVariantColor,
          actionsIconTheme:
              IconThemeData(color: AppColors.darkPrimaryVariantColor),
          iconTheme: IconThemeData(color: AppColors.darkPrimaryVariantColor)),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: Colors.blue, // Default background color
      //     foregroundColor: Colors.white, // Default text/icon color
      //     textStyle: const TextStyle(fontSize: 16),
      //       padding: EdgeInsets.symmetric(vertical: 16,horizontal: 24),
      //   ),
      // )
  );
}
