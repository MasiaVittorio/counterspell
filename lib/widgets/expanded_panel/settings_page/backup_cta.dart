import 'dart:io';

import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/backups/file_backup_alert.dart';
import 'package:counter_spell/widgets/components/common/small_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sid_base/sid_base.dart';

class BackupCallToAction extends StatefulWidget {
  const BackupCallToAction({super.key});

  @override
  State<BackupCallToAction> createState() => _BackupCallToActionState();
}

class _BackupCallToActionState extends State<BackupCallToAction> {
  String? message;
  bool working = false;
  File? generated;

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  void clear() async {
    if (await generated?.exists() ?? false) generated?.delete();
  }

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;

    return CallToAction(
      action: working ? null : () => generate(context, counterSpell),
      iconOnTheRight: false,
      horizontalMargin: 0,
      label: AnimatedText(switch ((message, working)) {
        (String message, _) => message,
        (null, true) => 'Writing...',
        (null, false) => 'Backup',
      }),
      icon: switch ((message, working)) {
        (String _, _) => const Icon(Icons.error_outline),
        (null, true) => const SmallProgressIndicator(),
        (null, false) => Icon(MdiIcons.trayArrowUp),
      },
    );
  }

  void generate(BuildContext context, CounterSpell counterSpell) async {
    generated = null;
    working = true;
    message = null;
    setState(() {});

    generated = await counterSpell.leaderboardsLogic.writeBackupFile();

    setState(() {
      working = false;
      if (generated == null) {
        message = 'Error generating the backup';
      }
    });

    if (!context.mounted) return;
    if (!mounted) return;
    if (generated case File file) {
      context.panelFrame.showAlert(BackupExportAlert(file: file));
    }
  }
}

extension ShareOrSave on File {
  Future<String?> save() async {
    final result = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(sourceFilePath: path),
    );
    return result;
  }

  Future<ShareResult?> share() async {
    final result = await SharePlus.instance.share(
      ShareParams(files: [XFile(path)]),
    );

    return result;
  }
}
