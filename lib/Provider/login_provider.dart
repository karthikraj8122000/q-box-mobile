import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Features/Screens/DeliveryPartner/home.dart';
import '../Model/Data_Models/user_model/user_model.dart';
import '../Services/auth_service.dart';
import '../Services/toast_service.dart';


class LoginProvider extends ChangeNotifier {
  CommonService commonService = CommonService();
  final AuthService _authService = AuthService();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _obsecureText = true;
  User? _user;
  bool _rememberMe = false; // Toggle switch state

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get obsecureText => _obsecureText;
  User? get user => _user;
  bool get rememberMe => _rememberMe;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleObsecureText(){
    _obsecureText = !_obsecureText;
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    try {
      final success = await _authService.login(email, password);

      if (success) {
        GoRouter.of(context).push(HomePage.routeName);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return false;
    }
  }
  // Future<dynamic> login(BuildContext context) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     _user = await loginController.login(email: _email, password: _password);
  //     commonService.presentToast("Login successfully!");
  //     GoRouter.of(context).push(HomePage.routeName);
  //     // GoRouter.of(context).push(MainNavigationScreen.routeName);
  //   } catch (e) {
  //     commonService.presentToast("$e");
  //     throw Exception("Login failed: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
