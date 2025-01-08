import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Model/Data_Models/dashboard_model/dashboard_model.dart';
import 'package:qr_page/Model/dummy_model.dart';
import 'package:qr_page/Provider/dashboard_provider.dart';
import 'package:qr_page/Services/toast_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import '../../../../Provider/auth_provider.dart';
import '../../../../Services/auth_service.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Custom/custom_grid.dart';
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
  final CommonService commonService = CommonService();

  var inventoryData;
  var foodCountData;
  int skuInventoryCount = 0;
  int rowCount = 0;
  int columnCount = 0;
  String entityName = '';
  int totalCellCount = 0;

  late DashboardProvider _provider;
  // Add new animation controller for header
  late AnimationController _headerController;
  List<InventoryItem> inventoryItems = [];
  bool isLoading = true;
  final _authService = AuthService();

  final Map<String, dynamic> staticData = {
    "data": {
      "qboxCounts": [
        {"description": "EMPTY", "skuInventorySnoCount": 1},
      ],
      "qboxInventory": {
        "qboxes": [
          {
            "rowNo": 1,
            "qboxId": 164,
            "columnNo": 1,
            "foodCode": "MAA-SWG-A2B-SIVM-20240505-93-004",
            "foodName": "EMPTY"
          },
          {
            "rowNo": 1,
            "qboxId": 165,
            "columnNo": 2,
            "foodCode": null,
            "foodName": "EMPTY"
          },
        ],
        "rowCount": "2",
        "columnCount": "2",
        "qboxEntityName": "10 mins Adyar"
      }
    }
  };

  void _initializeStaticData() {
    final inventoryData = staticData['data']['qboxInventory'];
    qboxLists = inventoryData['qboxes'] as List<dynamic>;
    rowCount = int.parse(inventoryData['rowCount']);
    columnCount = int.parse(inventoryData['columnCount']);
    entityName = inventoryData['qboxEntityName'];
  }

  Future<void> loadInventoryData() async {
    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
      });

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
              .map((item) =>
              InventoryItem.fromJson(Map<String, dynamic>.from(item)))
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
      commonService
          .presentToast('Failed to load inventory data: ${e.toString()}');
    }
  }

  Future<void> refreshInventoryData() async {
    await loadInventoryData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeStaticData();
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
              _buildDetailRow(
                  'Sku Code', item.foodCode.isNotEmpty ? item.foodCode : '--'),
              _buildDetailRow('Created at', item.storageDate.toString()),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mintGreen,
            ));
      }
      if (provider.error != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider.error!),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mintGreen),
                onPressed: _loadData,
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }
      if (provider.qboxLists.isNotEmpty) {
        var firstItem =
        provider.qboxLists.isNotEmpty ? provider.qboxLists[0] : null;
        var secondItem =
        provider.qboxLists.length > 1 ? provider.qboxLists[1] : null;

        if (firstItem is Map<String, dynamic>) {
          foodCountData = firstItem;
          skuInventoryCount = int.tryParse(
              foodCountData['skuInventorySnoCount']?.toString() ?? '0') ??
              0;
        }

        if (secondItem is Map<String, dynamic>) {
          inventoryData = secondItem;
          qboxLists = inventoryData['qboxes'] as List<dynamic>? ?? [];
          rowCount =
              int.tryParse(inventoryData["rowCount"]?.toString() ?? '0') ?? 0;
          columnCount =
              int.tryParse(inventoryData["columnCount"]?.toString() ?? '1') ??
                  1;
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
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  )),
              actions: [
                // Wrap your IconButton with this code
                IconButton(
                  icon: const Icon(Icons.logout_sharp),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Are you sure you want to logout?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          GoRouter.of(context)
                                              .push(LoginScreen.routeName);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
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
    });
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

    return InventoryTableWidget(inventoryItems: inventoryItems)
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.2, end: 0);
  }


  Widget _buildQeuBoxStatus() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final qboxInventory = staticData['data']['qboxInventory'];
    final rowCount = int.parse(qboxInventory['rowCount']);
    final columnCount = int.parse(qboxInventory['columnCount']);
    final entityName = qboxInventory['qboxEntityName'];
    final qboxes = qboxInventory['qboxes'] as List<dynamic>;

    final cellWidth =
        (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 1.2;
    final fontSize = cellWidth * 0.12;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade400, Colors.red.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'QBox - Current Status ($entityName)',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: cellWidth / cellHeight,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: rowCount * columnCount,
            itemBuilder: (context, index) {
              final qboxData = qboxes.firstWhere(
                    (qbox) =>
                qbox['rowNo'] == (index ~/ columnCount + 1) &&
                    qbox['columnNo'] == (index % columnCount + 1),
                orElse: () => {
                  'rowNo': index ~/ columnCount + 1,
                  'columnNo': index % columnCount + 1,
                  'foodName': 'EMPTY',
                  'qboxId': -1
                },
              );
              final QBoxCell qbox = QBoxCell.fromMap(qboxData);
              return _buildGridCell(qbox, cellHeight,fontSize);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGridCell(QBoxCell qbox, double cellHeight,double fontSize) {
    totalCellCount = rowCount * columnCount;
    bool isFilled = qbox.foodCode.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFilled
              ? [Colors.green.shade300, Colors.green.shade800]
              : [Colors.red.shade300, Colors.red.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: isFilled
                ? Colors.green.shade300
                : Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (totalCellCount <= 25) ...[
            Column(
              children: [
                isFilled? Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Change to your desired outline color
                      width: 2.0,          // Adjust the border width as needed
                    ),
                    borderRadius: BorderRadius.circular(100), // Same radius as ClipRRect
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/biriyani.jpg",
                      height: cellHeight * 0.4,
                      width: cellHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ):AppText(text: "EMPTY", fontSize: fontSize,color: AppColors.white,)
              ],
            )
          ] else ...[
          ],
          SizedBox(height: 5,),
          Text('R${qbox.rowNo}-C${qbox.columnNo}',style: TextStyle(color:AppColors.white,fontSize:fontSize),),
          SizedBox(height: 5,),
          Text('${qbox.qboxId}',style: TextStyle(color: AppColors.white,fontSize:fontSize,fontWeight: FontWeight.w800),),
          // Text(qbox.foodCode.isNotEmpty ? qbox.foodCode : 'Empty'),
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
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
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
