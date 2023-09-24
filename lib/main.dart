import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:archive/archive.dart';

import 'package:crow/battery.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return const CupertinoApp(
        theme: CupertinoThemeData(
            barBackgroundColor: CupertinoColors.extraLightBackgroundGray,
            primaryColor: CupertinoColors.destructiveRed),
        home: MyHomePage(
          title: 'Ios',
        ),
      );
    } else {
      return MaterialApp(
        title: 'Android',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Android'),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* BACKUP static const MethodChannel _containerChannel = MethodChannel('container'); */
  final myTextController = TextEditingController();
  String _outputLocation = '';
  String _projectLocation = '';


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTextController.dispose();
    super.dispose();
  }

  /* BACKUP static Future<void> createContainer(String containerLabel) async {
    // Errors occurring on the platform side cause invokeMethod to throw
    // PlatformExceptions.
    try {
      return _containerChannel.invokeMethod('create', <String, dynamic>{
        'containerLabel': containerLabel,
      });
    } on PlatformException catch (e) {
      throw ArgumentError('${e.message}');
    }
  } */


  /* BACKUP Widget _buildCreateBottomSheet(BuildContext context) {
    // TODO: CupertinoFullscreenDialogTransition for the desired iOS like dialog effect!
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        leading: TextButton(
          child: const Icon(
            CupertinoIcons.clear,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('New Container'),
        trailing: TextButton(
          child: const Icon(
            CupertinoIcons.check_mark,
          ),
          onPressed: () {
            //createContainer('heyFlutter').then((value) => Navigator.pop(context));
            _createZip();
          },
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            /*const CupertinoTextField(
              placeholder: 'Name',
              maxLines: 1,
            ),*/
            TextButton(
              onPressed: () async {
                /*String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                print('selectedDirectory: $selectedDirectory');

                if (selectedDirectory == null) {
                  return;
                }

                _projectLocation = selectedDirectory;*/
                setState(() {});
                try {
                  String? path = await FilePicker.platform.getDirectoryPath(
                    dialogTitle: 'dialogTitle',
                    initialDirectory: '',
                    lockParentWindow: false,
                  );

                  setState(() {
                    print('Path: $path');
                    print('User aborted: ${path == null}');
                  });
                } on PlatformException catch (e) {
                  print('Unsupported operation' + e.toString());
                } catch (e) {
                  print(e.toString());
                } finally {
                  setState(() {});
                }
              },
              child: Text("Project Location: $_projectLocation")),
            TextButton(
              onPressed: () async {
                String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                if (selectedDirectory == null) {
                  return;
                }

                _outputLocation = selectedDirectory;
                setState(() {});
              },
              child: Text("Output Location: $_outputLocation"))
          ],
        ),
      ),
    );
  } */


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search), label: "Search"),
          ]),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoPageScaffold(
                  backgroundColor: Colors.white,
                  navigationBar: CupertinoNavigationBar(
                    middle: const Text('Home'),
                    trailing: TextButton(
                        onPressed: () {
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
                        FilledButton(
                          onPressed: () async {
                            const fileName = 'helloWorld.txt';
                            const fileContent = 'Hello World!';
                            final directory = await getApplicationDocumentsDirectory();
                            final file = File('${directory.path}/$fileName');
                            await file.writeAsString(fileContent);
                          },
                          child: const Text('1. Create helloWorld.txt')),
                        FilledButton(
                          onPressed: () async {
                            const fileName = 'helloWorld.txt';
                            final directory = await getApplicationDocumentsDirectory();
                            final file = File('${directory.path}/$fileName');
                            Share.shareXFiles([XFile(file.path)]);
                          },
                          child: const Text('2. Share helloWorld.txt')),
                        FilledButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              File file = File(result.files.single.path ?? "");
                              file.readAsString().then((value) => print(value));
                            } else {
                              log("User canceled the election");
                            }
                          },
                          child: const Text('3. Open helloWorld.txt')),
                          Container(
                            height: 1.0,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          CupertinoTextField(
                            placeholder: 'Name',
                            maxLines: 1,
                            controller: myTextController,
                          ),
                          FilledButton(
                            onPressed: () async {
                              // 1. Get CupertinoTextField input as fileName
                              final lockboxName = myTextController.text;
                              // 2. Create an app internal directoy
                              final appDocDir = await getApplicationDocumentsDirectory();
                              final Directory directory = Directory('${appDocDir.path}/$lockboxName/');
                              await directory.create();
                              final File file = File('${appDocDir.path}/$lockboxName.lockbox');
                              await file.create();
                              print(jsonEncode(appDocDir.listSync().map((e) => e.path).toList()));
                              // 3. Compress it to zip.
                              final zipFile = File('${appDocDir.path}/$lockboxName.zip');
                              final zipFileEncoder = ZipFileEncoder();
                              zipFileEncoder.zipDirectory(directory, filename: zipFile.path);
                              // 4. Open share dialog to export zip.
                              Share.shareXFiles([XFile(zipFile.path)]);
                            },
                            child: const Text('Create New LockBox!')),
                      ],
                    ),
                  );
              case 1:
                return Center(child: Text("Hallo"));
              case 2:
                return Center(child: Text("Hallo"));
              default:
                return Center(child: Text("Hallo"));
            }
          });
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(
          child: Battery(),
        ),
      );
    }
  }
}
