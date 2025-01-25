// qbox_provider.dart
import 'package:flutter/material.dart';
import 'package:qr_page/Services/api_service.dart';
import 'package:qr_page/Services/toast_service.dart';

class QBoxProvider with ChangeNotifier {
  List<dynamic> _qboxes = [];
  bool _isLoading = false;
  String? _error;
  List<List<dynamic>> _gridMatrix = [];
  final ApiService apiService = ApiService();
final CommonService commonService = CommonService();
  List<dynamic> get qboxes => _qboxes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<List<dynamic>> get gridMatrix => _gridMatrix;

  Future<void> getQboxes(int qboxEntitySno) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Map<String, dynamic> params = {"qboxEntitySno": qboxEntitySno};
      print("params$params");
      var result = await apiService.post(
          "8911", "masters", "get_box_cell_inventory_v2", params);
      print("result$result");

      if (result != null && result['data'] != null) {
        var qboxData = result['data']['qboxInventory']['qboxes'] as List;
        print("qboxData$qboxData");
        _qboxes = qboxData;
        _createGridMatrix();
        notifyListeners();
      } else {
        _error = 'Failed to retrieve the data.';
        commonService.errorToast(_error!);
      }
    } catch (e) {
      _error = 'An error occurred while retrieving the data.';
      commonService.errorToast(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _createGridMatrix() {
    if (_qboxes.isEmpty) return;

    // Find maximum row and column numbers
    int maxRow = _qboxes.fold<int>(0,
            (max, qbox) => qbox['rowNo'] > max ? qbox['rowNo'] : max);
    int maxCol = _qboxes.fold<int>(0,
            (max, qbox) => qbox['columnNo'] > max ? qbox['columnNo'] : max);

    // Initialize matrix
    _gridMatrix = List.generate(maxRow, (i) => List.generate(maxCol, (j) {
      return _qboxes.firstWhere(
            (qbox) => qbox['rowNo'] == i + 1 && qbox['columnNo'] == j + 1,
        orElse: () => {
          'rowNo': i + 1,
          'columnNo': j + 1,
          'qboxId': -1,
          'foodName': "EMPTY",
          'entityInfraSno': -1,
          'logo': null,
          'foodCode': null
        },
      );
    }));
  }
}
