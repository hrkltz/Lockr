import 'dart:io';

import 'package:crow/util/crypto_util.dart';
import 'package:crow/view/create_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:crow/util/storage_util.dart';
import 'package:crow/view/main_view.dart';


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
                    title: const Text('Test2'),
                    leading: const Icon(CupertinoIcons.add),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {
                      CryptoUtil.test();
                        /*var passwordBytes = Uint8List(password.length);

                        for (var i = 0; i < password.length; i++) {
                          passwordBytes[i] = password.codeUnitAt(i);
                        }

                        const salt = "test";
                        var saltBytes = Uint8List(salt.length);

                        for (var i = 0; i < salt.length; i++) {
                          saltBytes[i] = salt.codeUnitAt(i);
                        }

                        x.Pbkdf2Parameters params = x.Pbkdf2Parameters(saltBytes, 1, 32);
                        x.KeyDerivator keyDerivator = x.PBKDF2KeyDerivator(x.HMac(x.SHA256Digest(), 64));
                        keyDerivator.init(params);
                        final key = String.fromCharCodes(keyDerivator.process(passwordBytes));
                        print(key);
                        print(key.length);*/
                    },
                  ),
                  
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
                      final result = await StorageUtil.selectFile();

                      if (!result.item1)
                      {
                        return;
                      }

                      if (!mounted) {
                        return;
                      }

                      Navigator.pushNamed(context, MainView.routeName, arguments: result.item2);
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