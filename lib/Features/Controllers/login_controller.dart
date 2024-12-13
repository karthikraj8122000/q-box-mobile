import 'package:qbox_app/Model/Data_Models/user_model/user_model.dart';

class LoginController {
  Future<User> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email != 'sk@gmail.com' && password != 'Apple@123') {
      throw Exception("Invalid credentials");
    }
    if (email != 'sk@gmail.com') {
      throw Exception("email is not registered");
    }
    if (password != 'Apple@123') {
      throw Exception("Invalid Password");
    }
    return User(id: "123", email: email);
  }
}
