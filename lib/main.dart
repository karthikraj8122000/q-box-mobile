import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'package:qr_page/Provider/food_store_provider.dart';
import 'package:qr_page/Provider/network_provider.dart';
import 'package:qr_page/Provider/qbox_delivery_provider.dart';
import 'Provider/auth_provider.dart';
import 'Provider/order/scan_provider.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodStoreProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child:  Consumer<AuthProvider>(
        builder: (context, AuthProvider, _) {
          return MaterialApp.router(
            routerConfig: AppRouter.router, // Make sure your AppRouter is set up correctly
            debugShowCheckedModeBanner: false,
            title: 'QBox',
            theme: ThemeData(
              useMaterial3: false,
            ),
          );
        },
      ),
    );
  }
}

