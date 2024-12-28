// lib/models/scanner_model.dart

class ScannerModel {
  String qBoxBarcode;
  String foodBarcode;
  String qBoxOutBarcode;
  String qBoxOutStatus;

  ScannerModel({
    this.qBoxBarcode = '',
    this.foodBarcode = '',
    this.qBoxOutBarcode = '',
    this.qBoxOutStatus = '',
  });
}