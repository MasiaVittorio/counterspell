import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:share_plus/share_plus.dart';

extension ShareOrSave on File {
  Future<String?> save() async {
    final result = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(sourceFilePath: path));
    return result;
  }

  Future<ShareResult?> share() async {
    final result = await SharePlus.instance.share(ShareParams(
      files: [XFile(path)],
    ));

    return result;
  }
}
