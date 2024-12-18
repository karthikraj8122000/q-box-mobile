import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_page/Features/Screens/Login/login.dart';


class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    _animation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                'assets/splash.json', // You'll need to add this Lottie file
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
              Text(
                'QBox',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}