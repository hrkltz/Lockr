import 'dart:io';
import 'package:crow/service/lockr_service.dart';
import 'package:crow/util/mixed_util.dart';
import 'package:crow/util/navigator_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class LockrView extends StatefulWidget {
  static const routeName = '/main';
  final String path;


  const LockrView({super.key, required this.path});


  @override
  State<LockrView> createState() => _LockrView();
}


class _LockrView extends State<LockrView> {
  late TextEditingController _passwordController;
  late TextEditingController _contentController;
  
  
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
  

  Future<void> _loadContent() async {
    var isLoaded = await LockrService.loadFromStorage(widget.path, _passwordController.text);
    
    if (!isLoaded) {
      throw Exception();
    }

    final appSupDir = await getApplicationSupportDirectory();
    _contentController.text = File('${appSupDir.path}/Hello.txt').readAsStringSync();
    setState(() {});
  }


  void _showPasswordDialog() {
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
            _adaptiveAction(
              context: context2,
              onPressed: () => NavigatorUtil.popHome(MixedUtil.navigatorState),
              child: const Text('Cancel'),
            ),
            _adaptiveAction(
              context: context2,
              onPressed: () {
                _loadContent().then((value) {
                  Navigator.pop(context2, 'OK');
                }).onError((error, stackTrace) {
                  _passwordController.clear();
                  _showPasswordEmptyDialog();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }


  void _showPasswordEmptyDialog() {
    showAdaptiveDialog<String>(
      context: MixedUtil.context,
      builder: (BuildContext context2) {
        return AlertDialog.adaptive(
          content: const Text('Wrong password.'),
          actions: <Widget>[
            _adaptiveAction(
              context: context2,
              onPressed: () => NavigatorUtil.popHome(MixedUtil.navigatorState),
              child: const Text('Cancel'),
            ),
            _adaptiveAction(
              context: context2,
              onPressed: () => NavigatorUtil.pop(MixedUtil.navigatorState),
              child: const Text('Try Again'),
            ),
          ],
        );
      }
    );
  }


  @override
  void initState() {
    super.initState();
    StorageUtil.deleteAll();
    _passwordController = TextEditingController();
    _contentController = TextEditingController();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) => _showPasswordDialog());
  }


  @override
  void dispose() {
    StorageUtil.deleteAll();
    _passwordController.dispose();
    _contentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          middle: Text(basenameWithoutExtension(widget.path)),
          trailing: GestureDetector(
            child: const Text(
              'Save',
              style: TextStyle(
                color: CupertinoColors.systemBlue
              ),
            ),
            onTap: () async {
              final appSupDir = await getApplicationSupportDirectory();
              File('${appSupDir.path}/Hello.txt').writeAsStringSync(_contentController.text);
              LockrService.saveToStorage(basenameWithoutExtension(widget.path), _passwordController.text)
                .then((value) {
                  // TODO: Show succcess toast.
                })
                .onError((error, stackTrace) {
                  // TODO: Show error toast.
                }
              );
            },
          ),
        ),
        child: Center(
          child: _contentController.text.isNotEmpty ? 
            CupertinoTextField.borderless(controller: _contentController,) : 
            const CupertinoActivityIndicator()
        ),
      );
    } else {
      return const Scaffold(body: Center(child: Text('TODO')));
    }
  }
}