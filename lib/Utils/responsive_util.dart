import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  // Singleton pattern
  static final ResponsiveUtils _instance = ResponsiveUtils._internal();
  factory ResponsiveUtils() => _instance;
  ResponsiveUtils._internal();

  // Get screen info
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= _mobileBreakpoint &&
          MediaQuery.of(context).size.width < _tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _tabletBreakpoint;

  // Get dimensions
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Get orientation
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Get responsive value based on screen size
  static double getResponsiveValue({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    }
    return const EdgeInsets.all(8.0);
  }

  // Get number of grid columns based on screen size
  static int getResponsiveGridCount(BuildContext context) {
    if (isDesktop(context)) {
      return 4;
    } else if (isTablet(context)) {
      return 3;
    } else if (isLandscape(context)) {
      return 2;
    }
    return 1;
  }

  // Get responsive widget based on screen size
  static Widget buildResponsiveWidget({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

// Example usage with a responsive list/grid view
class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsets? padding;

  const ResponsiveListView({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.buildResponsiveWidget(
      context: context,
      // Mobile view (List)
      mobile: ListView.separated(
        padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      ),
      // Tablet/Desktop view (Grid)
      tablet: GridView.builder(
        padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getResponsiveGridCount(context),
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}