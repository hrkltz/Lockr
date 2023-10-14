
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';


class CryptoUtil {
  static const _iv = String.fromEnvironment('IV');


  static Uint8List _uint8ListFromString(String string) {
    final List<int> codeUnits = string.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }


  static Uint8List _deriveKey(String password) {
    if (password.isEmpty) {
      throw ArgumentError('password must not be empty');
    }

    const salt = String.fromEnvironment('SALT');
    const iterationCount = int.fromEnvironment('ITERATION_COUNT');
    const derivedKeyLength = int.fromEnvironment('DERIVED_KEY_LENGTH');

    final saltBytes = _uint8ListFromString(salt);
    Pbkdf2Parameters params = Pbkdf2Parameters(saltBytes, iterationCount, derivedKeyLength);
    KeyDerivator keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    keyDerivator.init(params);
    final passwordBytes = _uint8ListFromString(password);
    return keyDerivator.process(passwordBytes);
  }


  // Encrypt an byte array to Base64 using AES (symmetric encryption) and PBKDF2 (key derivation) and AES ().
  // PBKDF2 -> https://cryptobook.nakov.com/mac-and-key-derivation/pbkdf2
  // AES -> https://cryptobook.nakov.com/cryptography-overview
  static String encrypt(String password, Uint8List bytes)
  {
    if (password.isEmpty) {
      throw ArgumentError('password must not be empty');
    }

    Uint8List keyBytes = _deriveKey(password);
    final key = Key(keyBytes);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return encrypted.base64;
  }


  // encrypredContent needs to be stored as Base64!
  static Uint8List decrypt(String password, String encryptedContent)
  {
    Uint8List keyBytes = _deriveKey(password);
    final key = Key(keyBytes);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    return Uint8List.fromList(encrypter.decryptBytes(Encrypted.fromBase64(encryptedContent), iv: iv));
  }

  
  static void test() {
    const password = "password";
    const message = "Hello World!";
    print('Input: "Hello World!"');
    Uint8List messageBytes = _uint8ListFromString(message);
    String encryptedString = CryptoUtil.encrypt(password, Uint8List.fromList(messageBytes));
    print(encryptedString);
    messageBytes = CryptoUtil.decrypt(password, encryptedString);
    print('Output: ${String.fromCharCodes(messageBytes)}');
  }
}