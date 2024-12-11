import 'package:flutter/material.dart';

import '../Widgets/Common/app_colors.dart';

class AppTextTheme extends TextTheme {
  static const TextTheme lightTextTheme = TextTheme(
    titleMedium: lightScreenTaskNameTextStyle,
    bodyLarge: lightScreenTaskNameTextStyle,
    bodyMedium: lightScreenTaskDurationTextStyle,
    labelLarge: lightScreenLabelTextStyle,
  );

  static final TextTheme darkTextTheme = TextTheme(
    titleMedium: darkScreenTaskNameTextStyle,
    bodyLarge: darkScreenTaskNameTextStyle,
    bodyMedium: darkScreenTaskDurationTextStyle,
    labelLarge: darkScreenLabelTextStyle.copyWith(color: Colors.white), // Change label color to white
  );

  static const TextStyle lightScreenHeadingTextStyle = TextStyle(
    fontSize: 40.0,
  );
  static const TextStyle lightScreenTaskNameTextStyle = TextStyle(
    fontSize: 17.0,
  );
  static const TextStyle lightScreenTaskDurationTextStyle = TextStyle(
    fontSize: 14,
  );

  static const TextStyle lightScreenLabelTextStyle = TextStyle(
    fontSize: 40.0,
  );

  static final TextStyle darkScreenTaskNameTextStyle =
  lightScreenTaskNameTextStyle.copyWith(color: Colors.white);

  static final TextStyle darkScreenLabelTextStyle =
  lightScreenLabelTextStyle.copyWith(color: Colors.white);

  static const TextStyle darkScreenTaskDurationTextStyle = lightScreenTaskDurationTextStyle;
}
