
import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/games.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupsAlertNew extends StatelessWidget {
  const BackupsAlertNew();

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

      return RadioHeaderedAlert<BackupType>(
        customBackground: (theme) => theme.canvasColor,
        initialValue: stage.panelController.alertController
                .savedStates["backups radio headered alert"] ??
            BackupType.pastGames,
        onPageChanged: (p) => stage.panelController.alertController
            .savedStates["backups radio headered alert"] = p,
        orderedValues: const <BackupType>[
          BackupType.pastGames,
          BackupType.preferences
        ],
        items: const <BackupType, RadioHeaderedItem>{
          BackupType.preferences: RadioHeaderedItem(
            alreadyScrollableChild: true,
            child: PreferencesBackups(),
            longTitle: "Backup preferences",
            title: "Preferences",
            icon: McIcons.cog,
            unselectedIcon: McIcons.cog_outline,
          ),
          BackupType.pastGames: RadioHeaderedItem(
            alreadyScrollableChild: true,
            child: GamesBackups(),
            longTitle: "Backup game history",
            title: "Games",
            icon: McIcons.medal,
          ),
        },
      );
    });
  }
}