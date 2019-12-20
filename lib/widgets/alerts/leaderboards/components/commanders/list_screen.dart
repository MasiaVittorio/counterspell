import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.commanderStats.build((_, stats)
      => ListView.builder(
        physics: Stage.of(context).panelScrollPhysics(),
        itemBuilder: (_, index){
          if(index == 0) return Container();
          return CommanderStatWidget(stats[index - 1], 
            pastGames: bloc.pastGames.pastGames.value,
            //commanderStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
          );
        },
        itemCount: stats.length + 1,
        itemExtent: CommanderStatWidget.height,
      ),
    );
  }


  
}
