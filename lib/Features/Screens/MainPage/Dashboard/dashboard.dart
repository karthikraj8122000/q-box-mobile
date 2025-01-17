import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Features/Screens/Login/second_login.dart';
import 'package:qr_page/Model/Data_Models/dashboard_model/dashboard_model.dart';
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

  Animation<double>? _animation;
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
  final _authService = AuthService();

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
      commonService.presentToast('Failed to load inventory data: ${e.toString()}');
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
        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop();
        });
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
              _buildDetailRow('Qbox ID', item.qboxId.toString()),
              _buildDetailRow('Location', item.foodName),
              _buildDetailRow('Sku Code', item.foodCode.isNotEmpty ? item.foodCode : '--'),
              _buildDetailRow('Created at', item.storageDate.toString()),
            ],
          ),
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
      'totalItems':3,
      'imageUrl':'https://media.istockphoto.com/id/1407172002/photo/indian-spicy-mutton-biryani-with-raita-and-gulab-jamun-served-in-a-dish-side-view-on-grey.jpg?s=612x612&w=0&k=20&c=sYldtF2E_cSuYioPtcmM15arsnSs2mIgpuAKUDuuGoI='
    },
    {
      'id': '#FD002',
      'restaurentName': 'Geetham',
      'items': ['Veggie Burger', 'French Fries'],
      'total': 32.50,
      'status': 'Pending',
      'statusColor': '#FF6347',
      'time': '1:15 PM',
      'totalItems':3,
      'imageUrl':'https://t3.ftcdn.net/jpg/00/36/35/20/240_F_36352011_mqoIDF2IUy1eGD3gOf6y8gkZ449PiBcK.jpg'
    },
    {
      'id': '#FD003',
      'restaurentName': 'Star Biriyani',
      'items': ['Caesar Salad', 'Iced Tea'],
      'total': 25.99,
      'status': 'In Progress',
      'statusColor': '#FFD700',
      'time': '2:00 PM',
      'totalItems':3,
      'imageUrl':'https://media.istockphoto.com/id/467631905/photo/hyderabadi-biryani-a-popular-chicken-or-mutton-based-dish.jpg?s=612x612&w=0&k=20&c=8O-erNH35y5qHS8i6dbWPi5Xscb40fNBhK6t1VI8GBc='
    },
  ];


  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final screenLayout = _getScreenLayout(context);

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
            child:Scaffold(
              backgroundColor: Color(0xFFF5F7FA),
              body: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildHeader(context,screenLayout),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {},
                              child: CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.all(screenLayout == ScreenLayout.mobile ? 16.0 : 20.0),
                                    sliver: SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          _buildTopCards(screenLayout),
                                          SizedBox(height: screenLayout == ScreenLayout.mobile ? 16 : 24),
                                          _buildMainContent(),
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
            ),
          );
        }
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildQBoxStatus(),
        SizedBox(height: 16),
        _buildIRecentOrdersSection(),
        SizedBox(height: 16),
        _buildInventorySection(),
        SizedBox(height: 16),
        _buildOrdersSection(),
        SizedBox(height: 16),
        _buildHotBoxStatus(),
      ],
    );
  }
  Widget _buildOrdersSection() {
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
            'Outward Orders',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildOrderCard('Biryani', '8', Colors.orange.shade700),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildOrderCard('Sambar', '12', Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(String name, String count, Color color) {
    return Card(
      elevation: 5,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    'In Process',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.remove_red_eye_rounded,color: Colors.red,),
              label: Text('View All',style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
        // SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recentOrders.map((order) => _buildRecentOrderCard(order)).toList(),
          ),
        )
        // _buildInventoryTable(),
      ],
    );
  }

  Widget _buildRecentOrderCard(Map<String, dynamic> order) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
          padding: EdgeInsets.all(16.0),
          width: 280,
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
                      fontSize: 16,
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
                  Icon(Icons.restaurant, color: Colors.red,),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['restaurentName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${order['totalItems']} - Items",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
                      color: Color(int.parse(order['statusColor'].replaceAll('#', '0xFF'))),
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
                  image: NetworkImage(order['imageUrl'] ?? 'https://media.istockphoto.com/id/488481490/photo/fish-biryani-with-basmati-rice-indian-food.jpg?s=612x612&w=0&k=20&c=9xEw3VOQSz9TP8yQr60L47uExyKF9kogRhQdlghlC00='), // Add imageUrl to your order map
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQBoxStatus() {
    final int totalCells = (rowCount) * (columnCount);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final cellWidth = (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 1.2; // Maintain a good aspect ratio
    final fontSize = cellWidth * 0.12;
    final count =  columnCount;
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
            'QBox Status',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount > 0 ? columnCount : 1,
              childAspectRatio: cellWidth / cellHeight,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              // final cell = qboxLists[index];
              if (index < qboxLists.length && qboxLists[index] != null) {
                QBox qbox = QBox.fromMap(qboxLists[index] as Map<String, dynamic>);
                return _buildGridCell(qbox, cellHeight, fontSize);
              }

              return const SizedBox.shrink();
            },
          )
        ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Inventory',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_rounded,color: Colors.red,),
                label: Text('Add Item',style: TextStyle(color:Colors.red),),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildInventoryTable(),
        ],
      ),
    );
  }

  Widget _buildTopCards(ScreenLayout layout) {
    return layout == ScreenLayout.mobile
        ? Column(
      children: [
        _buildStatCard(
          'Total Orders',
          '156',
          Icons.shopping_bag_rounded,
          Colors.red,
          Colors.red.shade700,
          [
            _buildStatItem('Completed', '132'),
            _buildStatItem('In Progress', '24'),
          ],
        ),
        SizedBox(height: 16),
        _buildStatCard(
          'Total Revenue',
          '₹45,670',
          Icons.payments_rounded,
          Colors.green,
          Colors.green.shade700,
          [
            _buildStatItem('Cash', '₹25,430'),
            _buildStatItem('Online', '₹20,240'),
          ],
        ),
        SizedBox(height: 16),
        _buildStatCard(
          'Active Deliveries',
          '8',
          Icons.delivery_dining_rounded,
          Colors.orange,
          Colors.orange.shade700,
          [
            _buildStatItem('On Time', '7'),
            _buildStatItem('Delayed', '1'),
          ],
        ),
      ],
    )
        : Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            '156',
            Icons.shopping_bag_rounded,
            Colors.red,
            Colors.red.shade700,
            [
              _buildStatItem('Completed', '132'),
              _buildStatItem('In Progress', '24'),
            ],
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            'Total Revenue',
            '₹45,670',
            Icons.payments_rounded,
            Colors.green,
            Colors.green.shade700,
            [
              _buildStatItem('Cash', '₹25,430'),
              _buildStatItem('Online', '₹20,240'),
            ],
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            'Active Deliveries',
            '8',
            Icons.delivery_dining_rounded,
            Colors.orange,
            Colors.orange.shade700,
            [
              _buildStatItem('On Time', '7'),
              _buildStatItem('Delayed', '1'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, Color backgroundColor, List<Widget> stats) {
    return Card(
      elevation: 5,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[300],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: stats,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[300],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context,ScreenLayout layout) {
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
              if (layout == ScreenLayout.mobile)
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adyar Branch Dashboard',
                      style: GoogleFonts.poppins(
                        fontSize: layout == ScreenLayout.mobile ? 20 : 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Last updated: 12-01-2025 02:26 PM',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: layout == ScreenLayout.mobile ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
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
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
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

  Widget _buildOutwardOrder() {
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
        'Outward Order - In Process',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
      ),
    );
  }

  // Redesigned inventory table
  Widget _buildOutwardTable() {
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

    return OutwardTableWidget().animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget OutwardTableWidget(){
    return Container(
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
                  flex: 2,
                  child: Text('Item',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),
                ),
                Expanded(
                  child: Text('Count',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),

              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:2,
            itemBuilder: (context, index) {
              final provider = Provider.of<DashboardProvider>(context);
              final item = provider.outwardOrderList[index];
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey.shade50 : Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${item['name']}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item['count']}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildCurrentTime() {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: 8),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [Colors.red.shade400, Colors.red.shade600],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black26,
  //           blurRadius: 4,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Text(
  //       'Current Inventory - ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now())}',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //           fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
  //     ),
  //   );
  // }
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
  //
  // Widget _buildInventoryTable() {
  //   if (isLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   }
  //
  //   if (inventoryItems.isEmpty) {
  //     return Center(
  //       child: Text(
  //         'No inventory items available',
  //         style: TextStyle(fontSize: 16, color: Colors.grey),
  //       ),
  //     );
  //   }
  //
  //   return InventoryTableWidget(inventoryItems: inventoryItems).animate()
  //       .fadeIn(duration: 500.ms)
  //       .slideX(begin: 0.2, end: 0);
  // }

  Widget _buildInventoryTable() {
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
        _buildTableRow('A2B South Indian Veg Meals', '1', '0', '1'),
        _buildTableRow('Star Chicken Biryani', '2', '0', '2'),
      ],
    );
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

  TableRow _buildTableRow(String name, String inCount, String outCount, String total) {
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

  Widget _buildTableCell(String text, {bool isName = false, bool isTotal = false}) {
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

  Widget _buildGridCell(QBox qbox, double cellHeight,double fontSize) {
    totalCellCount = rowCount * columnCount;
    bool isFilled = qbox.foodCode.isNotEmpty;
    return InkWell(
      onTap: () {
        if (isFilled) {
          _showItemDetails(context, qbox);
        } else {
          _showEmptyItemDetails(context, qbox);
        }
      },
      child:isFilled? Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green,
          ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade300,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
        ),
        child: Stack(
          children: [
            _buildQBoxLogo(qbox.logo),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (totalCellCount <= 25) ...[
                    Column(
                      children: [
                       Container(
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
                        )
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
            ),
          ],

        ),
      ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5))
        .shake(hz: 2, curve: Curves.easeInOutCubic):Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color:Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
         _buildQBoxEmptyLogo(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (totalCellCount <= 25) ...[
                    Column(
                      children: [
                       Container()
                      ],
                    )
                  ] else ...[
                  ],
                  SizedBox(height: 5,),
                  Text('R${qbox.rowNo}-C${qbox.columnNo}',style: TextStyle(color:AppColors.black,fontSize:fontSize),),
                  SizedBox(height: 5,),
                  Text('${qbox.qboxId}',style: TextStyle(color: AppColors.black,fontSize:fontSize,fontWeight: FontWeight.w800),),
                  // Text(qbox.foodCode.isNotEmpty ? qbox.foodCode : 'Empty'),
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
    final cellWidth = (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 0.5;
    return Positioned(
      left: 5,
      top: 5,
      child: Container(
        height: cellHeight * 0.4, // Adjust size as needed
        width: cellHeight * 0.4,  // Adjust size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child:
        ClipOval(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.error_outline,
              size: cellHeight * 0.4,
              color: Colors.red.shade800,
            ),
          )
        ),
      ),
    );
  }

  Widget _buildQBoxLogo(String imageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final cellWidth = (screenWidth - (padding * 2) - ((columnCount - 1) * 8)) / columnCount;
    final cellHeight = cellWidth * 0.5;
    return Positioned(
      left: 5,
      top: 5,
      child: Container(
        height: cellHeight * 0.4, // Adjust size as needed
        width: cellHeight * 0.4,  // Adjust size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child:
        ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                backgroundColor: Colors.yellow,
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
    ).animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.2, end: 0);
  }

  // Enhanced Hot Box status

  Widget _buildHotBoxStatus() {
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
            'Hot Box Status',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if(provider.isLoading){
                return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen,));
              }
              if(provider.hotboxCountList.isEmpty){
                return Center(
                  child: Text(
                    'No Data Available',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return Container(
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
                      for(int i=0;i<provider.hotboxCountList.length;i++)...[
                        SizedBox(height: 12),
                        provider.hotboxCountList[i]['skuCode']?.isNotEmpty == true ? _buildHotBoxProgressBar(provider.hotboxCountList[i]['description'],provider.hotboxCountList[i]['skuCode'] , provider.hotboxCountList[i]['hotboxCount']??0, 100):Container(),
                      ]
                      // _buildHotBoxProgressBar('Sambar', 28, 100),
                    ],
                  ),
                ),
              );
            },

          ),
        ],
      ),
    );
  }

  Widget _buildHotBoxProgressBar(String title,String item, int current, int total) {
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
