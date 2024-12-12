import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox_app/Core/Router/app_router.dart';
import 'package:qbox_app/Provider/login_provider.dart';
import 'package:qbox_app/Theme/app_theme.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider())
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Qbox',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}

