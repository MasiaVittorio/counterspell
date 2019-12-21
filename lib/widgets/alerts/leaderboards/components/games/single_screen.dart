import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/all.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/games/winner_selector.dart';


class PastGameScreen extends StatelessWidget {

  final int index;

  const PastGameScreen({@required this.index});

  static const double height = 450;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_,pastGames) {
      final PastGame game = pastGames[this.index];
      return HeaderedAlertCustom(
        GameTimeTile(game, index: index, delete: false,),
        titleSize: 96,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Section([
            const SectionTitle("Winner"),
            SubSection(
              <Widget>[
                ListTile(
                  leading: const Icon(McIcons.trophy),
                  title: Text("${game.winner ?? "not detected"}"),
                ),
              ], 
              onTap: () => selectWinner(game, stage, bloc)
            ),
            const SizedBox(height: 10.0,),
          ]),
          Section([
            const SectionTitle("Commanders"),
            for(final player in game.state.players.keys)
              ...[
                CommanderSubSection(game, player, index: index,),
                const SizedBox(height: 10.0,),
              ],
          ]),
        ],),
      );
    },);
  }


  void selectWinner(PastGame game, StageData stage, CSBloc bloc){
    stage.showAlert(
      WinnerSelector(
        game.state.names, 
        initialSelected: game.winner, 
        onConfirm: (selected){
          bloc.pastGames.pastGames.value[this.index].winner = selected;
          bloc.pastGames.pastGames.refresh();
        },
      ),
      size: WinnerSelector.heightCalc(game.state.players.length),
    );    
  }
}

class CommanderSubSection extends StatelessWidget {
  final PastGame game;
  final int index;
  final String player;

  const CommanderSubSection(this.game, this.player, {@required this.index});

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    final MtgCard first = game.commandersA[player];
    final MtgCard second = game.commandersB[player];
    final bool partner = game.state.players[player].havePartnerB;

    return SubSection(<Widget>[
      SectionTitle(player),
      if(first != null) CardTile(
        first, 
        callback: (_) => pick(true, bloc, stage),
        trailing: IconButton(
          icon: CSWidgets.deleteIcon,
          onPressed: (){
            bloc.pastGames.pastGames.value[this.index].commandersA[this.player] = null;
            bloc.pastGames.pastGames.refresh();
          }
        ),
      ) else ListTile(
        leading: const Icon(McIcons.cards_outline),
        title: Text(partner ? "Select first partner": "Select commander") ,
        onTap: () => pick(true, bloc, stage),
      ),
      if(partner)...[
        if(second != null) CardTile(
          second, 
          callback: (_) => pick(false, bloc, stage),
          trailing: IconButton(
            icon: CSWidgets.deleteIcon,
            onPressed: (){
              bloc.pastGames.pastGames.value[this.index].commandersB[this.player] = null;
              bloc.pastGames.pastGames.refresh();
            }
          ),
        ) else ListTile(
          leading: const Icon(McIcons.cards_outline),
          title: const Text("Select second partner") ,
          onTap: () => pick(false, bloc, stage),
        ),
      ],
      BottomExtra(
        Text(partner ? "Merge into one commander" : "Split into two partners"), 
        onTap: (){
          bloc.pastGames.pastGames.value[this.index].state.players[this.player].havePartnerB = !partner;
          bloc.pastGames.pastGames.refresh();
        },
      ),
    ]);
  }

  void pick(bool first, CSBloc bloc, StageData stage){
    stage.showAlert(
      ImageSearch((card){
        if(first){
          bloc.pastGames.pastGames.value[this.index].commandersA[this.player] = card;
        } else {
          bloc.pastGames.pastGames.value[this.index].commandersB[this.player] = card;
        }
        bloc.pastGames.pastGames.refresh();
      }),
      size: ImageSearch.height,
    );
  }
}