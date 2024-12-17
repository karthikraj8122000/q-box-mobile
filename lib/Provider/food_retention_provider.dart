import 'package:flutter/material.dart';
import '../Model/Food_item/qbox_sku_inventory_item.dart';

class FoodRetentionProvider extends ChangeNotifier {
  List<FoodItem> storedItems = [];
  List<FoodItem> dispatchedItems = [];

  void addStoredItem(FoodItem item) {
    storedItems.add(item);
    notifyListeners();
  }

  void addDispatchedItem(FoodItem item) {
    dispatchedItems.add(item);
    notifyListeners();
  }
}