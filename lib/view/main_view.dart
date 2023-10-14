import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:crow/util/crypto_util.dart';
import 'package:crow/util/mixed_util.dart';
import 'package:crow/util/navigator_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class MainView extends StatefulWidget {
  static const routeName = '/main';
  final String path;


  const MainView({super.key, required this.path});


  @override
  State<MainView> createState() => _MainView();
}


class _MainView extends State<MainView> {
  late TextEditingController _passwordController;
  String _data = '';


  void _load() {
    Uint8List bytes = CryptoUtil.decrypt(_passwordController.text, File(widget.path).readAsStringSync());
    getApplicationSupportDirectory()
      .then((appSupDir) {
        final basename = basenameWithoutExtension(widget.path);
        final temporaryZipFile = File('${appSupDir.path}/$basename.zip');
        temporaryZipFile.writeAsBytesSync(bytes);
        final archive = ZipDecoder().decodeBuffer(InputFileStream(temporaryZipFile.path));
        extractArchiveToDisk(archive, '${appSupDir.path}/$basename/');
        _data = File('${appSupDir.path}/$basename/Hello.txt').readAsStringSync();
        setState(() {});
      })
      .onError((error, stackTrace) {
        NavigatorUtil.pop(MixedUtil.navigatorState);
      });
  }


  @override
  void initState() {
    super.initState();
    StorageUtil.deleteAll();
    _passwordController = TextEditingController();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) =>
      showAdaptiveDialog<String>(
        context: MixedUtil.context,
        builder: (BuildContext context2) {
          return AlertDialog.adaptive(
            content: CupertinoTextField(
              autocorrect: false,
              obscureText: true,
              placeholder: 'Password',
              controller: _passwordController,
            ),
            actions: <Widget>[
              adaptiveAction(
                context: context2,
                onPressed: () => NavigatorUtil.popHome(MixedUtil.navigatorState),
                child: const Text('Cancel'),
              ),
              adaptiveAction(
                context: context2,
                onPressed: () {
                  _load();
                  Navigator.pop(context2, 'OK');
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      )
    );
  }


  @override
  void dispose() {
    StorageUtil.deleteAll();
    _passwordController.dispose();
    super.dispose();
  }


  Future<String> getContent() async
  {
    final appSupDir = await getApplicationSupportDirectory();
    final basename = basenameWithoutExtension(widget.path);
    return File('${appSupDir.path}/$basename/Hello.txt').readAsStringSync();
  }
  
  
  Widget adaptiveAction({required BuildContext context, required VoidCallback onPressed, required Widget child}) {
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


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Text(basenameWithoutExtension(widget.path)),
          ),
        child: Center(
          child: _data.isNotEmpty ? 
            Text(_data) : 
            const CupertinoActivityIndicator()
        ),
      );
    } else {
      return const Scaffold(body: Center(child: Text('TODO')));
    }
  }
}