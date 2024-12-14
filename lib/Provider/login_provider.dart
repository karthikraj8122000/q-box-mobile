import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:qbox/Features/Controllers/login_controller.dart';
import 'package:qbox/Features/Screens/Scanner_Page/scanner_page.dart';
import 'package:qbox/Model/Data_Models/user_model/user_model.dart';
import 'package:qbox/Services/toast_service.dart';
import 'package:qbox/Widgets/Common/app_text.dart';

class LoginProvider extends ChangeNotifier {
  final LoginController loginController = LoginController();
  CommonService commonService = CommonService();
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

  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<dynamic> login(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await loginController.login(email: _email, password: _password);
      commonService.presentToast("Login successfully!");
      GoRouter.of(context).push(ScannerPage.routeName);
    } catch (e) {
      commonService.presentToast("$e",gravity: ToastGravity.BOTTOM);
      throw Exception("Login failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
