import 'package:flutter/cupertino.dart';


class NavigatorUtil {
  // TODO: Keep this one in seperate class / util as it is also used for showDialog().
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pop() {
    navigatorKey.currentState!.pop();
  }


  static void pushNamed(String routeName, { Object? arguments }) {
    navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }


  static void popHome() => navigatorKey.currentState!.popUntil((route) => route.isFirst);
}
