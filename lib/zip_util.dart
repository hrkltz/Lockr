import 'dart:io';

import 'package:archive/archive_io.dart';


class ZipUtil {
  static void zip(Directory directory, File outputFile)
  {
    ZipFileEncoder().zipDirectory(directory, filename: outputFile.path);
  }
}