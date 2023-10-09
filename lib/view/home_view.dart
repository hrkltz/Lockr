import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crow/crypto_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:crow/storage_util.dart';
import 'package:crow/view/main_view.dart';
import 'package:path_provider/path_provider.dart';


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
              largeTitle: Text('Lox'),
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
                    onTap: () async {
                      StorageUtil.deleteAll();
                      // 2. Create an app internal directoy
                      final appSupDir = await getApplicationSupportDirectory();
                      File('${appSupDir.path}/Hello.txt').writeAsStringSync('Hello Unnamed!');
                      // 3. Create temporary ZIP project.
                      final temporaryZipFile = File('${appSupDir.path}/Unnamed.zip');
                      ZipFileEncoder().zipDirectory(appSupDir, filename: temporaryZipFile.path);
                      // 4. Encrypt ZIP file.
                      final encryptedZip = CryptoUtil.encryptBytes(temporaryZipFile.readAsBytesSync());
                      final encryptedTemporaryFile = File('${appSupDir.path}/Unnamed.lox');
                      encryptedTemporaryFile.writeAsStringSync(encryptedZip);
                      // 5. Export encrypted file.
                      //await Share.shareXFiles([XFile(encryptedTemporaryFile.path)]);
                      final result = await StorageUtil.saveFile(encryptedTemporaryFile.path);
                      StorageUtil.deleteAll();

                      if (!result.item1) {
                        return;
                      }

                      if (!mounted) {
                        return;
                      }

                      Navigator.pushNamed(context, MainView.routeName, arguments: result.item2);
                    },
                    //onTap: () => Navigator.pushNamed(context, CreateView.routeName),
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
                    title: const Text('Dieter'),
                    additionalInfo: const Text('iCloud/Lox/Dieter.lox'),
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
          title: const Text('Lox'),
        ),
        body: null,
      );
    }
  }
}