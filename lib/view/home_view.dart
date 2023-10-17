import 'dart:io';
import 'package:crow/service/lockr_service.dart';
import 'package:crow/util/mixed_util.dart';
import 'package:crow/util/navigator_util.dart';
import 'package:crow/util/preferences_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:crow/view/lockr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


class HomeView extends StatefulWidget {
  static const routeName = '/';


  const HomeView({super.key});


  @override
  State<HomeView> createState() => _HomeView();
}


class _HomeView extends State<HomeView> {
  Widget _adaptiveAction({required BuildContext context, required VoidCallback onPressed, required Widget child}) {
    final ThemeData theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }


  List<String> previousOpenedLockrContainers = List.empty();


  @override
  void initState() {
    super.initState();
    PreferencesUtil.init().then((_) {
        previousOpenedLockrContainers = PreferencesUtil.getItems();
        setState(() {});
    });
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Lockr'),
            ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              CupertinoListSection.insetGrouped(
                hasLeading: true,
                children: <CupertinoListTile>[
                  CupertinoListTile(
                    title: const Text('Create New'),
                    leading: const Icon(CupertinoIcons.add),
                    trailing: const CupertinoListTileChevron(),
                    onTap:() {
                      showAdaptiveDialog<(String, String)>(
                        context: context,
                        builder: (BuildContext context2) {
                          final TextEditingController nameController = TextEditingController();
                          final TextEditingController passwordController = TextEditingController();

                          return AlertDialog.adaptive(
                            title: const Text('Create New'),
                            content: Column(
                              children: [
                                const SizedBox(height: 20.0, width: double.infinity,),
                                CupertinoTextField(
                                  autocorrect: false,
                                  placeholder: 'Name',
                                  controller: nameController,
                                ),
                                const SizedBox(height: 10.0, width: double.infinity,),
                                CupertinoTextField(
                                  autocorrect: false,
                                  obscureText: true,
                                  placeholder: 'Password',
                                  controller: passwordController,
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              _adaptiveAction(
                                context: context2,
                                onPressed: () {
                                  nameController.dispose();
                                  passwordController.dispose();
                                  NavigatorUtil.pop<(String, String)>(MixedUtil.navigatorState, null);
                                },
                                child: const Text('Cancel'),
                              ),
                              _adaptiveAction(
                                context: context2,
                                onPressed: () {
                                  final name = nameController.text;
                                  final password = passwordController.text;
                                  nameController.dispose();
                                  passwordController.dispose();
                                  NavigatorUtil.pop<(String, String)>(MixedUtil.navigatorState, (name, password));
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }
                      ).then((value) {
                        if (value == null) {
                          return;
                        }
                        
                        LockrService.create(value.$1, value.$2).then((value) {
                          if (!value.isSuccess) {
                            NavigatorUtil.popHome(MixedUtil.navigatorState);
                            return;
                          }

                          Navigator.pushNamed(context, LockrView.routeName, arguments: value.filePath);
                        });
                      });
                    },
                  ),
                  CupertinoListTile(
                    title: const Text('Open Existing'),
                    leading: const Icon(CupertinoIcons.archivebox),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      StorageUtil.selectFile().then((value) {
                        Navigator.pushNamed(context, LockrView.routeName, arguments: value);
                      });
                    },
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                hasLeading: false,
                children: <CupertinoListTile>[
                  if (previousOpenedLockrContainers.isEmpty)
                    ...[const CupertinoListTile(
                    title: Text('History is empty.'),
                    )]
                  else
                    ...previousOpenedLockrContainers.map((value) => CupertinoListTile(
                      title: Text(basenameWithoutExtension(value)),
                      additionalInfo: Text(value),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () async {
                        Navigator.pushNamed(context, '/main', arguments: '/path/test');
                      })
                    ),
                ],
              ),
            ],
          ),),
          ],
        ),
        );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Lockr'),
        ),
        body: null,
      );
    }
  }
}