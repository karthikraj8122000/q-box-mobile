import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Provider/login_provider.dart';
import 'package:qr_page/Widgets/Common/app_text.dart';

class HomePage extends StatefulWidget {

  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    final user = provider.user;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const AppText(text: "Home", fontSize: 18),
            Text("${user?.id}"),
            Text("${user?.email}"),
          ],
        ),
      ),
    );
  }
}
