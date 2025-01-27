import 'package:flutter/material.dart';
import '../Services/api_service.dart';
import '../Services/toast_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  // List<dynamic> _qboxList = [];
  List<dynamic> _hotboxCountList = [];
  List<dynamic> _currentInventoryCountlist = [];
  bool _isLoading = true;
  String? _error;
  final List<dynamic> _outwardOrderList = [
    {"name": "Biriyani", "count": 8},
    {"name": "Sambar", "count": 12},
  ];

  List<dynamic> get qboxLists => _qboxList;
  List<dynamic> get hotboxCountList => _hotboxCountList;
  List<dynamic> get currentInventoryCountList => _currentInventoryCountlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get outwardOrderList => _outwardOrderList;
  Map<String, dynamic> qboxInventory = {};
  List<dynamic> qboxCounts = [];
  List<dynamic> qBoxNumber = [];
  int columnCount = 5; // Default value, update based on your needs
  int rowCount = 5;
  String qboxEntityName = "";

  List<List<Map<String, dynamic>>> _qboxList = [];

  List<List<Map<String, dynamic>>> get groupedQboxLists => _qboxList;

  Future<dynamic> getQboxes(int qboxEntitySno) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {"qboxEntitySno": qboxEntitySno};
      print("params: $params");

      var result = await apiService.post(
        "8911",
        "masters",
        "get_box_cell_inventory_v2",
        params,
      );

      print("resultsssss: $result");

      if (result != null && result['isSuccess'] == true) {
        qboxInventory = result['data']['qboxInventory'] ?? {};
        qboxCounts = result['data']['qboxCounts'] ?? [];
        qBoxNumber = result['data']['qboxInventory']['qBoxNumber'] ?? [];
        qboxEntityName =
            result['data']['qboxInventory']['qboxEntityName'] ?? "Entity";
        Map<int, List<Map<String, dynamic>>> groupedQboxes = {};

        print("qBoxNumberssss$qBoxNumber");
        for (var qbox in qboxInventory['qboxes'] ?? []) {
          int entityInfraSno = qbox['EntityInfraSno'] ?? 0;
          if (!groupedQboxes.containsKey(entityInfraSno)) {
            groupedQboxes[entityInfraSno] = [];
          }
          groupedQboxes[entityInfraSno]!.add(qbox);
        }
        _qboxList = groupedQboxes.values.toList();

        notifyListeners();
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      print("Error in getQboxes: $e");
      _error = 'An error occurred while retrieving the data.';
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> getCurrentInventoryCount(int qboxEntitySno) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {
        "qboxEntitySno": qboxEntitySno,
        "transactionDate": "2025-01-27"
      };
      var result = await apiService.post(
          "8911", "masters", "get_sku_dashboard_counts", params);
      print("get_sku_dashboard_counts$result");
      if (result != null && result['data'] != null) {
        _currentInventoryCountlist = result['data'];
        print('_currentInventoryCountlist$_currentInventoryCountlist');
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      _error = 'An error occurred while retrieving the data.';
      debugPrint('$e');
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHotboxCount(int qboxEntitySno) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {
        "qboxEntitySno": qboxEntitySno,
        "transactionDate": "2025-01-27"
      };
      var result =
          await apiService.post("8911", "masters", "get_hotbox_count_v2", params);
      print("my result:$result");
      if (result != null && result['data'] != null) {
        _hotboxCountList = result['data']['hotboxCounts'];
        print('_hotboxCountlist$_hotboxCountList');
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      _error = 'An error occurred while retrieving the data.';
      debugPrint('$e');
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
