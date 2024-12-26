import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/router_loading_provider.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _startLoading(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _startLoading(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _startLoading(previousRoute);
    }
  }

  void _startLoading(Route<dynamic> route) {
    if (route.navigator?.context != null) {
      Provider.of<LoadingProvider>(route.navigator!.context, listen: false).startLoading();
      Future.delayed(Duration(milliseconds: 100), () {
        if (route.isCurrent) {
          Provider.of<LoadingProvider>(route.navigator!.context, listen: false).stopLoading();
        }
      });
    }
  }
}

