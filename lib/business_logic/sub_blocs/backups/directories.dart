import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'backup_logic.dart';

extension CSBackupDirectories on CSBackupBloc {
  Future<bool> initDirectories() async {
    if (!(await Permission.storage.status.isGranted)) {
      return false;
    }

    late bool success;
    try {
      storagePath = await getExternalStoragePath;
      if (storagePath == null) success = false;

      if (success) {
        backupsDirectory = await getBackupDirectory(
          backupPathFromStoragePath(storagePath!),
        );
        if (backupsDirectory == null) success = false;

        if (success) {
          pastGamesDirectory = await getPastGamesDir(
            backupsDirectory!,
          );
          if (pastGamesDirectory == null) success = false;

          if (success) {
            preferencesDirectory = await getPreferencesDir(
              backupsDirectory!,
            );
            if (preferencesDirectory == null) success = false;
          }
        }
      }
    } catch (e) {
      success = false;
    }

    if (success) return true;

    try {
      final Directory? docsDir = await getExternalStorageDirectory();

      if (docsDir == null) return false;

      this.storagePath = docsDir.path;

      backupsDirectory = await getBackupDirectory(
        backupPathFromStoragePath(storagePath!),
      );

      if (backupsDirectory == null) return false;

      pastGamesDirectory = await getPastGamesDir(
        backupsDirectory!,
      );
      if (pastGamesDirectory == null) return false;

      preferencesDirectory = await getPreferencesDir(
        backupsDirectory!,
      );
      if (preferencesDirectory == null) return false;
    } catch (e) {
      return false;
    }

    return true;
  }

  //===================================
  // Getters
  static const String backupDirName = "CounterSpell";

  static Future<String> get getExternalStoragePath async {
    final List list = await ExternalPath.getExternalStorageDirectories();

    if (list.isNotEmpty) return list.first;
    return "error";
    // return "/storage/emulated/0";
  }

  static String backupPathFromStoragePath(String _storagePath) =>
      path.join(_storagePath, backupDirName);

  static Future<Directory> getBackupDirectory(String _backupDirPath) async {
    Directory dir = Directory(_backupDirPath);
    if (!await dir.exists()) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  static const String pastGamesDirName = "PastGames";
  static Future<Directory> getPastGamesDir(Directory _backupDir) async {
    Directory dir = Directory(path.join(
      _backupDir.path,
      pastGamesDirName,
    ));
    if (!await dir.exists()) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  static const String preferencesDirName = "Preferences";
  static Future<Directory> getPreferencesDir(Directory _backupDir) async {
    Directory dir = Directory(path.join(
      _backupDir.path,
      preferencesDirName,
    ));
    if (!await dir.exists()) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }
}
