
import 'dart:io';

class Order {
  final String orderId;
  final List<InwardFoodModel> items;
  final int totalItems;
  final String status;

  Order({
    required this.orderId,
    required this.items,
    required this.totalItems,
    this.status = 'In Progress',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      items: (json['items'] as List).map((item) => InwardFoodModel.fromJson(item)).toList(),
      totalItems: json['totalItems'],
      status: json['status'] ?? 'In Progress',
    );
  }
}

class InwardFoodModel {
  final String id;
  final String name;
  final double price;
  late final String qrCode;
  String status;
  String? rejectionReason;
  File? rejectionPhoto;

  InwardFoodModel({
    required this.id,
    required this.name,
    required this.price,
    required this.qrCode,
    this.status = 'pending',
    this.rejectionReason,
    this.rejectionPhoto,
  });

  factory InwardFoodModel.fromJson(Map<String, dynamic> json) {
    return InwardFoodModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      qrCode: json['qrCode'],
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejectionReason'],
      rejectionPhoto:json['rejectionPhoto']
    );
  }
}
