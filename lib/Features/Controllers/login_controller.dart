import 'package:qbox_app/Model/Data_Models/user_model/user_model.dart';

class LoginController {
  Future<User> login({required String email,required String password}) async{
    await Future.delayed(const Duration(seconds: 2));
    if(email == 'sk@gmail.com' && password == 'Apple@123'){
      return User(id: "123", email: email);
    }
    else{
      throw Exception("Invalid credentials");
    }
  }
}