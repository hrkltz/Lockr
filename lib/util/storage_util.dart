import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';


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
  static void deleteAll()
  {
    getApplicationSupportDirectory().then((value) {
      value.listSync(recursive: false).forEach((element) {
        element.deleteSync(recursive: true);
      });
    });
  }


  static Future<String> selectFile() async
  {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();

    if (filePickerResult == null) {
      throw Exception();
    }

    return filePickerResult.files[0].path!;
  }


  static Future<({bool isSuccess, String filePath})> saveFile(String lockrName, String sourceFilePath) async {
    final params = SaveFileDialogParams(sourceFilePath: sourceFilePath, fileName: '$lockrName.lkr');
    final filePath = await FlutterFileDialog.saveFile(params: params);

    if (filePath == null) {
      return (isSuccess: false, filePath: '');
    }

    return (isSuccess: true, filePath: filePath);
  }


  // TODO: saveFil(..) function without asking for the path. Each interaction should also save the file!
}