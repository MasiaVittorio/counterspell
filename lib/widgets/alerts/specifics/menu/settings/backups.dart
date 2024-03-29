// import 'dart:html' hide VoidCallback;

import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/file_tile.dart';
import 'package:permission_handler/permission_handler.dart';


class BackupsAlert extends StatelessWidget {
  const BackupsAlert();

  @override
  Widget build(BuildContext context) {
    return _BackupsAlert(CSBloc.of(context));
  }
}

class _BackupsAlert extends StatefulWidget {
  final CSBloc logic;

  const _BackupsAlert(this.logic);

  @override
  _BackupsAlertState createState() => _BackupsAlertState();
}

class _BackupsAlertState extends State<_BackupsAlert> {
  PermissionStatus? permissionStatus;

  @override
  void initState() {
    super.initState();
    // widget.logic.backups.init();
    init();
  }

  void init() async {
    permissionStatus = await Permission.storage.status;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final CSBackupBloc backups = widget.logic.backups;

    return backups.ready.build((context, ready) {
      if (!ready) {
        return HeaderedAlert(
          "Permission needed",
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PermissionStatusWidget(permissionStatus,
                  onStatusChanged: (status) {
                if (status.isGranted) {
                  setState(() {
                    permissionStatus = status;
                  });
                  backups.init();
                }
              }),
              if (permissionStatus?.isGranted ?? false)
                const ListTile(
                  title: Text("Loading..."),
                  leading: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      }

      final stage = Stage.of(context)!;

      final textColor = Theme.of(context).brightness.contrast.withOpacity(0.5);
      final pastGamesPath = backups.pastGamesDirectory?.path.substring(20);
      final preferencesPath = backups.preferencesDirectory?.path.substring(20);

      return RadioHeaderedAlert<BackupType>(
        initialValue: stage.panelController.alertController
                .savedStates["backups radio headered alert"] ??
            BackupType.pastGames,
        onPageChanged: (p) => stage.panelController.alertController
            .savedStates["backups radio headered alert"] = p,
        orderedValues: const <BackupType>[
          BackupType.pastGames,
          BackupType.preferences
        ],
        items: <BackupType, RadioHeaderedItem>{
          BackupType.preferences: RadioHeaderedItem(
            child: backups.savedPreferences.build(
              (context, list) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < list.length; ++i)
                    FileListTile(
                      file: list[i],
                      index: i,
                      type: BackupType.preferences,
                    ),
                  DoOneTime(
                    title: const Text("Create new backup"),
                    leading: const Icon(Icons.add),
                    futureTap: backups.savePreferences,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "path: $preferencesPath",
                      style: TextStyle(
                        color: textColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            longTitle: "Backup preferences",
            title: "Preferences",
            icon: McIcons.cog,
            unselectedIcon: McIcons.cog_outline,
          ),
          BackupType.pastGames: RadioHeaderedItem(
            child: backups.savedPastGames.build(
              (context, list) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < list.length; ++i)
                    FileListTile(
                      file: list[i],
                      index: i,
                      type: BackupType.pastGames,
                    ),
                  DoOneTime(
                    title: const Text("Create new backup"),
                    leading: const Icon(Icons.add),
                    futureTap: backups.savePastGames,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "path: $pastGamesPath",
                      style: TextStyle(
                        color: textColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            longTitle: "Backup game history",
            title: "Games",
            icon: McIcons.medal,
          ),
        },
      );
    });
  }
}

class DoOneTime extends StatefulWidget {
  final Future<bool> Function()? futureTap;
  final void Function(VoidCallback tapped)? delegateTap;
  final Widget? leading;
  final Widget title;

  const DoOneTime({
    required this.title,
    this.leading,
    this.futureTap,
    this.delegateTap,
  });

  @override
  State<DoOneTime> createState() => _DoOneTimeState();
}

class _DoOneTimeState extends State<DoOneTime> {
  bool done = false;
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      leading: widget.leading,
      trailing: done
          ? const Icon(Icons.check)
          : waiting
              ? const CircularProgressIndicator()
              : null,
      onTap: done
          ? null
          : widget.delegateTap != null
              ? () {
                  setState(() {
                    waiting = true;
                    done = false;
                  });
                  widget.delegateTap!(() {
                    if (!mounted) return;
                    setState(() {
                      waiting = false;
                      done = true;
                    });
                  });
                }
              : widget.futureTap != null
                  ? () async {
                      setState(() {
                        done = false;
                        waiting = true;
                      });
                      if (await widget.futureTap!()) {
                        if (!mounted) return;
                        setState(() {
                          done = true;
                          waiting = false;
                        });
                      }
                    }
                  : null,
    );
  }
}

enum BackupType {
  preferences,
  pastGames,
}


class PermissionStatusWidget extends StatefulWidget {
  const PermissionStatusWidget(
    this.status, {
    required this.onStatusChanged,
  });

  final PermissionStatus? status;
  final ValueChanged<PermissionStatus> onStatusChanged;

  @override
  State<PermissionStatusWidget> createState() => _PermissionStatusWidgetState();
}

class _PermissionStatusWidgetState extends State<PermissionStatusWidget> {
  bool waiting = false;

  String get permissionString =>
      (<PermissionStatus?, String>{
        PermissionStatus.denied: "Denied",
        PermissionStatus.granted: "Granted",
        PermissionStatus.permanentlyDenied: "Permanently denied",
        PermissionStatus.restricted: "Restricted",
        PermissionStatus.limited: "Limited",
        // PermissionStatus.undetermined: "Not asked yet",
      }[widget.status]) ??
      "Not checked yet";

  IconData get permissionIcon =>
      (<PermissionStatus?, IconData>{
        PermissionStatus.denied: Icons.close,
        PermissionStatus.granted: Icons.check,
        PermissionStatus.permanentlyDenied: Icons.close,
        PermissionStatus.restricted: Icons.help_outline,
        PermissionStatus.limited: Icons.help_outline,
        null: Icons.help_outline,
      }[widget.status]) ??
      Icons.help_outline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(permissionIcon),
      title: const Text("Storage Permission"),
      subtitle: Text(permissionString),
      trailing: waiting ? const CircularProgressIndicator() : null,
      onTap: [
        PermissionStatus.denied,
        null,
      ].contains(widget.status)
          ? () async {
              setState(() {
                waiting = true;
              });

              widget.onStatusChanged(
                await Permission.storage.request(),
              );

              if (!mounted) return;
              setState(() {
                waiting = true;
              });
            }
          : null,
    );
  }
}
