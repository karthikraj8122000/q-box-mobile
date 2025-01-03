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
  final String deliveryPartnerName;
  final String qboxEntityName;
  final String restaurantName;
  final int purchaseOrderSno;
  final int qboxEntitySno;
  final int restaurantSno;
  final int deliveryPartnerSno;
  final int orderStatusCd;
  final DateTime? orderedTime;
  final int orderedBy;
  final String partnerPurchaseOrderId;
  final int mealTimeCd;
  final String? description;

  Order({
    required this.deliveryPartnerName,
    required this.qboxEntityName,
    required this.restaurantName,
    required this.purchaseOrderSno,
    required this.qboxEntitySno,
    required this.restaurantSno,
    required this.deliveryPartnerSno,
    required this.orderStatusCd,
    this.orderedTime,
    required this.orderedBy,
    required this.partnerPurchaseOrderId,
    required this.mealTimeCd,
    this.description,
  });

  // Factory method to create an instance from a JSON object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      deliveryPartnerName: json['deliveryPartner1name'] ?? '',
      qboxEntityName: json['qboxEntity1name'] ?? '',
      restaurantName: json['restaurant1name'] ?? '',
      purchaseOrderSno: json['purchaseOrderSno'] ?? 0,
      qboxEntitySno: json['qboxEntitySno'] ?? 0,
      restaurantSno: json['restaurantSno'] ?? 0,
      deliveryPartnerSno: json['deliveryPartnerSno'] ?? 0,
      orderStatusCd: json['orderStatusCd'] ?? 0,
      orderedTime: json['orderedTime'] != null
          ? DateTime.tryParse(json['orderedTime'])
          : null,
      orderedBy: json['orderedBy'] ?? 0,
      partnerPurchaseOrderId: json['partnerPurchaseOrderId'] ?? '',
      mealTimeCd: json['mealTimeCd'] ?? 0,
      description: json['description'],
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'deliveryPartner1name': deliveryPartnerName,
      'qboxEntity1name': qboxEntityName,
      'restaurant1name': restaurantName,
      'purchaseOrderSno': purchaseOrderSno,
      'qboxEntitySno': qboxEntitySno,
      'restaurantSno': restaurantSno,
      'deliveryPartnerSno': deliveryPartnerSno,
      'orderStatusCd': orderStatusCd,
      'orderedTime': orderedTime?.toIso8601String(),
      'orderedBy': orderedBy,
      'partnerPurchaseOrderId': partnerPurchaseOrderId,
      'mealTimeCd': mealTimeCd,
      'description': description,
    };
  }
}
