import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'dart:convert';

import '../Services/toast_service.dart';
import '../Services/token_service.dart';

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

  Future<bool> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final userStr = await _tokenService.getUser();

      if (userStr == null) {
        throw 'User not found';
      }

      final userData = json.decode(userStr);

      if (userData['email'].toLowerCase() != email.toLowerCase()) {
        throw 'User not found';
      }

      if (userData['password'] != password) {
        throw 'Invalid password';
      }

      currentUser = userData['email'];
      isAuthenticated = true;
      await _tokenService.saveToken(currentUser);
      isLoading = false;
      notifyListeners();
      commonService.presentToast("Login successfully!");
      // GoRouter.of(context).push(.routeName);
      AppRouter.navigateToHomeView();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      commonService.errorToast("Error: ${e.toString()}");
      return false;
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
