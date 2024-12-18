class FoodItem {
  final String uniqueCode;
  final int wfStageCd;
  final String boxCellSno;
  final int qboxEntitySno;
  final DateTime storageDate;

  FoodItem({
    required this.uniqueCode,
    required this.wfStageCd,
    required this.boxCellSno,
    required this.qboxEntitySno,
    required this.storageDate,
  });

  // Convert FoodItem to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      "uniqueCode": uniqueCode,
      "wfStageCd": wfStageCd,
      "boxCellSno": boxCellSno,
      "qboxEntitySno": qboxEntitySno,
      "storageDate": storageDate.toIso8601String(), // Convert DateTime to String for JSON
    };
  }
}
