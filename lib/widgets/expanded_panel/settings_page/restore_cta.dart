import 'dart:convert';
import 'dart:io';

import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class RestoreCallToAction extends StatelessWidget {
  const RestoreCallToAction({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final counterSpell = context.counterSpell;

    return CallToAction(
      action: () => action(frame, counterSpell),
      iconOnTheRight: false,
      horizontalMargin: 0,
      label: const Text('Restore'),
      icon: Icon(MdiIcons.trayArrowDown),
    );
  }

  Widget get icon => const Icon(Icons.file_open, size: 40);

  static void action(
    PanelFrameState panelFrame,
    CounterSpell counterSpell,
  ) async {
    panelFrame.closePanel();
    final File? file = await pickFile();
    if (file == null) {
      panelFrame.showSnackBar(
        PanelSnackBar(child: const Text('No file selected')),
      );
    } else {
      reactToFile(file, panelFrame, counterSpell);
    }
  }

  static const params = OpenFileDialogParams(
    dialogType: OpenFileDialogType.document,
    fileExtensionsFilter: ['json'],
    copyFileToCacheDir: true,
  );

  static Future<File?> pickFile() async {
    final String? filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath == null) {
      return null;
    } else {
      return File(filePath);
    }
  }

  static Future<void> reactToFile(
    File file,
    PanelFrameState panelFrame,
    CounterSpell counterSpell,
  ) async {
    late dynamic decoded;
    bool error = false;
    try {
      String content = await file.readAsString();
      decoded = jsonDecode(content);
    } catch (e) {
      error = true;
    }

    if (decoded == null || error) {
      panelFrame.showSnackBar(
        PanelSnackBar(child: const Text('Error reading the file')),
      );
      return;
    }

    final result = counterSpell.leaderboardsLogic.mergeBackup(
      decoded,
      panelFrame: panelFrame,
    );

    if (result case String message) {
      panelFrame.showSnackBar(PanelSnackBar(child: Text(message)));
      return;
    }
  }
}
