class InventoryItem {
  final int inCount;
  final String skuCode;
  final int outCount;
  final int totalCount;
  final String description;

  InventoryItem({
    required this.inCount,
    required this.skuCode,
    required this.outCount,
    required this.totalCount,
    required this.description,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      inCount: json['inCount'] ?? 0,
      skuCode: json['skuCode'] ?? '',
      outCount: json['outCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}

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
  final int rowNo;
  final int columnNo;
  DateTime? storageDate;

  QBox({
    required this.foodName,
    required this.qboxId,
    required this.foodCode,
    required this.foodImage,
    required this.rowNo,
    required this.columnNo,
    this.storageDate,
  });

  factory QBox.fromMap(Map<String, dynamic> map) {
    return QBox(
      foodName: map['foodName'] ?? '',
      qboxId: map['qboxId'] ?? 0,
      foodCode: map['foodCode'] ?? '',
      foodImage: map['foodImage'] ?? '',
      rowNo: map['rowNo'] ?? 0,
      columnNo: map['columnNo'] ?? 0,
      storageDate: DateTime.parse(map['storageDate'] ?? "2024-12-29"),
    );
  }
}


