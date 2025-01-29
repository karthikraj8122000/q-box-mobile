import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'package:qr_page/Provider/dashboard_provider.dart';
import 'package:qr_page/Provider/inward_order_provider.dart';
import 'package:qr_page/Provider/network_provider.dart';
import 'package:qr_page/Provider/order_history_provider.dart';
import 'package:qr_page/Provider/order_qr_scanning_provider.dart';
import 'package:qr_page/Provider/qbox_delivery_provider.dart';
import 'Provider/auth_provider.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => InwardOrderDtlProvider()),
        ChangeNotifierProvider(create: (_) => OrderScanningProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
      ],
      child:  Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
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

