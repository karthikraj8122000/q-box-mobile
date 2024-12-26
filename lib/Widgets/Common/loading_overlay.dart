import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/router_loading_provider.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, loadingProvider, _) {
        return Stack(
          children: [
            child,
            if (loadingProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}