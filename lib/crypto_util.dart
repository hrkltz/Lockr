
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';


// AES key size
const KEY_SIZE = 32; // 32 byte key for AES-256
const ITERATION_COUNT = 1000;


class CryptoUtil {
  static Uint8List _createUint8ListFromString(String s) {
    var ret = Uint8List(s.length);

    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }

    return ret;
  }


  static Uint8List _deriveKey(dynamic password,{ String salt = '', int iterationCount = ITERATION_COUNT, int derivedKeyLength = KEY_SIZE}) {
    if (password == null || password.isEmpty) {
      throw ArgumentError('password must not be empty');
    }

    if (password is String) {
      password = _createUint8ListFromString(password);
    }

    Uint8List saltBytes = _createUint8ListFromString(salt);
    Pbkdf2Parameters params = Pbkdf2Parameters(saltBytes, iterationCount, derivedKeyLength);
    KeyDerivator keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    keyDerivator.init(params);

    return keyDerivator.process(password);
  }


  static void test(String plainContent)
  {
    var key = Key.fromUtf8('my 32 length key................');
    var iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainContent, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print(decrypted);
  }


  static String encryptBytes(Uint8List bytes)
  {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromUtf8('MyInitialVector');
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return encrypted.base64;
  }


  static Uint8List decryptBytes(String encryptedContent)
  {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromUtf8('MyInitialVector');
    final encrypter = Encrypter(AES(key));
    return Uint8List.fromList(encrypter.decryptBytes(Encrypted.fromBase64(encryptedContent), iv: iv));
  }


  static String encryptString(String plainContent)
  {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromUtf8('MyInitialVector');
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainContent, iv: iv);
    return encrypted.base64;
  }


  static String decryptString(String encryptedContent)
  {
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromUtf8('MyInitialVector');
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.from64(encryptedContent), iv: iv);
  }
}