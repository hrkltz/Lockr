import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:crow/util/crypto_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:crow/view/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class CreateView extends StatefulWidget {
  static const routeName = '/create';


  const CreateView({super.key});


  @override
  State<CreateView> createState() => _CreateView();
}


class _CreateView extends State<CreateView> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('New'),
          trailing: GestureDetector(
            child: const Text(
              'Create',
              style: TextStyle(
                color: CupertinoColors.systemBlue
              )
            ),
            onTap: () async {
              StorageUtil.deleteAll();
              // 2. Create an app internal directoy
              final appSupDir = await getApplicationSupportDirectory();
              File('${appSupDir.path}/Hello.txt').writeAsStringSync('Hello ${_nameController.text}!');
              // 3. Create temporary ZIP project.
              final temporaryZipFile = File('${appSupDir.path}/${_nameController.text}.zip');
              ZipFileEncoder().zipDirectory(appSupDir, filename: temporaryZipFile.path);
              // 4. Encrypt ZIP file.
              final encryptedZip = CryptoUtil.encrypt(_passwordController.text, temporaryZipFile.readAsBytesSync());
              final encryptedTemporaryFile = File('${appSupDir.path}/${_nameController.text}.lkr');
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
          ),
        ),
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              hasLeading: true,
              children: <CupertinoListTile>[
                CupertinoListTile(
                  title: CupertinoTextField(
                    autocorrect: false,
                    placeholder: 'Name',
                    controller: _nameController,
                  ),
                ),
                CupertinoListTile(
                  title: CupertinoTextField(
                    autocorrect: false,
                    obscureText: true,
                    placeholder: 'Password',
                    controller: _passwordController,
                  ),
                ),
              ],
            ),
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