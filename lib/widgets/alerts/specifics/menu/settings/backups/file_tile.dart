import 'dart:io';

import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/share_or_save.dart';
import 'package:path/path.dart' as path;


class FileListTile extends StatelessWidget {
  final File file;
  final int index;
  final BackupType type;

  const FileListTile({
    required this.index,
    required this.file,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context)!;
    return ListTile(
      title: Text(path.basename(file.path)),
      leading: const Icon(McIcons.file_document_outline),
      trailing: IconButton(
        icon: CSWidgets.deleteIcon,
        onPressed: () => askDelete(stage, logic),
      ),
      onTap: () => stage.showAlert(
        AlternativesAlert(
          label: "File actions",
          alternatives: [
            Alternative(
              title: "Restore games", 
              icon: Icons.restore, 
              action: () async {
                late bool result;
                switch (type) {
                  case BackupType.pastGames:
                    result = await logic.backups.loadPastGame(file);
                    break;
                  case BackupType.preferences:
                    result = await logic.backups.loadPreferences(file);
                    break;
                }
                if(result){
                  stage.closePanel();
                }
              },
            ),
            Alternative(
              title: "Save file on device", 
              icon: Icons.save_alt_outlined, 
              action:  () async {
                bool error = false;
                try {
                  await file.save();
                } catch (e) {
                  error = true;
                }
                if(!error){
                  stage.closePanel();
                }
              },
            ),
            Alternative(
              title: "Share file", 
              icon: Icons.share, 
              action: () async {
                bool error = false;
                try {
                  await file.share();
                } catch (e) {
                  error = true;
                }
                if(!error){
                  stage.closePanel();
                }
              },
            ),
            Alternative(
              title: "Delete file", 
              icon: Icons.delete_forever, 
              color: CSColors.delete,
              action: () => askDelete(stage, logic),
            ),
            Alternative(
              title: "Cancel", 
              icon: Icons.cancel_outlined, 
              action: (){
                stage.closePanel();
              },
            ),
          ],
        ),
        size: AlternativesAlert.heightCalc(5)
      ),
      // onTap: () => stage.showAlert(
      //   ConfirmAlert(
      //     action: <BackupType, VoidCallback>{
      //       BackupType.preferences: () => logic.backups.loadPreferences(file),
      //       BackupType.pastGames: () => logic.backups.loadPastGame(file),
      //     }[type]!,
      //     warningText: <BackupType, String>{
      //       BackupType.preferences: "Merge preferences from file?",
      //       BackupType.pastGames: "Merge games from file?",
      //     }[type],
      //   ),
      //   size: ConfirmAlert.height,
      // ),
    );
  }

  VoidCallback deleteCallback(CSBloc logic) => <BackupType, VoidCallback>{
    BackupType.preferences: () => logic.backups.deletePreference(index),
    BackupType.pastGames: () => logic.backups.deletePastGame(index),
  }[type]!;

  void askDelete(StageData stage, CSBloc logic) => stage.showAlert(
    ConfirmAlert(
      action: deleteCallback(logic),
      warningText: "Delete file?",
      confirmIcon: Icons.delete_forever,
      confirmColor: CSColors.delete,
    ),
    size: ConfirmAlert.height,
  );
}