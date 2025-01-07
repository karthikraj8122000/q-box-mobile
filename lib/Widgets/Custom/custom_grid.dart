import 'package:flutter/material.dart';

class DynamicGrid extends StatelessWidget {
  final int rowCount;
  final int columnCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const DynamicGrid({
    Key? key,
    required this.rowCount,
    required this.columnCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        // Calculate the ideal cell size
        double cellWidth = maxWidth / columnCount;
        double cellHeight = maxHeight / rowCount;

        // Determine if we need to scroll
        bool needsHorizontalScroll = cellWidth * columnCount > maxWidth;

        // Adjust cellWidth if we need to scroll
        if (needsHorizontalScroll) {
          cellWidth = maxWidth / 3; // Show at least 3 columns
        }

        // Calculate childAspectRatio
        double childAspectRatio = cellWidth / cellHeight;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: cellWidth * columnCount,
            height: maxHeight,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: rowCount * columnCount,
              itemBuilder: itemBuilder,
            ),
          ),
        );
      },
    );
  }
}
