import 'dart:io';
import 'package:crow/service/lockr_service.dart';
import 'package:crow/view/lockr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
          middle: const Text('Lockr'),
          trailing: GestureDetector(
            child: const Text(
              'Create',
              style: TextStyle(
                color: CupertinoColors.systemBlue
              )
            ),
            onTap: () {
              LockrService.create(_nameController.text, _passwordController.text).then((value) {
                if (!value.item1) {
                  return;
                }

                Navigator.pushReplacementNamed(context, LockrView.routeName, arguments: value.item2);
              });
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