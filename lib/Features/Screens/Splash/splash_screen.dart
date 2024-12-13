import 'dart:async';

import 'package:flutter/material.dart';

import 'package:qbox_app/Features/Screens/Login/login.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5), goToPage);
  }

  goToPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/food.gif'),
              height: 200,
            ),
            Text('𝑸𝒃𝒐𝒙' , style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.deepPurple),),
          ],
        ),
      ),
    );
  }

}
