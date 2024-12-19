import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_page/Theme/app_theme.dart';

import '../../../../Model/Data_Models/Food_item/foot_item_model.dart';
import '../../../../Provider/food_retention_provider.dart';

class DispatchHistoryScreen extends StatefulWidget {
  const DispatchHistoryScreen({super.key});

  @override
  _DispatchHistoryScreenState createState() => _DispatchHistoryScreenState();
}

class _DispatchHistoryScreenState extends State<DispatchHistoryScreen> {
  // Filtering and Sorting
  String _sortBy = 'Date';
  bool _isAscending = false;
  DateTime? _startDate;
  DateTime? _endDate;

  // Sorting Options
  final List<String> _sortOptions = [
    'Date',
    'Food Item Name',
    'Container ID'
  ];

  // Date Range Picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  List<FoodItem> _getSortedDispatchedItems(List<FoodItem> items) {
    var sortedItems = List<FoodItem>.from(items);
    switch (_sortBy) {
      case 'Date':
        sortedItems.sort((a, b) => a.storageDate.compareTo(b.storageDate));
        break;
      case 'Food Item Name':
        sortedItems.sort((a, b) => a.boxCellSno.compareTo(b.boxCellSno));
        break;
      case 'Container ID':
        sortedItems.sort((a, b) => a.uniqueCode.compareTo(b.uniqueCode));
        break;
    }
    return _isAscending ? sortedItems : sortedItems.reversed.toList();
  }

  // Filter Items by Date Range
  List<FoodItem> _filterItemsByDateRange(List<FoodItem> items) {
    if (_startDate == null || _endDate == null) return items;

    return items.where((item) {
      return item.storageDate.isAfter(_startDate!) &&
          item.storageDate.isBefore(_endDate!.add(Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispatch History',style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.appTheme,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list,color: Colors.white,),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
      body: Consumer<FoodRetentionProvider>(
        builder: (context, provider, child) {
          // Get and filter dispatched items
          var dispatchedItems = _filterItemsByDateRange(provider.dispatchedItems);
          var sortedItems = _getSortedDispatchedItems(dispatchedItems);

          return sortedItems.isEmpty
              ? _buildEmptyState()
              : _buildDispatchedItemsList(sortedItems);
        },
      ),
    );
  }

  // Empty State Widget
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

  // Dispatched Items List
  Widget _buildDispatchedItemsList(List<FoodItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
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
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
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
            trailing: Icon(
              Icons.chevron_right,
              color: AppTheme.appTheme,
            ),
            onTap: () => _showItemDetails(item),
          ),
        );
      },
    );
  }

  // Show Item Details Bottom Sheet
  void _showItemDetails(FoodItem item) {
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
              _buildDetailRow('Container ID', item.boxCellSno),
              _buildDetailRow('Dispatched Date',
                  DateFormat('MMM dd, yyyy HH:mm').format(item.storageDate)
              ),
            ],
          ),
        );
      },
    );
  }

  // Build Detail Row for Bottom Sheet
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

  // Filter Bottom Sheet
  void _showFilterBottomSheet() {
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

                  // Sort By Dropdown
                  DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                    ),
                    items: _sortOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setModalState(() {
                        _sortBy = newValue!;
                      });
                      setState(() {
                        _sortBy = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Sort Order Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ascending Order'),
                      Switch(
                        value: _isAscending,
                        onChanged: (bool value) {
                          setModalState(() {
                            _isAscending = value;
                          });
                          setState(() {
                            _isAscending = value;
                          });
                        },
                        activeColor: AppTheme.appTheme,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: Icon(Icons.calendar_today,color: Colors.white,),
                    label: Text(
                      _startDate == null || _endDate == null
                          ? 'Select Date Range'
                          : '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appTheme,
                      foregroundColor: Colors.white
                    ),
                  ),
                  SizedBox(height: 16),
                  // Reset Filters Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sortBy = 'Date';
                        _isAscending = false;
                        _startDate = null;
                        _endDate = null;
                      });
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
}