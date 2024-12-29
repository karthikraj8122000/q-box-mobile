import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import '../../../../Model/Data_Models/dashboard_model/dashboard_model.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Custom/scrolling_text.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  String entityName = "10 Mins Delivery Nungambakkam";
  late final QBoxSettings qboxSettings;
  // late AnimationController _controller;
  Animation<double>? _animation;

  // Add new animation controller for header
  late AnimationController _headerController;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> rawSettings = {
      "qboxEntityName": "10 Mins Delivery Nungambakkam",
      "rowCount": 2,
      "columnCount": 4,
      "qboxes": [
        {
          "foodName": "Briyani",
          "qboxId": 1,
          "foodCode": "BR01",
          "foodImage": "assets/biriyani.jpg",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Chicken Rice",
          "qboxId": 2,
          "foodCode": "SM01",
          "foodImage": "assets/friedrice.png",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Dosa",
          "qboxId": 3,
          "foodCode": "DS01",
          "foodImage": "assets/biriyani.jpg",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Idli",
          "qboxId": 4,
          "foodCode": "ID01",
          "foodImage": "assets/friedrice.png"
        },
        {
          "foodName": "Empty",
          "qboxId": 5,
          "foodCode": "empty",
          "foodImage": "assets/empty.png",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Empty",
          "qboxId": 6,
          "foodCode": "empty",
          "foodImage": "assets/empty.png",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Chicken Rice",
          "qboxId": 7,
          "foodCode": "SM02",
          "foodImage": "assets/friedrice.png",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Dosa",
          "qboxId": 8,
          "foodCode": "DS02",
          "foodImage": "assets/biriyani.jpg",
          "createdAt": "1 hour ago"
        },
        {
          "foodName": "Dosa",
          "qboxId": 9,
          "foodCode": "DS03",
          "foodImage": "assets/biriyani.jpg",
          "createdAt": "1 hour ago"
        },
      ]
    };
    qboxSettings = QBoxSettings.fromMap(rawSettings);

    // Initialize header animation
    _headerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? selectedItem;

  void _showEmptyItemDetails(BuildContext context, QBox item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Qbox ID ${item.qboxId} is empty!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.appTheme,
                ),
              ),
              Text(
                'There is no food item map for qbox cell ${item.qboxId}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showItemDetails(BuildContext context, QBox item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Item Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.appTheme,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Food Name', item.foodName),
              _buildDetailRow('Qbox ID', item.qboxId.toString()),
              _buildDetailRow('Sku Code', item.foodCode),
              _buildDetailRow('Created at', item.storageDate.toString()
                  // DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate),
                  ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ScrollingText(text: qboxSettings?.qboxEntityName ?? "Default Entity Name"),
              // _buildHeader(
              //     qboxSettings?.qboxEntityName ?? "Default Entity Name"),
              _buildCurrentTime(),
              _buildInventoryTable(),
              _buildQeuBoxStatus(),
              _buildHotBoxStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Updated header with sliding animation
  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      color: AppColors.mintGreen,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCurrentTime() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Current Inventory - ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
      ),
    );
  }

  // Redesigned inventory table
  Widget _buildInventoryTable() {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text('Item',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    child: Text('In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    child: Text('Out',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    child: Text('Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          _buildInventoryRow('Briyani', '44', '91', '135', isEven: true),
          _buildInventoryRow('Sambar', '40', '85', '125', isEven: false),
          _buildInventoryRow('Chicken Rice', '30', '70', '100', isEven: true),
          _buildInventoryRow('Dosa', '25', '60', '85', isEven: false),
        ],
      ),
    );
  }

  Widget _buildInventoryRow(
      String item, String inCount, String outCount, String total,
      {required bool isEven}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: isEven ? Colors.grey.shade50 : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(item,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(inCount, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(outCount, textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(
              total,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQeuBoxStatus() {
    final int totalCells =
        (qboxSettings?.rowCount ?? 0) * (qboxSettings?.columnCount ?? 0);

    final List<QBox> allCells = List.generate(totalCells, (index) {
      if (index < (qboxSettings?.qboxes?.length ?? 0)) {
        return qboxSettings!.qboxes[index];
      } else {
        return QBox(
            foodName: "Empty",
            qboxId: index,
            foodCode: "empty",
            foodImage: "assets/empty.png");
      }
    });

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade400, Colors.red.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'QBox - Current Status',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: qboxSettings.columnCount * 180.0,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: qboxSettings.columnCount ?? 3,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final cell = allCells[index];
                final bool isEmpty = cell.foodName == 'Empty';
                return _buildGridCell(cell);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: _buildItemCount(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Enhanced QBox grid cell
  Widget _buildGridCell(QBox item) {
    bool isFilled = item.foodName != 'Empty';
    return InkWell(
      onTap: () {
        if (isFilled) {
          _showItemDetails(context, item);
        } else {
          _showEmptyItemDetails(context, item);
        }
      },
      child: AnimatedBuilder(
        animation: _animation ?? const AlwaysStoppedAnimation<double>(0),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isFilled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.red.shade100,
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                  color: isFilled
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isFilled ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(item.foodImage),
                            backgroundColor:
                                isFilled ? Colors.white : Colors.grey.shade200,
                          ),
                          SizedBox(height: 8),
                          Text(
                            item.foodName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isFilled ? Colors.black87 : Colors.grey,
                            ),
                          ),
                          if (isFilled) ...[
                            SizedBox(height: 4),
                            Text(
                              'ID: ${item.qboxId} | SKU: ${item.foodCode}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ] else ...[
                            SizedBox(height: 4),
                            Text(
                              'ID: ${item.qboxId}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCount() {
    Map<String, int> foodCounts = {};
    for (var box in qboxSettings.qboxes) {
      foodCounts[box.foodName] = (foodCounts[box.foodName] ?? 0) + 1;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Food Item Counts:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mintGreen,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodCounts.length,
              itemBuilder: (context, index) {
                final entry = foodCounts.entries.elementAt(index);
                return Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Hot Box status
  Widget _buildHotBoxStatus() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade400, Colors.red.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Hot Box - Current Status',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHotBoxProgressBar('Briyani', 36, 100),
                SizedBox(height: 12),
                _buildHotBoxProgressBar('Sambar', 28, 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHotBoxProgressBar(String item, int current, int total) {
    final percentage = (current / total * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '$current/$total',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 70 ? Colors.green : Colors.red,
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}
