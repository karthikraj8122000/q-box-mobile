import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/Core/Router/app_router.dart';
import 'package:testing_app/Provider/counter_provider.dart';
import 'package:testing_app/Theme/app_theme.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CounterProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}

