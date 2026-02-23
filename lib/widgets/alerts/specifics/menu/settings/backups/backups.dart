import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/games.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/preferences.dart';

class BackupsAlertNew extends StatelessWidget {
  const BackupsAlertNew({super.key});

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
  @override
  Widget build(BuildContext context) {
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
  }
}

enum BackupType {
  preferences,
  pastGames,
}
