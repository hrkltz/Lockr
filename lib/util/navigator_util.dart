import 'package:flutter/widgets.dart';


class NavigatorUtil {
  static void pop<T extends Object?>(NavigatorState navigatorState, [ T? result ]) => navigatorState.pop(result);
  static void pushNamed(NavigatorState navigatorState, String routeName, { Object? arguments }) => navigatorState.pushNamed(routeName, arguments: arguments);
  static void popHome(NavigatorState navigatorState) => navigatorState.popUntil((route) => route.isFirst);
}
