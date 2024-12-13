import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qbox/Core/Router/app_router.dart';
import 'package:qbox/Provider/login_provider.dart';
import 'package:qbox/Provider/scanner_provider.dart';
import 'package:qbox/Theme/app_theme.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
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

