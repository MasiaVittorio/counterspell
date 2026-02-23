import 'dart:io';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/backup_logic.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/share_or_save.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:path/path.dart' as path;

class GenerateGamesBackupCard extends StatefulWidget {
  const GenerateGamesBackupCard({super.key});

  @override
  State<GenerateGamesBackupCard> createState() =>
      _GenerateGamesBackupCardState();
}

class _GenerateGamesBackupCardState extends State<GenerateGamesBackupCard> {
  String? message;
  bool error = false;
  bool working = false;
  File? generated;

  @override
  void dispose() {
    generated?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    void onTap() => generate(logic);

    return SubSection(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      [
        Expanded(
          child: InkWell(
            onTap: generated == null ? onTap : null,
            child: Center(
              child: ListTile(
                title: text,
                leading: icon(Theme.of(context).colorScheme.onSurface),
                subtitle: message != null
                    ? Text(
                        message!,
                        style: TextStyle(color: error ? CSColors.delete : null),
                      )
                    : null,
              ),
            ),
          ),
        ),
        AnimatedListed(
          listed: generated != null,
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text("Save"),
                  leading: const Icon(Icons.save_alt_outlined),
                  onTap: () => saveFile(generated!),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("Share"),
                  leading: const Icon(Icons.share),
                  onTap: () => shareFile(generated!),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget icon(Color progressColor) => working
      ? CircularProgressIndicator(color: progressColor)
      : const Icon(
          Icons.save_outlined,
          size: 40,
        );

  Widget get text => AnimatedText(
        generated == null
            ? "Generate backup file"
            : "Backup generated in the cache",
      );

  void generate(CSBloc logic) async {
    setState(() {
      working = true;
      error = false;
      message = null;
    });

    generated = await logic.backups.createGamesBackup();

    setState(() {
      working = false;
      if (generated == null) {
        error = true;
        message = "Error generating the backup";
      }
    });
  }

  void shareFile(File file) async {
    setState(() {
      working = true;
    });

    ShareResult? results;
    bool errorSharing = false;
    try {
      results = await file.share();
    } catch (e) {
      errorSharing = true;
    }

    setState(() {
      working = false;

      if (results == null || errorSharing) {
        generated?.delete();
        generated = null;
        message = "Error sharing the file";
        error = true;
      } else {
        switch (results.status) {
          case ShareResultStatus.success:
            message = "Successfully shared";
            error = false;
            generated?.delete();
            generated = null;
            break;
          case ShareResultStatus.dismissed:
            message = "Didn't share";
            error = true;
            break;
          case ShareResultStatus.unavailable:
            message = "Share method unavailable";
            error = true;
            break;
        }
      }
    });
  }

  void saveFile(File file) async {
    setState(() {
      working = true;
    });

    bool errorSaving = false;
    String? savedPath;
    try {
      savedPath = await file.save();
    } catch (e) {
      errorSaving = true;
    }

    setState(() {
      generated?.delete();
      generated = null;
      working = false;
      if (savedPath == null || errorSaving) {
        message = "Error saving the file";
        error = true;
      } else {
        message = "Saved";
        error = false;
      }
    });
  }
}
