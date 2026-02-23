import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/games/generate.dart';
import 'package:counter_spell/widgets/alerts/specifics/menu/settings/backups/games/restore.dart';

class GamesBackups extends StatelessWidget {
  const GamesBackups({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Space.vertical(PanelTitle.height + 10),
        Expanded(
          flex: 10,
          child: GenerateGamesBackupCard(),
        ),
        Space.vertical(10),
        Expanded(
          flex: 6,
          child: RestoreGamesCard(),
        ),
        Space.vertical(10),
      ],
    );
  }
}
