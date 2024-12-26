import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/router_loading_provider.dart';

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _startLoading(route.navigator!.context);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _startLoading(newRoute.navigator!.context);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _startLoading(previousRoute.navigator!.context);
    }
  }

  void _startLoading(BuildContext context) {
    Provider.of<LoadingProvider>(context, listen: false).startLoading();
    Future.delayed(Duration(milliseconds: 100), () {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        Provider.of<LoadingProvider>(context, listen: false).stopLoading();
      }
    });
  }
}

