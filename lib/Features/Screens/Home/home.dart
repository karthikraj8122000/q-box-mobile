import 'package:flutter/material.dart';
import 'package:testing_app/Widgets/Common/app_text.dart';

class HomePage extends StatefulWidget {

  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AppText(text: "Home", fontSize: 18)
        ],
      ),
    );
  }
}
