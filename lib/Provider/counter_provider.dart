import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int counterValue;
  CounterProvider({this.counterValue = 0});


  void incrementCounter(){
    counterValue++;
    notifyListeners();
  }

  void decrementCounter(){
    counterValue--;
    notifyListeners();
  }
}

