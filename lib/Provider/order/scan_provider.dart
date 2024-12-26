import 'package:flutter/foundation.dart';

import '../../Model/Data_Models/scan_result.dart';


class ScanProvider with ChangeNotifier {
  List<ScanResult> _scanResults = [];

  List<ScanResult> get scanResults => _scanResults;

  void addScanResult(String code) {
    final existingResult = _scanResults.firstWhere(
      (result) => result.code == code,
      orElse: () => ScanResult(code: code),
    );

    if (!_scanResults.contains(existingResult)) {
      _scanResults.add(existingResult);
      notifyListeners();
    }
  }

  void updateScanStatus(String code, int newStatus) {
    final index = _scanResults.indexWhere((result) => result.code == code);
    if (index != -1) {
      _scanResults[index].status = newStatus;
      notifyListeners();
    }
  }

  // Get status description
  String getStatusDescription(int status) {
    switch (status) {
      case 9:
        return 'Accepted';
      case 8:
        return 'Rejected';
      case 7:
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
}

