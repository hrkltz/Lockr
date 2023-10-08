import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';


/* Some Notes:
  To enables files access to Documents/ set the following keys inside Info.plist:
    <key>UIFileSharingEnabled</key>
    <true/>
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>

  Private -> getApplicationSupportDirectory();
  Public -> getApplicationDocumentsDirectory();

  Remember that files in Documents/ and Application Support/ are backed up by default. You can exclude files from the backup by calling -[NSURL setResourceValue:forKey:error:] using the NSURLIsExcludedFromBackupKey key.
*/
class StorageUtil {
  static void deleteAll() async
  {
    print('StorageUtil.deleteAll()');
    final appDocDir = await getApplicationDocumentsDirectory();

    appDocDir.listSync(recursive: false).forEach((element) {
      element.deleteSync(recursive: true);
    });
  }


  static void listAll() async
  {
    print('StorageUtil.listAll()');
    final appDocDir = await getApplicationDocumentsDirectory();

    appDocDir.listSync(recursive: true).forEach((element) {
      print('> ${element.path}');
    });
  }


  static Future<Tuple2<bool, String>> selectFile() async
  {
    print('StorageUtil.selectFile()');
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();

    if (filePickerResult == null) {
      return const Tuple2(false, '');
    }

    return Tuple2(true, filePickerResult.files[0].path!);
  }


  static Future<Tuple2<bool, String>> selectDirectory() async
  {
    print('StorageUtil.selectDirectory()');
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath == null) {
      return const Tuple2(false, '');
    }

    return Tuple2(true, directoryPath);
  }


  static Future<Tuple2<bool, String>> saveFile(String sourceFilePath) async {
    print('StorageUtil.saveFile()');
    final params = SaveFileDialogParams(sourceFilePath: sourceFilePath);
    final filePath = await FlutterFileDialog.saveFile(params: params);

    if (filePath == null) {
      return const Tuple2(false, '');
    }

    return Tuple2(true, filePath);
  }


  // TODO: saveFil(..) function without asking for the path. Each interaction should also save the file!
}