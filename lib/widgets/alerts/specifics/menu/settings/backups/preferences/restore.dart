import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/preferences.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class RestorePreferencesCard extends StatefulWidget {
  const RestorePreferencesCard({super.key});

  @override
  State<RestorePreferencesCard> createState() => _RestorePreferencesCardState();
}

class _RestorePreferencesCardState extends State<RestorePreferencesCard> {
  String? message;
  bool error = false;
  bool working = false;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final logic = CSBloc.of(context);
    void onTap() => action(stage, logic);

    return SubSection(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      onTap: onTap,
      [
        const Spacer(),
        ListTile(
          title: text,
          leading: icon,
          subtitle: message != null
              ? Text(
                  message!,
                  style: TextStyle(color: error ? CSColors.delete : null),
                )
              : null,
        ),
        const Spacer(),
      ],
    );
  }

  Widget get text => const Text("Restore preferences from any external file");

  Widget get icon => const Icon(
        Icons.file_open,
        size: 40,
      );

  void action(StageData stage, CSBloc logic) async {
    setState(() {
      working = true;
    });
    final File? file = await pickFile();
    if (file == null) {
      setState(() {
        error = true;
        message = "Pick a file";
      });
    } else {
      reactToFile(file, stage, logic);
    }
  }

  static const params = OpenFileDialogParams(
    dialogType: OpenFileDialogType.document,
    fileExtensionsFilter: ["json"],
    copyFileToCacheDir: true,
  );

  Future<File?> pickFile() async {
    bool errorPicking = false;
    String? filePath;
    try {
      filePath = await FlutterFileDialog.pickFile(params: params);
    } catch (e) {
      errorPicking = true;
    }

    if (errorPicking) {
      setState(() {
        error = true;
        message = "Error picking the file.";
      });
    }

    if (filePath == null) {
      return null;
    } else {
      return File(filePath);
    }
  }

  Future<void> reactToFile(File file, StageData stage, CSBloc logic) async {
    final result = await logic.backups.readPreferences(file);

    if (result == null) {
      setState(() {
        error = true;
        message = "Error reading the file";
      });
    } else {
      stage.showAlert(
        ConfirmAlert(
          action: () async {
            final res = await logic.backups.restorePreferences(result);
            if (res) {
              file.delete();
            }
          },
          warningText: "Merge preferences from this file?",
        ),
        size: ConfirmAlert.height,
      );
    }
  }
}
