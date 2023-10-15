import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:crow/util/crypto_util.dart';
import 'package:crow/util/storage_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';


class LockrService {
  static Future<Tuple2<bool,String>> create(String lockrName, String password) async {
    StorageUtil.deleteAll();
    final appSupDir = await getApplicationSupportDirectory();
    File('${appSupDir.path}/Hello.txt').writeAsStringSync('Hello World!');
    final temporaryZipFile = File('${appSupDir.path}/temp.zip');
    ZipFileEncoder().zipDirectory(appSupDir, filename: temporaryZipFile.path);
    final encryptedZip = CryptoUtil.encrypt(password, temporaryZipFile.readAsBytesSync());
    temporaryZipFile.deleteSync();
    final encryptedTemporaryFile = File('${appSupDir.path}/temp.lkr');
    encryptedTemporaryFile.writeAsStringSync(encryptedZip);
    final result = await StorageUtil.saveFile(lockrName, encryptedTemporaryFile.path);
    StorageUtil.deleteAll();
    return result;
  }


  static Future<bool> loadFromStorage(String lockrPath, String password) async {
    StorageUtil.deleteAll();
    final appSupDir = await getApplicationSupportDirectory();
    // 1. Decrypt *.lkr file.
    Uint8List bytes = CryptoUtil.decrypt(password, File(lockrPath).readAsStringSync());
    // 2. Write bytes to a temporary *.zip file.
    final temporaryZipFile = File('${appSupDir.path}/temp.zip');
    temporaryZipFile.writeAsBytesSync(bytes);
    // 3. Extract the temporary *.zip file.
    final archive = ZipDecoder().decodeBuffer(InputFileStream(temporaryZipFile.path));
    extractArchiveToDisk(archive, '${appSupDir.path}/');
    temporaryZipFile.deleteSync();
    return true;
  }


  static Future<bool> saveToStorage(String lockrName, String password) async {
    final appSupDir = await getApplicationSupportDirectory();
    // 1. Create temporary ZIP project.
    final temporaryZipFile = File('${appSupDir.path}/temp.zip');
    ZipFileEncoder().zipDirectory(appSupDir, filename: temporaryZipFile.path);
    // 2. Encrypt ZIP file with same password.
    final encryptedZip = CryptoUtil.encrypt(password, temporaryZipFile.readAsBytesSync());
    temporaryZipFile.deleteSync();
    final encryptedTemporaryFile = File('${appSupDir.path}/temp.lkr');
    encryptedTemporaryFile.writeAsStringSync(encryptedZip);
    // 3. Export encrypted file.
    // TODO: Find a way to store it without asking for the location again!
    final result = await StorageUtil.saveFile(lockrName, encryptedTemporaryFile.path);

    if (!result.item1) {
      return false;
    }

    encryptedTemporaryFile.deleteSync();
    return true;
  }
}