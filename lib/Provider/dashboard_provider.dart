import 'dart:convert';

import 'package:flutter/material.dart';
import '../Model/Data_Models/dashboard_entity_model.dart';
import '../Services/api_service.dart';
import '../Services/toast_service.dart';
import '../Services/token_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  final CommonService commonService = CommonService();
  List<dynamic> _hotboxCountList = [];
  List<dynamic> _currentInventoryCountlist = [];
  final TokenService _tokenService = TokenService();
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
  List<QboxEntity> _qboxEntities = [];
  QboxEntity? _selectedQboxEntity;
  List<QboxEntity> get qboxEntities => _qboxEntities;
  QboxEntity? get selectedQboxEntity => _selectedQboxEntity;

  Future<void> setSelectedQboxEntity(QboxEntity entity) async {
    _selectedQboxEntity = entity;
    await _tokenService.saveQboxEntitySno(entity.qboxEntitySno);
    await getQboxes(entity.qboxEntitySno);
    await getCurrentInventoryCount(entity.qboxEntitySno);
    await getHotboxCount(entity.qboxEntitySno);
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      final user = await _tokenService.getUser();
      if (user != null) {
        Map<String, dynamic> userData;
        if (user is String) {
          userData = jsonDecode(user);
        } else if (user is Map<String, dynamic>) {
          userData = user;
        } else {
          throw Exception('Invalid user data format');
        }
        final qboxEntityDetails = userData['qboxEntityDetails'] as List<dynamic>;
        _qboxEntities = qboxEntityDetails.map((entity) => QboxEntity.fromJson(entity)).toList();
        int? savedQboxEntitySno = await _tokenService.getQboxEntitySno();
        if (savedQboxEntitySno != null) {
          print("Using saved QboxEntitySno");
          print('SavedQboxEntitySno: $savedQboxEntitySno');
          _selectedQboxEntity = _qboxEntities.firstWhere(
                (entity) => entity.qboxEntitySno == savedQboxEntitySno,
            orElse: () => _qboxEntities.first,
          );
        } else if (_qboxEntities.isNotEmpty) {
          print("No saved QboxEntitySno, using first entity");
          _selectedQboxEntity = _qboxEntities.first;
          savedQboxEntitySno = _selectedQboxEntity!.qboxEntitySno;
          print("currentsavedQboxEntitySno:$savedQboxEntitySno");
          await _tokenService.saveQboxEntitySno(savedQboxEntitySno);
        }
        if (_selectedQboxEntity != null){
          await getQboxes(_selectedQboxEntity!.qboxEntitySno);
          await getCurrentInventoryCount(_selectedQboxEntity!.qboxEntitySno);
          await getHotboxCount(_selectedQboxEntity!.qboxEntitySno);
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    var entitySno = await _tokenService.getQboxEntitySno();
    print("entitySno$entitySno");
    if (entitySno != null) {
      await Future.wait([
        getQboxes(entitySno),
        getCurrentInventoryCount(entitySno),
        getHotboxCount(entitySno),
      ]);
    }
  }

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
        "transactionDate": "2025-01-10"
      };
      var result = await apiService.post(
          "8911", "masters", "get_sku_dashboard_counts", params);
      print("get_sku_dashboard_counts$result");
      if (result != null && result['data'] != null) {
        _currentInventoryCountlist = result['data'];
        print('_currentInventoryCountlist$_currentInventoryCountlist');
      } else {
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
        "transactionDate": "2025-01-10"
      };
      var result =
          await apiService.post("8911", "masters", "get_hotbox_count_v2", params);
      print("my result:$result");
      if (result != null && result['data'] != null) {
        _hotboxCountList = result['data']['hotboxCounts'];
        print('_hotboxCountlist$_hotboxCountList');
      } else {

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
