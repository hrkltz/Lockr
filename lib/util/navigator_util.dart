import 'package:flutter/widgets.dart';


class NavigatorUtil {
  static void pop(NavigatorState navigatorState) => navigatorState.pop();
  static void pushNamed(NavigatorState navigatorState, String routeName, { Object? arguments }) => navigatorState.pushNamed(routeName, arguments: arguments);
  static void popHome(NavigatorState navigatorState) => navigatorState.popUntil((route) => route.isFirst);
}
