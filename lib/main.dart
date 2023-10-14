import 'dart:io';
import 'package:crow/util/mixed_util.dart';
import 'package:crow/view/create_view.dart';
import 'package:crow/view/home_view.dart';
import 'package:crow/view/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        theme: const CupertinoThemeData(
            barBackgroundColor: CupertinoColors.extraLightBackgroundGray,
            primaryColor: CupertinoColors.systemBlue),
        navigatorKey: MixedUtil.navigatorKey,
        routes: {
          HomeView.routeName: (context) => const HomeView(),
          CreateView.routeName: (context) => const CreateView(),
          MainView.routeName: (context) => MainView(path: ModalRoute.of(context)!.settings.arguments as String),
        },
      );
    } else {
      return MaterialApp(
        title: 'Android',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        navigatorKey: MixedUtil.navigatorKey,
        routes: {
          HomeView.routeName: (context) => const HomeView(),
          CreateView.routeName: (context) => const CreateView(),
          MainView.routeName: (context) => MainView(path: ModalRoute.of(context)!.settings.arguments as String),
        },
      );
    }
  }
}
