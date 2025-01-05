import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Model/Data_Models/dashboard_model/dashboard_model.dart';
import 'package:qr_page/Provider/dashboard_provider.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import '../../../../Theme/app_theme.dart';
import 'inventory_table.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {

  Animation<double>? _animation;
  late List<dynamic> qboxLists = [];
  late final qboxCount;

  var inventoryData;
  var foodCountData;
  int skuInventoryCount = 0;
  int rowCount = 0;
  int columnCount = 0;

  late DashboardProvider _provider;
  // Add new animation controller for header
  late AnimationController _headerController;
  List<InventoryItem> inventoryItems = [];
  bool isLoading = true;

  Future<void> loadInventoryData() async {
    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Simulate API call with your test data
      const String jsonData = '''
        [
          {
            "skuCode": "SIVMLS",
             "inCount": 1,
            "outCount": 0,
            "totalCount": 1,
            "description": "A2B South Indian Veg Meals"
          },
          {
            "skuCode": "CHBRYNI",
             "inCount": 2,
            "outCount": 0,
            "totalCount": 2,
            "description": "Star Chicken Briyani"
          }
        ]
      ''';

      final List<dynamic> decodedData = json.decode(jsonData);

      if (mounted) {
        setState(() {
          inventoryItems = decodedData
              .map((item) => InventoryItem.fromJson(Map<String, dynamic>.from(item)))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          inventoryItems = []; // Reset to empty list on error
        });
      }
      print('Error loading inventory data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load inventory data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> refreshInventoryData() async {
    await loadInventoryData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _headerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _headerController.forward();
  }

  Future<void> _loadData() async {
    await loadInventoryData();
    if (!mounted) return;

    final provider = Provider.of<DashboardProvider>(context, listen: false);
    await provider.getQboxes();
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
              _buildDetailRow('Sku Code', item.foodCode.isNotEmpty ? item.foodCode : '--'),
              _buildDetailRow('Created at', item.storageDate.toString()),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider,child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen,));
        }
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.error!),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintGreen),
                  onPressed: _loadData,
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (provider.qboxLists.isNotEmpty) {
          var firstItem = provider.qboxLists.isNotEmpty ? provider.qboxLists[0] : null;
          var secondItem = provider.qboxLists.length > 1 ? provider.qboxLists[1] : null;
    
          if (firstItem is Map<String, dynamic>) {
            foodCountData = firstItem;
            skuInventoryCount = int.tryParse(foodCountData['skuInventorySnoCount']?.toString() ?? '0') ?? 0;
          }
    
          if (secondItem is Map<String, dynamic>) {
            inventoryData = secondItem;
            qboxLists = inventoryData['qboxes'] as List<dynamic>? ?? [];
            rowCount = int.tryParse(inventoryData["rowCount"]?.toString() ?? '0') ?? 0;
            columnCount = int.tryParse(inventoryData["columnCount"]?.toString() ?? '1') ?? 1;
          }
        }
    
        return NetworkWrapper(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.mintGreen,
                automaticallyImplyLeading: false,
                title: Align(
                    alignment: Alignment.center,
                    child: AppText(
                        text: inventoryData?['qboxEntityName'] ?? "Entity",
                        fontSize: 16)),
              ),
              body: RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCurrentTime(),
                      _buildInventoryTable(),
                      _buildQeuBoxStatus(),
                      _buildHotBoxStatus(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
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
        'Current Inventory - ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
      ),
    );
  }

  // Redesigned inventory table
  Widget _buildInventoryTable() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (inventoryItems.isEmpty) {
      return Center(
        child: Text(
          'No inventory items available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return InventoryTableWidget(inventoryItems: inventoryItems);
  }

  Widget _buildQeuBoxStatus() {
    final int totalCells =
        (rowCount) * (columnCount);
    print('totalCells$totalCells');

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
            width: columnCount * 180.0,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount > 0 ? columnCount : 1,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final cell = qboxLists[index];
                if (cell != null) {
                  // Convert the Map to QBox
                  QBox qbox = QBox.fromMap(cell as Map<String, dynamic>);
                  return _buildGridCell(qbox);
                } else {
                  return Container(); // Placeholder for invalid cell
                }
              },
            ),

          ),
        ),
        _buildItemCount(),
        SizedBox(height: 20),
      ],
    );
  }

  // Enhanced QBox grid cell
  Widget _buildGridCell(QBox item) {
    bool isFilled = item.foodName != 'EMPTY';
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
                          isFilled ?CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/biriyani.jpg"),
                        backgroundColor: isFilled
                            ? Colors.white
                            : Colors.grey.shade200,
                      ):Image.asset("assets/empty.png"),


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
                              'ID: ${item.qboxId}',
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
    final int totalVisibleCells = rowCount * columnCount;

    for (int i = 0; i < totalVisibleCells && i < qboxLists.length; i++) {
      var boxData = qboxLists[i];
      String foodName = boxData['foodName'];
      if (foodName.isNotEmpty) {
        foodCounts[foodName] = (foodCounts[foodName] ?? 0) + 1;
      }
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
