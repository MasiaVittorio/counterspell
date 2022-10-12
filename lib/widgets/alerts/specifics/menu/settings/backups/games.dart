import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/games/generate.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/games/restore.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/games/restore_old.dart';


class GamesBackups extends StatelessWidget {

  const GamesBackups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backups = CSBloc.of(context).backups;
    return backups.savedPastGames.build((_, list) => Column(children: [
      const Space.vertical(PanelTitle.height + 10),
      const Expanded(flex: 10,child: GenerateGamesBackupCard(),),
      const Space.vertical(10),
      const Expanded(flex: 6,child: RestoreGamesCard(),),
      if(list.isNotEmpty)
        ...const [
          Space.vertical(10),
          Expanded(flex: 6,child: RestoreOldGamesCard(),),
        ],
      const Space.vertical(10),
    ],),);  
  }
}