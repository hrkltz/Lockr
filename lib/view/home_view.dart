import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crow/crypto_util.dart';
import 'package:crow/navigator_util.dart';
import 'package:crow/storage_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class HomeView extends StatefulWidget {
  static const routeName = '/';


  const HomeView({super.key});


  @override
  State<HomeView> createState() => _HomeView();
}


class _HomeView extends State<HomeView> {
  final myTextController = TextEditingController();
  final myTextController2 = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Lox'),
          trailing: TextButton(
              onPressed: () {
                NavigatorUtil.pushNamed('/main', arguments: '/home/test/HelloWorld.lox');
                /* showPlatformModalSheet */
                /* BACKUP showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => _buildCreateBottomSheet(context),
                ); */
              },
              child: const Icon(
                CupertinoIcons.add,
              ),
            ),
          ),
          child: Column(
            children: [
                CupertinoTextField(
                  placeholder: 'Name',
                  maxLines: 1,
                  controller: myTextController,
                ),
                FilledButton(
                  onPressed: () async {
                    StorageUtil.deleteAll();
                    // 1. Get CupertinoTextField input as fileName
                    final lockboxName = myTextController.text;
                    // 2. Create an app internal directoy
                    final appSupDir = await getApplicationSupportDirectory();
                    final Directory directory = Directory('${appSupDir.path}/$lockboxName/');
                    await directory.create();
                    File('${appSupDir.path}/$lockboxName/Hello.txt').writeAsStringSync('Hello $lockboxName!');
                    // 3. Create temporary ZIP project.
                    final temporaryZipFile = File('${appSupDir.path}/$lockboxName.zip');
                    ZipFileEncoder().zipDirectory(directory, filename: temporaryZipFile.path);
                    // 4. Encrypt ZIP file.
                    final encryptedZip = CryptoUtil.encryptBytes(temporaryZipFile.readAsBytesSync());
                    final encryptedTemporaryFile = File('${appSupDir.path}/$lockboxName.lox');
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

                    Navigator.pushNamed(context, '/main', arguments: result.item2);
                  },
                  child: const Text('Create')),

                FilledButton(
                  onPressed: () async {
                    StorageUtil.deleteAll();
                    final result = await StorageUtil.selectFile();

                    if (!result.item1)
                    {
                      return;
                    }

                    /*Uint8List bytes = CryptoUtil.decryptBytes(File(result.item2).readAsStringSync());
                    final appSupDir = await getApplicationSupportDirectory();
                    final temporaryZipFile = File('${appSupDir.path}/x.zip');
                    temporaryZipFile.writeAsBytesSync(bytes);
                    final archive = ZipDecoder().decodeBuffer(InputFileStream(temporaryZipFile.path));
                    extractArchiveToDisk(archive, '${appSupDir.path}/x/');
                    print(File('${appSupDir.path}/x/Hello.txt').readAsStringSync());
                    StorageUtil.deleteAll();*/

                    if (!mounted) {
                      return;
                    }

                    Navigator.pushNamed(context, '/main', arguments: result.item2);
                  },
                  child: const Text('Open')),
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