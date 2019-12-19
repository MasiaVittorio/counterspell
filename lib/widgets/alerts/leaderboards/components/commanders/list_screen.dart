import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.commanderStats.build((_, stats)
      => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            StatWidget(stat, 
              pastGames: bloc.pastGames.pastGames.value,
              //commanderStats is updated whenever pastGames is updated
              //so it is safe to access that value brutally
            ),
        ],
      ),
    );
  }


  
}
