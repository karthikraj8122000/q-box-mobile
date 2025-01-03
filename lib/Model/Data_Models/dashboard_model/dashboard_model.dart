
class QBoxSettings {
  final String qboxEntityName;
  final int rowCount;
  final int columnCount;
  final List<QBox> qboxes;

  QBoxSettings({
    required this.qboxEntityName,
    required this.rowCount,
    required this.columnCount,
    required this.qboxes,
  });

  factory QBoxSettings.fromMap(Map<String, dynamic> map) {
    return QBoxSettings(
      qboxEntityName: map['qboxEntityName'] as String,
      rowCount: map['rowCount'] as int,
      columnCount: map['columnCount'] as int,
      qboxes: (map['qboxes'] as List<dynamic>)
          .map((qbox) => QBox.fromMap(qbox as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QBox {
  final String foodName;
  final int qboxId;
  final String foodCode;
  final String foodImage;
  DateTime? storageDate;

  QBox({
    required this.foodName,
    required this.qboxId,
    required this.foodCode,
    required this.foodImage,
    this.storageDate,
  });

  factory QBox.fromMap(Map<String, dynamic> map) {
    return QBox(
      foodName: map['foodName'] ?? '',
      qboxId: map['qboxId'] ?? 0,
      foodCode: map['foodCode'] ?? '',
      foodImage: map['foodImage'] ?? '',
      storageDate: DateTime.parse(map['storageDate'] ?? "2024-12-29"),
    );
  }
}


