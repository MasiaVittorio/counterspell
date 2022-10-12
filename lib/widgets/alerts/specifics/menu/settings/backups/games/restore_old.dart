import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/specifics/menu/settings/backups/file_tile.dart';


class RestoreOldGamesCard extends StatelessWidget {

  const RestoreOldGamesCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    void onTap() => action(stage);
    
    return SubSection(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      onTap: onTap,
      [
        const Spacer(),
        ListTile(
          title: text,
          leading: icon,
        ),
        const Spacer(),
      ],
    );  
  }
  
  Widget get text => const Text("Manage old local files");

  Widget get icon => const Icon(Icons.list, size: 40,);
  
  void action(StageData stage){
    stage.showAlert(
      const OldGamesAlert(),
      size: 500,
    );
  }

}

class OldGamesAlert extends StatelessWidget {

  const OldGamesAlert({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final CSBackupBloc backups = logic.backups;
    final textColor = Theme.of(context).brightness.contrast.withOpacity(0.5);
    final pastGamesPath = backups.pastGamesDirectory?.path.substring(20);

    return HeaderedAlert(
      "Old games gackups", 
      alreadyScrollableChild: true,
      child: backups.savedPastGames.build((_, list) => ModalBottomList(
        bottom: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "path: $pastGamesPath",
            style: TextStyle(
              color: textColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),), 
        bottomHeight: 60,
        children: [
          const Space.vertical(PanelTitle.height),
          for (int i = 0; i < list.length; ++i)
            FileListTile(
              file: list[i],
              index: i,
              type: BackupType.pastGames,
            ),
        ],
      )),
    );
  }
}