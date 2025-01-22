class QBoxCell {
  final int rowNo;
  final int columnNo;
  final int qboxId;
  final String foodCode;
  final String foodName;

  QBoxCell({
    required this.rowNo,
    required this.columnNo,
    required this.qboxId,
    required this.foodCode,
    required this.foodName,
  });

  factory QBoxCell.fromMap(Map<String, dynamic> map) {
    return QBoxCell(
      rowNo: map['rowNo'] ?? 0,
      columnNo: map['columnNo'] ?? 0,
      qboxId: map['qboxId'] ?? -1,
      foodCode: map['foodCode'] ?? '',
      foodName: map['foodName'] ?? 'EMPTY',
    );
  }
}
