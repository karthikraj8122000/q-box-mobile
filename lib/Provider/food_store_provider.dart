import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../Model/Data_Models/Food_item/foot_item_model.dart';
import '../Services/api_service.dart';
import '../Services/toast_service.dart';
import '../Theme/app_theme.dart';
import '../Widgets/Common/app_colors.dart';

class FoodStoreProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();

  // State variables
  final List<FoodItem> _storedItems = [];
  final List<FoodItem> _dispatchedItems = [];
  List<dynamic> _foodTemsList = [];
  final List<dynamic> _scannedFoodItems = [];

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
  List<dynamic> _qboxList = [];
  bool _isLoading = false;

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
  List<dynamic> get foodItems => _foodTemsList;
  List<dynamic> get scannedFoodItems => _scannedFoodItems;

  bool get isLoading => _isLoading;
  List<dynamic> get qboxList => _qboxList;
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

  void clearScannedItems() {
    _scannedFoodItems.clear();
    _scannedDispatchItem = null;
    notifyListeners();
  }

  Future<void> getQboxes() async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> params = {"qboxEntitySno": 3};
    try {
      var result = await apiService.post(
          "8912", "masters", "get_qbox_current_status", params);
      print("result");
      print(result);
      if (result != null && result['data'] != null) {
        _qboxList = result['data'];
        notifyListeners();
      } else {
        commonService.errorToast('Failed to retrieve QBox details.');
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionError) {
        throw Exception('No Internet Connection');
      }
      throw Exception('Failed to fetch data');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<dynamic> getFoodItems() async {
  //   Map<String, dynamic> params = {"qboxEntitySno": 3};
  //   try {
  //     var result = await apiService.post(
  //         "8912", "masters", "search_box_cell_food", params);
  //     if (result != null && result['data'] != null) {
  //       _foodTemsList = result['data'];
  //       notifyListeners();
  //     } else {
  //       commonService.errorToast('Failed at retrieving the food item.');
  //     }
  //   } catch (e) {
  //     debugPrint('$e');
  //     commonService
  //         .errorToast('An error occurred while retrieving the food item.');
  //   }
  // }

  Future<String?> scanQRCode(
      BuildContext context, bool isContainerScanner) async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF8fbc8f',
        'Cancel',
        true,
        ScanMode.QR,
      );

      // If user cancelled scanning
      if (scanResult == '-1') {
        return null;
      }

      // If scan was successful, show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.appGreen,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Scan Successful!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isContainerScanner
                    ? "QBox ID: $scanResult"
                    : "Food Item ID: $scanResult",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mintGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // Return scan result only if confirmed, otherwise return null
      return confirmed == true ? scanResult : null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning: $e')),
      );
      return null;
    }
  }

  Future<void> scanContainer(BuildContext context) async {
    final result = await scanQRCode(context, true);
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

    final result = await scanQRCode(context, false);
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
          commonService.presentToast(
              'Failed to store the food item.May be scanned invalid qbox.Please try again.');
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
          "qboxEntitySno": 3,
        };

        try {
          var result = await apiService.post(
            "8912",
            "masters",
            "unload_sku_from_qbox_to_hotbox",
            body,
          );

          if (result != null && result['data'] != null) {
            _handleSuccessfulDispatch(itemToDispatch);
          } else if (result != null &&
              result['error']
                  ?.contains('relation "sku_inventory" does not exist')) {
            _handleSuccessfulDispatch(itemToDispatch);
            commonService.presentToast('Unloaded successfully!');
          } else {
            commonService.presentToast('Failed to dispatch. Please try again.');
          }
        } catch (apiError) {
          if (apiError
              .toString()
              .contains('relation "sku_inventory" does not exist')) {
            _handleSuccessfulDispatch(itemToDispatch);
            commonService
                .presentToast('Unloaded locally. Database update pending.');
          } else {
            throw apiError;
          }
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

// Helper method to handle successful dispatch
  void _handleSuccessfulDispatch(FoodItem itemToDispatch) {
    _dispatchedItems.add(itemToDispatch);
    _storedItems
        .removeWhere((item) => item.uniqueCode == itemToDispatch.uniqueCode);
    setScannedDispatchItem(null);
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
