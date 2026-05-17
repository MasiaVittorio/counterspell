import 'dart:io';

import 'package:counter_spell/widgets/expanded_panel/settings_page/backup_cta.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sid_base/sid_base.dart';

class BackupExportAlert extends StatefulWidget {
  const BackupExportAlert({super.key, required this.file});

  final File file;

  @override
  State<BackupExportAlert> createState() => _BackupExportAlertState();
}

class _BackupExportAlertState extends State<BackupExportAlert> {
  @override
  void dispose() {
    widget.file.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;
    return AlternativesPanelAlert(
      title: const Text('Backup file ready'),
      alternatives: [
        PanelAlternative(
          value: 1,
          label: const Text('Save'),
          icon: Icon(MdiIcons.folderDownloadOutline),
        ),
        const PanelAlternative(
          value: 2,
          label: Text('Share'),
          icon: Icon(Icons.share_outlined),
        ),
      ],
      autoCloseOnSubmit: false,
      onSubmit: (value) {
        switch (value) {
          case 1:
            saveFile(panelFrame);
            return;
          case 2:
            shareFile(panelFrame);
            return;
          default:
        }
      },
    );
  }

  void shareFile(PanelFrameState panelFrame) async {
    ShareResult? results;
    bool errorSharing = false;
    try {
      results = await widget.file.share();
    } catch (e) {
      errorSharing = true;
    }
    if (results == null || errorSharing) {
      panelFrame.showSnackBar(
        PanelSnackBar(child: Text('Error sharing the file'.todo)),
      );
    } else if (results.status != ShareResultStatus.success) {
      panelFrame.showSnackBar(
        PanelSnackBar(
          child: Text(switch (results.status) {
            ShareResultStatus.success => '',
            ShareResultStatus.dismissed => "Didn't share",
            ShareResultStatus.unavailable => 'Share method unavailable',
          }),
        ),
      );
    }
    panelFrame.closePanel();
  }

  void saveFile(PanelFrameState panelFrame) async {
    bool errorSaving = false;
    String? savedPath;
    // try {
    savedPath = await widget.file.save();
    // } catch (e) {
    //   print('//////// Error saving the file: $e');
    //   errorSaving = true;
    // }

    if (savedPath == null || errorSaving) {
      panelFrame.showSnackBar(
        PanelSnackBar(child: Text('Error saving the file'.todo)),
      );
    }
    panelFrame.closePanel();
  }
}
