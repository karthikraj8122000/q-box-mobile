import '../Data_Models/inward_food_model.dart';

class Order {
  final String orderId;
  final List<String> expectedFoodCodes;
  final List<InwardFoodModel> scannedFoodItems;
  final DateTime scanTime;
  String status;
  double orderTotal;

  Order({
    required this.orderId,
    required this.expectedFoodCodes,
    String? status,
    this.orderTotal = 0.0,
  })  : scannedFoodItems = [],
        scanTime = DateTime.now(),
        status = status ?? 'In Progress';
}
