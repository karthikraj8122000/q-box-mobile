import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'package:qr_page/Provider/food_retention_provider.dart';
import 'package:qr_page/Provider/login_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => FoodRetentionProvider()),
      ],
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          return MaterialApp.router(
            routerConfig: AppRouter.router, // Make sure your AppRouter is set up correctly
            debugShowCheckedModeBanner: false,
            title: 'QBox',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
