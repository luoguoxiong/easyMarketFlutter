import 'package:flutter/material.dart';
import './goods.dart';
import './noFound.dart';
import './detail.dart';

class Router {
  static Map<String, Function> routes = {
    '/page': (context, {arguments}) => Goods(arguments: arguments),
    '/detail': (context) => Detail(),
  };
  static run(RouteSettings settings) {
    final Function pageContentBuilder = Router.routes[settings.name];

    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        // 传参路由
        return MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
      } else {
        // 无参数路由
        return MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
      }
    } else {
      // 404页
      return MaterialPageRoute(builder: (context) => NoFoundPage());
    }
  }
}
