import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/visible_pages.dart';


class CommandersLeaderboards extends StatelessWidget {

  const CommandersLeaderboards();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      final stats = <_CommanderStats>[
        for(final card in cards(pastGames))
          _CommanderStats.fromPastGames(card, pastGames),
      ];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final stat in stats)
            _StatWidget(stat),
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



class _StatWidget extends StatelessWidget {

  final _CommanderStats stat;

  _StatWidget(this.stat);

  @override
  Widget build(BuildContext context) {

    final Widget winRates = _Details(
      title: const Text("Win rate"),
      value: "${(stat.winRate * 100).toStringAsFixed(1)}%",
      icon: const Icon(McIcons.trophy),
      annotation: "(${stat.games} games)",
      children: <Widget>[
        for(final entry in stat.perPlayerWinRates.entries)
          ListTile(
            title: Text("${entry.key}"),
            subtitle: Text("${(entry.value * 100).toStringAsFixed(1)}%"),
            trailing: Text("(${stat.perPlayerGames[entry.key]} games)"),
          ),
      ],
    );

    final Widget damage = _Details(
      title: const Text("Damage"),
      value: "${(stat.damage).toStringAsFixed(1)}",
      icon: const Icon(CSIcons.attackIconTwo),
      annotation: "(${stat.games} games)",
      children: <Widget>[
        for(final entry in stat.perPlayerDamages.entries)
          ListTile(
            title: Text("${entry.key}"),
            subtitle: Text("${(entry.value).toStringAsFixed(1)}"),
            trailing: Text("(${stat.perPlayerGames[entry.key]} games)"),
          ),
      ],
    );


    return Section([
      CardTile(stat.card, callback: (_){}, autoClose: false,),
      VisiblePages(
        children: <Widget>[
          winRates,
          damage,
        ],
      ),
    ]);
  }
}

class _Details extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final String annotation;
  final String value;
  final List<Widget> children;

  _Details({
    @required this.icon,
    @required this.title,
    @required this.annotation,
    @required this.value,
    @required this.children,
  });

  static const double subsectionHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    return SubSection([
      ListTile(
        title: title,
        subtitle: Text(value),
        leading: icon,
        trailing: Text(annotation),
      ),
      if(children.length > 1)...[
        CSWidgets.divider,
        const SectionTitle("Per player"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: subsectionHeight),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),),
        ),
      ]
    ]);
  }
}

class _CommanderStats {

  //================================
  // Values
  final MtgCard card;

  final int wins;
  final int games;
  final Map<String,int> perPlayerWins;
  final Map<String,int> perPlayerGames;

  final int totalDamage;
  final Map<String,int> perPlayerTotalDamages;


  //================================
  // Getters
  double get winRate => wins / games;
  Map<String,double> get perPlayerWinRates => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerWins[key] / perPlayerGames[key],
  };

  //average
  double get damage => totalDamage / games;
  Map<String,double> get perPlayerDamages => <String,double>{
    for(final key in perPlayerGames.keys)
      key: perPlayerTotalDamages[key] / perPlayerGames[key],
  };


  //================================
  // Constructor(s)
  const _CommanderStats(this.card, {
    @required this.wins,
    @required this.games,
    @required this.perPlayerGames,
    @required this.perPlayerWins,
    @required this.totalDamage,
    @required this.perPlayerTotalDamages,
  });


  factory _CommanderStats.fromPastGames(MtgCard card, Iterable<PastGame> pastGames){

    int present = 0;
    int winner = 0;

    int totalDamage = 0;

    final Set<String> players = _CommanderStats.players(card, pastGames);
    final Map<String,int> presents = <String,int>{for(final player in players)
      player: 0,
    };
    final Map<String,int> winners = <String,int>{for(final player in players)
      player: 0,
    };

    final Map<String,int> totalDamages = <String,int>{for(final player in players)
      player: 0,
    };

    for(final game in pastGames){
      if(game.winner != null && game.commanderPlayed(card)){
        ++present;
        if(
          game.commandersA[game.winner]?.oracleId == card.oracleId
          ||
          game.commandersB[game.winner]?.oracleId == card.oracleId
        ){
          ++winner;
        }

        final String who = game.whoPlayedCommander(card);
        final bool a = game.commandersA[who].oracleId == card.oracleId;
        for(final defender in game.state.players.values){
          if(a){
            totalDamage += defender.states.last.damages[who].a;
          } else {
            totalDamage += defender.states.last.damages[who].b;
          }
        }
      }

      for(final player in players){
        if(game.state.players.containsKey(player)){
          if(game.winner != null && game.commanderPlayedBy(card, player)){
            ++presents[player];
            if(game.winner == player){
              ++winners[player];
            }
            final bool a = game.commandersA[player].oracleId == card.oracleId;
            for(final defender in game.state.players.values){
              if(a){
                totalDamages[player] += defender.states.last.damages[player].a;
              } else {
                totalDamages[player] += defender.states.last.damages[player].b;
              }
            }
          }
        }
      }
    }

    return _CommanderStats(card,
      wins: winner,
      games: present,
      perPlayerWins: winners,
      perPlayerGames: presents,
      totalDamage: totalDamage,
      perPlayerTotalDamages: totalDamages, 
    );

  }

  static Set<String> players(MtgCard card, List<PastGame> pastGames) => <String>{
    for(final PastGame game in pastGames)
      for(final String player in game.state.players.keys)
        if(
          (game.commandersA[player]?.oracleId) == card.oracleId
          ||
          (game.commandersB[player]?.oracleId) == card.oracleId
        ) player,
  };

}
