import 'dart:io';
import 'package:crow/util/crypto_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:crow/view/create_view.dart';
import 'package:crow/view/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  static const routeName = '/';


  const HomeView({super.key});


  @override
  State<HomeView> createState() => _HomeView();
}


class _HomeView extends State<HomeView> {
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
                    onTap: () => Navigator.pushNamed(context, CreateView.routeName),
                  ),
                  CupertinoListTile(
                    title: const Text('Open Existing'),
                    leading: const Icon(CupertinoIcons.archivebox),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () async {
                      StorageUtil.selectFile().then((value) {
                        if (!value.item1)
                        {
                          return;
                        }

                        Navigator.pushNamed(context, MainView.routeName, arguments: value.item2);
                      });
                    },
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                hasLeading: false,
                children: <CupertinoListTile>[
                  CupertinoListTile(
                    title: const Text('Work'),
                    additionalInfo: const Text('iCloud/Lockr/Work.lkr'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () async {
                      Navigator.pushNamed(context, '/main', arguments: '/path/test');
                    },
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