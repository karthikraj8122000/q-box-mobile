import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Theme/app_theme.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';

import '../../../../Model/Data_Models/Food_item/foot_item_model.dart';
import '../../../../Provider/food_store_provider.dart';

class DispatchHistoryScreen extends StatelessWidget {
  const DispatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoodStoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: AppText(text: 'Dispatch History',fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold,),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () => _showFilterBottomSheet(context, provider),
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, FoodStoreProvider provider) {
    final sortedItems = provider.getSortedDispatchedItems();
    return sortedItems.isEmpty
        ? _buildEmptyState()
        : _buildDispatchedItemsList(context, sortedItems);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No Dispatched Items',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Dispatched items will appear here',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 1500.ms)
          .then(),
    );
  }

  Widget _buildDispatchedItemsList(BuildContext context, List<FoodItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.appTheme.withOpacity(0.2),
                child: Icon(
                  Icons.local_shipping,
                  color: AppTheme.appTheme,
                ),
              ),
              title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  item.uniqueCode,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Container: ${item.boxCellSno}'),
                  Text(
                    'Dispatched: ${DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.black),
                child: Icon(
                  Icons.chevron_right,
                  color:Colors.white,
                ),
              ),
              onTap: () => _showItemDetails(context, item),
            ),
          ),
        );
      },
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
                'Dispatched Date',
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