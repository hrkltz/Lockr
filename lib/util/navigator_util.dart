import 'package:flutter/cupertino.dart';


class NavigatorUtil {
  static final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();


  static void pop() {
    navigationKey.currentState!.pop();
  }


  static void pushNamed(String routeName, { Object? arguments }) {
    navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }


  static void popHome() => navigationKey.currentState!.popUntil((route) => route.isFirst);
}
