import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'package:qr_page/Services/api_service.dart';

import 'dart:convert';

import '../Services/toast_service.dart';
import '../Services/token_service.dart';
import '../Utils/deviceInfo.dart';
import '../Utils/time.dart';

class AuthProvider extends ChangeNotifier {
  final TokenService _tokenService = TokenService();
  CommonService commonService = CommonService();
  bool isLoading = false;
  bool isAuthenticated = false;
  String? currentUser;
  String email = '';
  String password = '';
  bool _obsecureText = true;
  String fullName = '';
  String signupEmail = '';
  String signupPassword = '';
  bool signupObscureText = true;
  bool _isLoggedIn = false;
  DeviceInfo deviceInfo = DeviceInfo();
  ApiService api = ApiService();
  Time time = Time();

  bool get obsecureText => _obsecureText;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initAuth() async {
    await checkAuthStatus();
  }

  void setSignupData({String? name, String? email, String? password}) {
    if (name != null) fullName = name;
    if (email != null) signupEmail = email;
    if (password != null) signupPassword = password;
    notifyListeners();
  }

  void setLoginData({String? email, String? password}) {
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    notifyListeners();
  }

  void toggleLoginObscureText() {
    _obsecureText = !_obsecureText;
    notifyListeners();
  }

  void toggleSignupObscureText() {
    signupObscureText = !signupObscureText;
    notifyListeners();
  }

  Future<bool> signup(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final userData = {
        'email': signupEmail.toLowerCase(),
        'password': signupPassword,
        'fullName': fullName,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _tokenService.saveUser(json.encode(userData));

      isLoading = false;
      notifyListeners();
      commonService.presentToast("Account created successfully!");
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('$e');
      commonService.errorToast("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      print('Email: $email, Password: $password');
      Map<String, dynamic> signInConfig = {
        "appSno": 1,
        "pushToken": 12345,
        'deviceId': await deviceInfo.getDeviceId(),
        'generatedOn': await time.getLocalTime(DateTime.now())
      };
      Map<String, dynamic> data = {
        "authUserName": email,
        "password": password,
        "signInConfig": signInConfig
      };
      print('data$data');
      final result = await api.post('8914','authn','login',data);
      print('result$result');
      if (result != null && result['data'] != null) {
        var loginResult = result['data'];
        print('loginResults$loginResult');
        // var appUserRole = loginResult['selectedRole'] ?? loginResult['role']?[0]?['roleValue'];
        if (loginResult['isLoginSuccess'] == true) {
          print('loginResult$loginResult');
          loginResult['password'] = password;
          await _tokenService.saveUser(loginResult);
          commonService.presentToast("Login successfully!");
          AppRouter.navigateToHomeView();
          return true; // Login successful
        } else {
          commonService.errorToast("${loginResult['msg'] ?? 'Unknown error'}");
          return false; // Login failed
        }
      } else {
        commonService.errorToast("Login failed: No data received");
        return false; // Login failed
      }
    } catch (e) {
      commonService.errorToast("Error during login: $e");
      return false; // Login failed due to an exception
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _tokenService.signOut();
    isAuthenticated = false;
    currentUser = null;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final user = await _tokenService.getToken();
    if (user != null) {
      currentUser = user;
      isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> clearAll() async {
    await _tokenService.removeStorage();
    isAuthenticated = false;
    currentUser = null;
    notifyListeners();
  }
}