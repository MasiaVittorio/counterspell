import 'model_simple.dart';
import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      final stats = <CommanderStats>[
        for(final card in cards(pastGames))
          CommanderStats.fromPastGames(card, pastGames),
      ];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            StatWidget(stat, pastGames: pastGames,),
        ],
      );

    });
  }


  static Iterable<MtgCard> cards(List<PastGame> pastGames){

    final Map<String,MtgCard> map = <String,MtgCard>{
      for(final PastGame pastGame in pastGames)
        for(final commander in <MtgCard>[
          ...pastGame.commandersA.values,
          ...pastGame.commandersB.values,
        ])
          if(commander != null) 
            commander.oracleId : commander,
    };

    return map.values;

  }
  
}
