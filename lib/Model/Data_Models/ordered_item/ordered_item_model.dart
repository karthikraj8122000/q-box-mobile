// ordered_item_model.dart
class OrderItem {
  final String orderId;
  final String status;
  final DateTime timestamp;
  final String? rejectionReason;
  final List<String>? rejectionPhotos;
  final Map<String, dynamic>? orderDetails; // Store order details from API
  final List<dynamic>? orderItems; // Store order items from API

  OrderItem({
    required this.orderId,
    required this.status,
    required this.timestamp,
    this.rejectionReason,
    this.rejectionPhotos,
    this.orderDetails,
    this.orderItems,
  });
}