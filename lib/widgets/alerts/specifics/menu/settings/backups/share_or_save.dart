import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:share_plus/share_plus.dart';

extension ShareOrSave on File {

  Future<String?> save() => FlutterFileDialog.saveFile(params: SaveFileDialogParams(sourceFilePath: path));

  Future<ShareResult?> share() => Share.shareXFiles([XFile(path)]);

}