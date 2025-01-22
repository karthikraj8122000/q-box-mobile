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
  List<dynamic> get currentInventoryCountlist => _currentInventoryCountlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get outwardOrderList => _outwardOrderList;
  Map<String, dynamic> qboxInventory = {};
  List<dynamic> qboxCounts = [];
  int columnCount = 10; // Default value, update based on your needs
  int rowCount = 10;
  String qboxEntityName = "";

  List<List<Map<String, dynamic>>> _qboxList = [];

  List<List<Map<String, dynamic>>> get groupedQboxLists => _qboxList;

  //
  // Future<void> getQboxes(int qboxEntitySno) async {
  //   try {
  //     _isLoading = true;
  //     _error = null;
  //     notifyListeners();
  //
  //     Map<String, dynamic> params = {"qboxEntitySno": qboxEntitySno};
  //     print("params: $params");
  //
  //     var result = await apiService.post(
  //       "8911",
  //       "masters",
  //       "get_box_cell_inventory_v2",
  //       params,
  //     );
  //
  //     print("result: $result");
  //
  //     if (result != null && result['isSuccess'] == true) {
  //       qboxInventory = result['data']['qboxInventory'] ?? {};
  //       qboxCounts = result['data']['qboxCounts'] ?? [];
  //
  //       // Update row and column counts if available in the data
  //       if (qboxInventory['qBoxCount'] != null &&
  //           qboxInventory['qBoxCount'].isNotEmpty) {
  //         rowCount = qboxInventory['qBoxCount'][0]['rowCount'] ?? 10;
  //         columnCount = qboxInventory['qBoxCount'][0]['columnCount'] ?? 10;
  //       }
  //
  //       notifyListeners();
  //     } else {
  //       _error = 'Failed to retrieve the data.';
  //       commonService.errorToast(_error!);
  //     }
  //   } catch (e) {
  //     print("Error in getQboxes: $e");
  //     _error = 'An error occurred while retrieving the data.';
  //     commonService.errorToast(_error!);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

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
        qboxEntityName = result['data']['qboxInventory']['qboxEntityName']??"Entity";
        Map<int, List<Map<String, dynamic>>> groupedQboxes = {};
        for (var qbox in qboxInventory['qboxes'] ?? []) {
          int entityInfraSno = qbox['EntityInfraSno'] ?? 0;
          if (!groupedQboxes.containsKey(entityInfraSno)) {
            groupedQboxes[entityInfraSno] = [];
          }
          groupedQboxes[entityInfraSno]!.add(qbox);
        }
        _qboxList = groupedQboxes.values.toList();
        // Update row and column counts
        if (qboxInventory['qBoxCount'] != null &&
            qboxInventory['qBoxCount'].isNotEmpty) {
          rowCount = qboxInventory['qBoxCount'][0]['rowCount'] ?? 10;
          columnCount = qboxInventory['qBoxCount'][0]['columnCount'] ?? 10;
        }

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
}

