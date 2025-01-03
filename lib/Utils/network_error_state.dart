import 'package:flutter/material.dart';

enum ConnectionState {
  online,
  offline,
  error,
}

class NetworkErrorState extends ChangeNotifier {
  ConnectionState _connectionState = ConnectionState.online;
  String _errorMessage = '';

  ConnectionState get connectionState => _connectionState;
  String get errorMessage => _errorMessage;

  void setOffline() {
    _connectionState = ConnectionState.offline;
    _errorMessage = 'No internet connection. Please try again.';
    notifyListeners();
  }

  void setOnline() {
    _connectionState = ConnectionState.online;
    _errorMessage = '';
    notifyListeners();
  }

  void setError(String message) {
    _connectionState = ConnectionState.error;
    _errorMessage = message;
    notifyListeners();
  }
}