import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Features/Screens/MainPage/Dashboard/qbox_grid_widget.dart';
import 'package:qr_page/Model/Data_Models/dashboard_model/dashboard_model.dart';
import 'package:qr_page/Provider/auth_provider.dart';
import 'package:qr_page/Provider/dashboard_provider.dart';
import 'package:qr_page/Services/toast_service.dart';
import 'package:qr_page/Services/token_service.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import 'package:qr_page/Widgets/Custom/hotbox_status_table.dart';
import '../../../../Theme/app_theme.dart';
import '../../../../Widgets/Common/dashboard_header_card.dart';

enum ScreenLayout {
  mobile,
  tablet,
}

class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late List<dynamic> qboxLists = [];
  late final qboxCount;
  final CommonService commonService = CommonService();

  var inventoryData;
  var foodCountData;
  int skuInventoryCount = 0;
  int rowCount = 0;
  int columnCount = 0;
  int totalCellCount = 0;
  late AnimationController _headerController;
  List<InventoryItem> inventoryItems = [];
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TokenService tokenService = TokenService();
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

  ScreenLayout _getScreenLayout(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return ScreenLayout.mobile;
    }
    return ScreenLayout.tablet;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .getCurrentInventoryCount();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DashboardProvider>(context, listen: false).getHotboxCount();
    // });
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
    var user = await tokenService.getUser();
    Map<String, dynamic> userData;
    if (user is String) {
      userData = jsonDecode(user);
      print("userData1$userData");
    } else if (user is Map<String, dynamic>) {
      userData = user;
      print("userData2$userData");
    } else {
      print('Unexpected type for user: ${user.runtimeType}');
      return;
    }

    final qboxEntitySno = userData['qboxEntitySno'] ?? [];
    if (qboxEntitySno != null) {
      await provider.getQboxes(qboxEntitySno);
      await provider.getHotboxCount(qboxEntitySno);
    } else {
      print('No qboxEntitySno found');
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? selectedItem;

  void _showEmptyItemDetails(BuildContext context, Map<String, dynamic> item) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 4), () async {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Qbox ID ${item['qboxId']} is empty!',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.appTheme,
                ),
              ),
              Text(
                'There is no food item map for qbox cell ${item['qboxId']}',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
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

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Future.delayed(Duration(seconds: 4), () async{
        //   Navigator.of(context).pop();
        // });
        return Stack(
          clipBehavior: Clip.none, // This allows the avatar to overflow
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Item Details',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.appTheme,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow('Qbox ID', item['qboxId'].toString()),
                  _buildDetailRow('Location', item['foodName']),
                  _buildDetailRow('Sku Code',
                      item['foodCode'].isNotEmpty ? item['foodCode'] : '--'),
                  // _buildDetailRow('Created at', item['storageDate'].toString()),
                ],
              ),
            ),
            // Positioned CircleAvatar at the top center
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                    item['logo'],
                    width: 80, // Should be 2x the radius
                    height: 80, // Should be 2x the radius
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline,
                        size: 30,
                        color: Colors.red.shade800,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final List<Map<String, dynamic>> recentOrders = [
    {
      'id': '#FD001',
      'restaurentName': 'A2B',
      'items': ['Pepperoni Pizza', 'Coca Cola'],
      'total': 45.99,
      'status': 'Delivered',
      'statusColor': '#0a8c33',
      'time': '12:30 PM',
      'totalItems': 3,
      'imageUrl':
          'https://media.istockphoto.com/id/1407172002/photo/indian-spicy-mutton-biryani-with-raita-and-gulab-jamun-served-in-a-dish-side-view-on-grey.jpg?s=612x612&w=0&k=20&c=sYldtF2E_cSuYioPtcmM15arsnSs2mIgpuAKUDuuGoI='
    },
    {
      'id': '#FD002',
      'restaurentName': 'Geetham',
      'items': ['Veggie Burger', 'French Fries'],
      'total': 32.50,
      'status': 'Pending',
      'statusColor': '#FF6347',
      'time': '1:15 PM',
      'totalItems': 3,
      'imageUrl':
          'https://t3.ftcdn.net/jpg/00/36/35/20/240_F_36352011_mqoIDF2IUy1eGD3gOf6y8gkZ449PiBcK.jpg'
    },
    {
      'id': '#FD003',
      'restaurentName': 'Star Biriyani',
      'items': ['Caesar Salad', 'Iced Tea'],
      'total': 25.99,
      'status': 'In Progress',
      'statusColor': '#FFD700',
      'time': '2:00 PM',
      'totalItems': 3,
      'imageUrl':
          'https://media.istockphoto.com/id/467631905/photo/hyderabadi-biryani-a-popular-chicken-or-mutton-based-dish.jpg?s=612x612&w=0&k=20&c=8O-erNH35y5qHS8i6dbWPi5Xscb40fNBhK6t1VI8GBc='
    },
  ];

  final List<Map<String, dynamic>> outwardOrders = [
    {
      "itemName": "Biriyani",
      "count": "8",
      "itemColor": Colors.orange.shade700,
      "status": "Delivered",
      'imageUrl':
          'https://media.istockphoto.com/id/467631905/photo/hyderabadi-biryani-a-popular-chicken-or-mutton-based-dish.jpg?s=612x612&w=0&k=20&c=8O-erNH35y5qHS8i6dbWPi5Xscb40fNBhK6t1VI8GBc='
    },
    {
      "itemName": "Sambar",
      "count": "12",
      "itemColor": Colors.green,
      "status": "Cancelled",
      'imageUrl':
          'https://t3.ftcdn.net/jpg/00/36/35/20/240_F_36352011_mqoIDF2IUy1eGD3gOf6y8gkZ449PiBcK.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenLayout = _getScreenLayout(context);
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
      // if (provider.qboxLists.isNotEmpty) {
      //   var firstItem =
      //   provider.qboxLists.isNotEmpty ? provider.qboxLists[0] : null;
      //   var secondItem =
      //   provider.qboxLists.length > 1 ? provider.qboxLists[1] : null;
      //   print("secondItem $inventoryData");
      //   if (firstItem is Map<String, dynamic>) {
      //     foodCountData = firstItem;
      //     skuInventoryCount = int.tryParse(
      //         foodCountData['skuInventorySnoCount']?.toString() ?? '0') ??
      //         0;
      //   }
      //
      //   if (secondItem is Map<String, dynamic>) {
      //     inventoryData = secondItem;
      //     print("inventoryData $inventoryData");
      //     qboxLists = inventoryData['qboxes'] as List<dynamic>? ?? [];
      //     rowCount =
      //         int.tryParse(inventoryData["rowCount"]?.toString() ?? '0') ?? 0;
      //     columnCount =
      //         int.tryParse(inventoryData["columnCount"]?.toString() ?? '1') ??
      //             1;
      //   }
      // }

      return NetworkWrapper(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFFF5F7FA),
          body: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader(context, screenLayout),
                      Expanded(
                        child: RefreshIndicator(
                          color: Colors.red,
                          onRefresh: _loadData,
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.all(
                                    screenLayout == ScreenLayout.mobile
                                        ? 16.0
                                        : 20.0),
                                sliver: SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      _buildTopCards(screenLayout),
                                      SizedBox(
                                          height: screenLayout ==
                                                  ScreenLayout.mobile
                                              ? 16
                                              : 24),
                                      _buildMainContent(context, provider),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          endDrawer: Drawer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 20),
                    child: Column(
                      children: [
                        // Profile Image
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipOval(
                            child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqkUYrITWyI8OhPNDHoCDUjGjhg8w10_HRqg&s', // Replace with your image URL
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Phone Number
                        Text(
                          '+1 234 567 8900',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Email
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu Items
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey[700]),
                    title: Text(
                      'Settings',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Add your settings navigation logic here
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _handleLogout();
                    },
                  ),
                  Expanded(
                      child: Container()), // Pushes the logout to the bottom
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _handleLogout() async {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: isTablet ? 300 : MediaQuery.of(context).size.width,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                    Consumer<AuthProvider>(builder: (
                      context,
                      provider,
                      _,
                    ) {
                      return Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            provider.logout();
                            GoRouter.of(context).push(LoginScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                      );
                    })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, DashboardProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQboxStatus(context, provider),
        _buildIRecentOrdersSection(),
        SizedBox(height: 16),
        _buildInventorySection(),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hot Box - Current Status (Over All)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            _buildHotBoxStatus(provider),
          ],
        ),
      ],
    );
  }

  Widget _buildQboxStatus(BuildContext context, DashboardProvider provider) {
    final groupedQboxes = provider.groupedQboxLists;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QBox - Current Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        for (var i = 0; i < groupedQboxes.length; i++) ...[
          Builder(
            builder: (context) {
              int entityInfraSno = groupedQboxes[i].isNotEmpty
                  ? groupedQboxes[i][0]['EntityInfraSno']
                  : 0;
              var qBoxNumberEntry = provider.qBoxNumber.firstWhere(
                (entry) => entry['entityInfraSno'] == entityInfraSno,
                orElse: () =>
                    {'columnCount': '10', 'rowCount': '10'}, // default fallback
              );
              int rowCount =
                  int.tryParse(qBoxNumberEntry['rowCount'] ?? '10') ?? 10;
              int columnCount =
                  int.tryParse(qBoxNumberEntry['columnCount'] ?? '10') ?? 10;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QBox: ($columnCount x $rowCount)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cellWidth =
                          (constraints.maxWidth - ((columnCount - 1) * 8)) /
                              columnCount;
                      final cellHeight = cellWidth * 1.2;
                      final fontSize = cellWidth * 0.12;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount > 0 ? columnCount : 1,
                          childAspectRatio: cellWidth > 0 && cellHeight > 0
                              ? cellWidth / cellHeight
                              : 1.0, // Fallback to 1.0 if calculations fail
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: groupedQboxes[i].length,
                        itemBuilder: (context, index) {
                          return _buildGridCell(
                            context,
                            groupedQboxes[i][index],
                            cellHeight, // Use calculated cell height
                            fontSize, // Fixed font size
                            index,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        ]
      ],
    );
  }

  Widget _buildIRecentOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                    color: Colors.red, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        // SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recentOrders
                .map((order) => _buildRecentOrderCard(order))
                .toList(),
          ),
        )
        // _buildInventoryTable(),
      ],
    );
  }

  Widget _buildRecentOrderCard(Map<String, dynamic> order) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
          padding: EdgeInsets.all(16.0),
          width: isTablet ? 280 : 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30), // Space for the overlapped image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order['id'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  Text(
                    order['time'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['restaurentName'],
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${order['totalItems']} - Items",
                        style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightBlack),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Total: "),
                      Text(
                        '₹${order['total'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          order['statusColor'].replaceAll('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(order['imageUrl'] ??
                      'https://media.istockphoto.com/id/488481490/photo/fish-biryani-with-basmati-rice-indian-food.jpg?s=612x612&w=0&k=20&c=9xEw3VOQSz9TP8yQr60L47uExyKF9kogRhQdlghlC00='), // Add imageUrl to your order map
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridCell(BuildContext context, Map<String, dynamic> qbox,
      double cellHeight, double fontSize, int index) {
    bool isFilled = qbox['foodCode'] != null;
    return InkWell(
      onTap: () {
        if (isFilled) {
          _showItemDetails(context, qbox);
        } else {
          _showEmptyItemDetails(context, qbox);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isFilled ? Color(0xFF2ECC71) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFilled ? Color(0xFF27AE60) : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isFilled
                  ? Color(0xFF2ECC71).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            if (qbox['logo'] != null)
              Positioned(
                top: 2,
                right: 2,
                child: ClipOval(
                  child: Image.network(
                    qbox['logo'],
                    width: cellHeight * 0.3,
                    height: cellHeight * 0.3,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 24,
                        color: Colors.grey),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isFilled)
                    Icon(Icons.remove_circle_outline,
                        color: Colors.red[700], size: fontSize * 1.6),
                  if (isFilled)
                    Icon(Icons.check_circle,
                        color: Colors.white, size: fontSize * 1.6),
                  SizedBox(height: 6),
                  Text(
                    'R${qbox['rowNo']}-C${qbox['columnNo']}',
                    style: TextStyle(
                      color: isFilled ? Colors.white : Colors.grey[800],
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${qbox['qboxId']}',
                    style: TextStyle(
                      color: isFilled
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey[700],
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQBoxEmptyLogo() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final cellWidth =
        (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 0.5;
    return Positioned(
      left: 5,
      top: 5,
      child: Container(
        height: cellHeight * 0.4, // Adjust size as needed
        width: cellHeight * 0.4, // Adjust size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: ClipOval(
            child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.error_outline,
            size: cellHeight * 0.4,
            color: Colors.grey.shade800,
          ),
        )),
      ),
    );
  }

  Widget _buildInventorySection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Inventory',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildInventoryTable(),
        ],
      ),
    );
  }

  Widget _buildTopCards(ScreenLayout layout) {
    return MetricsDashboardCard(
      totalOrders: 1234,
      // totalRevenue: 45678.90,
      activeDeliveries: 56,
      onRefresh: () {
        setState(() {
          // Update your values
        });
      },
    );
  }

  Widget _buildHeader(BuildContext context, ScreenLayout layout) {
    return Container(
      padding: EdgeInsets.all(layout == ScreenLayout.mobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.read<DashboardProvider>().qboxEntityName,
                      style: GoogleFonts.poppins(
                        fontSize: layout == ScreenLayout.mobile ? 20 : 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Last updated: ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: layout == ScreenLayout.mobile ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  _headerController.forward();
                },
              ),
            ],
          ),
        ],
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

  Widget _buildInventoryTable() {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.mintGreen,
          ),
        );
      }

      if (provider.currentInventoryCountList.isEmpty) {
        return Center(
          child: Text(
            'No inventory data available',
            style: GoogleFonts.poppins(),
          ),
        );
      }
      return Table(
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            children: [
              _buildTableHeader('Item Name'),
              _buildTableHeader('In'),
              _buildTableHeader('Out'),
              _buildTableHeader('Total'),
            ],
          ),
          ...provider.currentInventoryCountList
              .map((item) => _buildTableRow(
                    item['description'] ?? '--',
                    item['inCount']?.toString() ?? '0',
                    item['outCount']?.toString() ?? '0',
                    item['totalCount']?.toString() ?? '0',
                  ))
              .toList()
          // _buildTableRow('A2B South Indian Veg Meals', '1', '0', '1'),
        ],
      );
    });
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      String name, String inCount, String outCount, String total) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      children: [
        _buildTableCell(name, isName: true),
        _buildTableCell(inCount),
        _buildTableCell(outCount),
        _buildTableCell(total, isTotal: true),
      ],
    );
  }

  Widget _buildTableCell(String text,
      {bool isName = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: isName || isTotal ? FontWeight.w500 : FontWeight.normal,
          color: isTotal ? Colors.red : null,
        ),
      ),
    );
  }

  Widget _buildQBoxLogo(String imageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final cellWidth =
        (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 0.5;
    return Positioned(
      left: 5,
      top: 5,
      child: Container(
        height: cellHeight * 0.4, // Adjust size as needed
        width: cellHeight * 0.4, // Adjust size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.error_outline,
                  size: 14,
                  color: Colors.red.shade800,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemCount() {
    Map<String, int> foodCounts = {};
    final int totalVisibleCells = rowCount * columnCount;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    for (int i = 0; i < totalVisibleCells && i < qboxLists.length; i++) {
      var boxData = qboxLists[i];
      String foodName = boxData['foodName'];
      if (foodName.isNotEmpty) {
        foodCounts[foodName] = (foodCounts[foodName] ?? 0) + 1;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isTablet ? 18 : 12),
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
                              fontSize: isTablet ? 18 : 12),
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
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildHotBoxStatus(DashboardProvider provider) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.mintGreen,
          ),
        );
      }
      if (provider.hotboxCountList.isEmpty) {
        return Center(
          child: Text("No food items in hotbox"),
        );
      }
      final List<Map<String, dynamic>> flattenedData = [];
      for (var hotel in provider.hotboxCountList) {
        for (var sku in hotel['skuList']) {
          flattenedData.add({
            'restaurantName': hotel['restaurantName'],
            'skuCode': sku['skuCode'],
            'description': sku['description'],
            'hotBoxCount': sku['hotBoxCount']
          });
        }
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.red.shade100),
                  border: TableBorder.all(color: Colors.red.shade200, width: 1),
                  columns: [
                    DataColumn(
                      label: Text(
                        'Restaurant',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SKU',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'In Hot Box Count',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ),
                  ],
                  rows: flattenedData
                      .map((item) => DataRow(cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  item['restaurantName'] ?? '--',
                                  style: TextStyle(color: Colors.black87),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 70),
                                child: Text(
                                  item['skuCode'] ?? '--',
                                  style: TextStyle(color: Colors.black87),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  item['description'] ?? '--',
                                  style: TextStyle(color: Colors.black87),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.green.shade300,
                                        width: 1)),
                                child: Text(item['hotBoxCount'].toString(),
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ]))
                      .toList(),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildHotBoxProgressBar(
      String title, String item, int current, int total) {
    final percentage = (current / total * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "($item)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
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
