import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Features/Screens/MainPage/Order/outward_delivery_history.dart';
import 'package:qr_page/Theme/app_theme.dart';
import 'package:qr_page/Widgets/Common/network_error.dart';
import '../../../../Model/Data_Models/Food_item/foot_item_model.dart';
import '../../../../Provider/food_store_provider.dart';
import '../../../../Provider/order/order_card.dart';
import '../../../../Widgets/Custom/custom_modern_tabbar.dart';
import '../Order/order_history_card.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<TabItem> _tabItems;
  List purchaseOrder = [];

  @override
  void initState() {
    super.initState();
    _tabItems = [
      TabItem(title: 'Inward Order', icon: Icons.arrow_downward),
      TabItem(title: 'Outward Order', icon: Icons.arrow_upward),
    ];
    _tabController = TabController(length: _tabItems.length, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);

    return NetworkWrapper(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('Order History', style: TextStyle(color: Colors.black),),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.black),
                onPressed: () => _showFilterBottomSheet(context, provider),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 16),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    InwardOrdersList(),
                    // _buildBody(context, provider),
                    OutwardOrdersList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget InwardOrdersList(){
    return OrderHistoryCard();
  }

  Widget OutwardOrdersList(){
    return OutwardOrderHistoryCard();
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ModernTabBar(
        controller: _tabController,
        tabItems: _tabItems,
        onTap: (index) {
          print('Tapped on tab $index');
        },
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildBody(BuildContext context, FoodStoreProvider provider) {
    final sortedItems = provider.getSortedDispatchedItems();
    return sortedItems.isEmpty
        ? _buildEmptyState(context)

        :ListView.builder(
      itemCount: purchaseOrder.length,
      itemBuilder: (context, index) {
        return OrderCard(order:purchaseOrder[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No order history',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDispatchedItemsGrid(BuildContext context, List<FoodItem> items) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return isTablet? GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of columns
        childAspectRatio:2.2,  // Adjust this value to control card height
        crossAxisSpacing: 16,  // Horizontal spacing between cards
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          elevation: 4,
          child: InkWell(
            onTap: () => _showItemDetails(context, item),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.appTheme.withOpacity(0.2),
                        child: Icon(
                          Icons.local_shipping,
                          color: AppTheme.appTheme,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.black
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Unique Code
                  Text(
                    item.uniqueCode,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  // Container Number
                  Text(
                    'Container: ${item.boxCellSno}',
                    style: TextStyle(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  // Dispatch Date
                  Text(
                    'Unloaded at:\n${DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate)}',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ):Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              elevation: 4,
              child: InkWell(
                onTap: () => _showItemDetails(context, item),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.appTheme.withOpacity(0.2),
                            child: Icon(
                              Icons.local_shipping,
                              color: AppTheme.appTheme,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.black
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Unique Code
                      Text(
                        item.uniqueCode,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),

                      // Container Number
                      Text(
                        'Container: ${item.boxCellSno}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),

                      // Dispatch Date
                      Text(
                        'Unloaded at:\n${DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate)}',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _showFilterBottomSheet(BuildContext context, FoodStoreProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter and Sort',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.appTheme,
                    ),
                  ),
                  SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: provider.sortBy,
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                    ),
                    items: provider.sortOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setModalState(() {
                          provider.setSortBy(newValue);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ascending Order'),
                      Switch(
                        value: provider.isAscending,
                        onChanged: (bool value) {
                          setModalState(() {
                            provider.toggleSortOrder();
                          });
                        },
                        activeColor: AppTheme.appTheme,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context, provider),
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(
                      provider.startDate == null || provider.endDate == null
                          ? 'Select Date Range'
                          : '${DateFormat('MMM dd, yyyy').format(provider.startDate!)} - ${DateFormat('MMM dd, yyyy').format(provider.endDate!)}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appTheme,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      provider.resetFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Reset Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDateRange(BuildContext context, FoodStoreProvider provider) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: provider.startDate != null && provider.endDate != null
          ? DateTimeRange(start: provider.startDate!, end: provider.endDate!)
          : null,
    );

    if (picked != null) {
      provider.setDateRange(picked.start, picked.end);
    }
  }

  void _showItemDetails(BuildContext context, FoodItem item) {
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
              _buildDetailRow('Food Item', item.uniqueCode),
              _buildDetailRow('Qbox ID', item.boxCellSno),
              _buildDetailRow(
                'Unloaded Date',
                DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate),
              ),
            ],
          ),
        );
      },
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
}