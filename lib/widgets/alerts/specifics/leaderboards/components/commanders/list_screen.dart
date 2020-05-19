import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.commanderStats.build((_, stats)
      => ListView.builder(
        physics: Stage.of(context).panelController.panelScrollPhysics(),
        itemBuilder: (_, index)
          => CommanderStatWidget(stats[index], 
            pastGames: bloc.pastGames.pastGames.value,
            //commanderStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
          ),
        padding: const EdgeInsets.only(top: PanelTitle.height),
        itemCount: stats.length,
        itemExtent: CommanderStatWidget.height,
      ),
    );
  }


  
}
