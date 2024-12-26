import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_page/Core/Router/app_router.dart';
import 'package:qr_page/Provider/food_store_provider.dart';
import 'package:qr_page/Provider/login_provider.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'Provider/auth_provider.dart';
import 'Provider/order/order_qr_scanning_provider.dart';
import 'Provider/order/scan_provider.dart';
import 'Provider/router_loading_provider.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => FoodStoreProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          final router = AppRouter.router;
          router.routerDelegate.addListener(() {
            Provider.of<LoadingProvider>(context, listen: false).startLoading();
            Future.delayed(Duration(milliseconds: 100), () {
              Provider.of<LoadingProvider>(context, listen: false).stopLoading();
            });
          });

          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'QBox',
            theme: ThemeData(
              useMaterial3: false,
            ),
            builder: (context, child) {
              return Consumer<LoadingProvider>(
                builder: (context, loadingProvider, _) {
                  return Stack(
                    children: [
                      child!,
                      if (loadingProvider.isLoading)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.black,),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

