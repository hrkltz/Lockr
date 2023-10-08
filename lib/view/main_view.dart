import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crow/crypto_util.dart';
import 'package:crow/navigator_util.dart';
import 'package:crow/storage_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class MainView extends StatefulWidget {
  static const routeName = '/main';
  final String path;


  const MainView({super.key, required this.path});


  @override
  State<MainView> createState() => _MainView();
}


class _MainView extends State<MainView> {
  @override
  void initState() {
    StorageUtil.deleteAll();
    super.initState();
  }


  @override
  void didChangeDependencies() {
    Uint8List bytes = CryptoUtil.decryptBytes(File(widget.path).readAsStringSync());
    getApplicationSupportDirectory()
      .then((appSupDir) {
        final basename = basenameWithoutExtension(widget.path);
        final temporaryZipFile = File('${appSupDir.path}/$basename.zip');
        temporaryZipFile.writeAsBytesSync(bytes);
        final archive = ZipDecoder().decodeBuffer(InputFileStream(temporaryZipFile.path));
        extractArchiveToDisk(archive, '${appSupDir.path}/$basename/');
        // print(File('${appSupDir.path}/$basename/Hello.txt').readAsStringSync());
      })
      .onError((error, stackTrace) {
        NavigatorUtil.pop();
      });
    
    super.didChangeDependencies();
  }
  

  @override
  void dispose() {
    StorageUtil.deleteAll();
    super.dispose();
  }


  Future<String> getContent() async
  {
    final appSupDir = await getApplicationSupportDirectory();
    final basename = basenameWithoutExtension(widget.path);
    return File('${appSupDir.path}/$basename/Hello.txt').readAsStringSync();
  }


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Text(basenameWithoutExtension(widget.path)),
          ),
        child: FutureBuilder<String>(
          future: getContent(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Text(snapshot.data!);
          },
        ),
      );
    } else {
      return const Scaffold(body: Center(child: Text('TODO')));
    }
  }
}