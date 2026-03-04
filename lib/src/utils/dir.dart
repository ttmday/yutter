import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DirUtils {
  static Future<String> getAppPath() async {
    String mainPath = await _getMainPath();
    // String folder = 'Yutter';
    Directory dir = Directory(p.join(mainPath, "Music"));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  static Future<String> getAppVideoPath() async {
    String mainPath = await _getMainPath();
    // String folder = 'Yutter';
    Directory dir = Directory(p.join(mainPath, "Movies"));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  static Future<String> getAppAudioPath() async {
    String mainPath = await _getMainPath();
    // String folder = 'Yutter';
    Directory dir = Directory(p.join(mainPath, "Music", "_main_"));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  static Future<String> _getMainPath() async {
    String appDownloadsPath = "";
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      List<String> paths = dir!.path.split('/');
      for (var i in paths) {
        if (i == "Android") break;
        appDownloadsPath += "$i/";
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      appDownloadsPath = dir.path;
    }
    return appDownloadsPath;
  }
}
