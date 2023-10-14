import 'package:flutter/widgets.dart';


class MixedUtil {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static BuildContext get context => _navigatorKey.currentContext!;
  static NavigatorState get navigatorState => _navigatorKey.currentState!;
}