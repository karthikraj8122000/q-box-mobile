class FoodItem {
  final String boxCellSno;
  final String uniqueCode;
  final int wfStageCd;
  final int qboxEntitySno;
  final DateTime storageDate;

  FoodItem({
    required this.boxCellSno,
    required this.uniqueCode,
    required this.wfStageCd,
    required this.qboxEntitySno,
    required this.storageDate,
  });

  // Convert FoodItem to Map for API requests
  Map<String, dynamic> toMap() {
    return {
      'boxCellSno': boxCellSno,
      'uniqueCode': uniqueCode,
      'wfStageCd': wfStageCd,
      'qboxEntitySno': qboxEntitySno,
      'storageDate': storageDate.toIso8601String(),
    };
  }

  // Create FoodItem from Map (useful when receiving API response)
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      boxCellSno: map['boxCellSno'],
      uniqueCode: map['uniqueCode'],
      wfStageCd: map['wfStageCd'],
      qboxEntitySno: map['qboxEntitySno'],
      storageDate: DateTime.parse(map['storageDate']),
    );
  }
}