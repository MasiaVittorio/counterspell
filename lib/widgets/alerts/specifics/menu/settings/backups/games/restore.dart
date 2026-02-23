import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/backup_logic.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class RestoreGamesCard extends StatefulWidget {
  const RestoreGamesCard({super.key});

  @override
  State<RestoreGamesCard> createState() => _RestoreGamesCardState();
}

class _RestoreGamesCardState extends State<RestoreGamesCard> {
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

  Widget get text => const Text("Restore games from any external file");

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
    final String? filePath = await FlutterFileDialog.pickFile(params: params);
    if (filePath == null) {
      return null;
    } else {
      return File(filePath);
    }
  }

  Future<void> reactToFile(File file, StageData stage, CSBloc logic) async {
    final result = await logic.backups.readPastGames(file);

    if (result.error) {
      setState(() {
        error = true;
        message = result.errorMessage ?? "Unknown error";
      });
      return;
    }

    final newPastGames = result.games;
    if (newPastGames == null) {
      setState(() {
        error = true;
        message = result.errorMessage ?? "Unknown error";
      });
      return;
    } else if (newPastGames.isEmpty) {
      setState(() {
        error = true;
        message = "The file was empty";
      });
      return;
    } else {
      stage.showAlert(
        ConfirmAlert(
          action: () async {
            final res = await logic.backups.restorePastGames(newPastGames);
            if (res) {
              file.delete();
            }
          },
          warningText: "Merge ${newPastGames.length} games from this file?",
        ),
        size: ConfirmAlert.height,
      );
    }
  }
}
