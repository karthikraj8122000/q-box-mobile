// lib/models/inward_food_model.dart
import 'dart:io';

class InwardFoodModel {
  final String id;
  final String name;
  final double price;
  String? qrCode;
  String status;
  String? rejectionReason;
  File? rejectionPhoto;

  InwardFoodModel({
    required this.id,
    required this.name,
    required this.price,
    this.qrCode,
    this.status = 'pending',
    this.rejectionReason,
    this.rejectionPhoto,
  });
}

class Order {
  final String orderId;
  final int totalItems;
  final List<InwardFoodModel> items;

  Order({
    required this.orderId,
    required this.totalItems,
    required this.items,
  });
}