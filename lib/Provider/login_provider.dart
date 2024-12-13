import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qbox/Features/Controllers/login_controller.dart';
import 'package:qbox/Features/Screens/Scanner_Page/scanner_page.dart';
import 'package:qbox/Model/Data_Models/user_model/user_model.dart';
import 'package:qbox/Widgets/Common/app_text.dart';

class LoginProvider extends ChangeNotifier {
  final LoginController loginController = LoginController();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _obsecureText = true;

  User? _user;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get obsecureText => _obsecureText;
  User? get user => _user;

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


  Future<dynamic> login(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await loginController.login(email: _email, password: _password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: AppText(text: "Login successfully!", fontSize: 14)),
      );
      GoRouter.of(context).push(ScannerPage.routeName);
    } catch (e) {
      throw Exception(ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: AppText(text: "$e", fontSize: 14))));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
