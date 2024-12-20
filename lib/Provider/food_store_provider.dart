import 'package:flutter/material.dart';
import '../Features/Screens/MainPage/storage_screen/storage_screen.dart';
import '../Model/Data_Models/Food_item/foot_item_model.dart';
import '../Services/api_service.dart';
import '../Services/toast_service.dart';
import '../Theme/app_theme.dart';

class FoodStoreProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();

  // State variables
  final List<FoodItem> _storedItems = [];
  final List<FoodItem> _dispatchedItems = [];

  // Storage Screen Variables
  String? _qboxId;
  String? _foodItem;
  bool _isProcessingScan = false;

  // Dispatch History Screen Variables
  String _sortBy = 'Date';
  bool _isAscending = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _buttonLoading = false;
  final List<String> sortOptions = ['Date', 'Food Item Name', 'Qbox ID'];

  // Dispatch Screen Variables
  String? _scannedDispatchItem;

  // Getters
  List<FoodItem> get storedItems => _storedItems;
  List<FoodItem> get dispatchedItems => _dispatchedItems;
  String? get qboxId => _qboxId;
  String? get foodItem => _foodItem;
  bool get isProcessingScan => _isProcessingScan;
  String get sortBy => _sortBy;
  bool get isAscending => _isAscending;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String? get scannedDispatchItem => _scannedDispatchItem;
  bool get buttonLoading => _buttonLoading;
  // Storage Screen Methods

  void setQboxId(String? id) {
    _qboxId = id;
    notifyListeners();
  }

  void debugPrint(String message) {
    print("FoodStoreProvider: $message");
  }


  void setFoodItem(String? item) {
    _foodItem = item;
    notifyListeners();
  }

  void clearStorageInputs() {
    _qboxId = null;
    _foodItem = null;
    notifyListeners();
  }

  Future<void> scanContainer(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: true),
    );

    if (result != null) {
      _qboxId = result;
      _foodItem = null;
      notifyListeners();
    }
  }

  Future<void> scanFoodItem(BuildContext context) async {
    if (qboxId == null || qboxId!.isEmpty) {
      commonService.presentToast('Please scan QBox ID first',
          backgroundColor: Colors.red);
      return;
    }

    final result = await showDialog(
      context: context,
      builder: (context) => QRScannerDialog(isContainerScanner: false),
    );

    if (result != null) {
      _foodItem = result;
      notifyListeners();
    }
  }

  Future<void> storeFoodItem(BuildContext context) async {
    debugPrint("storeFoodItem called");
    if (_qboxId != null &&
        _qboxId!.isNotEmpty &&
        _foodItem != null &&
        _foodItem!.isNotEmpty) {
      final newFoodItem = FoodItem(
        boxCellSno: _qboxId!,
        uniqueCode: _foodItem!,
        wfStageCd: 11,
        qboxEntitySno: 3,
        storageDate: DateTime.now(),
      );

      try {
        var result = await apiService.post(
          "8912",
          "masters",
          "load_sku_in_qbox",
          newFoodItem.toMap(),
        );

        if (result != null && result['data'] != null) {
          _storedItems.add(newFoodItem);
          clearStorageInputs();
          commonService.presentToast('Food item stored successfully!');
        } else {
          commonService
              .presentToast('Failed to store the food item. Please try again.');
        }
      } catch (e) {
        print('Error: $e');
        commonService
            .presentToast('An error occurred while storing the food item.');
      }
      notifyListeners();
    } else {
      commonService.presentToast('Please provide valid QBox ID and Food Item.');
    }
  }

  // Dispatch Screen Methods
  void setScannedDispatchItem(String? item) {
    _scannedDispatchItem = item;
    notifyListeners();
  }

  void setProcessingScan(bool value) {
    _isProcessingScan = value;
    notifyListeners();
  }

  Future<void> handleDispatchQRScan(
      BuildContext context, String? scannedValue) async {
    if (_isProcessingScan) return;
    setProcessingScan(true);

    final isMatched =
        _storedItems.any((item) => item.uniqueCode == scannedValue);

    if (isMatched) {
      setScannedDispatchItem(scannedValue);
      commonService.presentToast("Qbox found: $scannedValue");
    } else {
      commonService.presentToast("No Qbox found!");
      setScannedDispatchItem(null);
    }

    await Future.delayed(Duration(seconds: 2));
    setProcessingScan(false);
  }

  Future<void> dispatchFoodItem(BuildContext context) async {
    if (_scannedDispatchItem != null) {
      try {
        var itemToDispatch = _storedItems.firstWhere(
          (item) => item.uniqueCode == _scannedDispatchItem,
          orElse: () => throw Exception('Item not found'),
        );

        Map<String, dynamic> body = {
          "uniqueCode": itemToDispatch.uniqueCode,
          "wfStageCd": 12,
          "qboxEntitySno": 2,
        };

        var result = await apiService.post(
          "8912",
          "masters",
          "unload_sku_from_qbox_to_hotbox",
          body,
        );

        if (result != null && result['data'] != null) {
          _dispatchedItems.add(itemToDispatch);
          _storedItems.removeWhere(
              (item) => item.uniqueCode == itemToDispatch.uniqueCode);
          setScannedDispatchItem(null);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Food item dispatched successfully!'),
              backgroundColor: AppTheme.appTheme,
            ),
          );
        } else {
          commonService.presentToast(
              'Failed to dispatch the food item. Please try again.');
        }
      } catch (e) {
        print('Error: $e');
        commonService
            .presentToast('An error occurred while dispatching the food item.');
      }
      notifyListeners();
    } else {
      commonService.presentToast('No scanned food item to dispatch.');
    }
  }

  // Dispatch History Screen Methods
  void setSortBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void resetFilters() {
    _sortBy = 'Date';
    _isAscending = false;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  List<FoodItem> getSortedDispatchedItems() {
    var items = List<FoodItem>.from(_dispatchedItems);

    // Apply date range filter
    if (_startDate != null && _endDate != null) {
      items = items.where((item) {
        return item.storageDate.isAfter(_startDate!) &&
            item.storageDate.isBefore(_endDate!.add(Duration(days: 1)));
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Date':
        items.sort((a, b) => a.storageDate.compareTo(b.storageDate));
        break;
      case 'Food Item Name':
        items.sort((a, b) => a.boxCellSno.compareTo(b.boxCellSno));
        break;
      case 'Qbox ID':
        items.sort((a, b) => a.uniqueCode.compareTo(b.uniqueCode));
        break;
    }

    return _isAscending ? items : items.reversed.toList();
  }

  // Helper Methods
  FoodItem? findStoredItem(String uniqueCode) {
    try {
      return _storedItems.firstWhere((item) => item.uniqueCode == uniqueCode);
    } catch (e) {
      return null;
    }
  }

  bool isItemStored(String uniqueCode) {
    return _storedItems.any((item) => item.uniqueCode == uniqueCode);
  }
}
