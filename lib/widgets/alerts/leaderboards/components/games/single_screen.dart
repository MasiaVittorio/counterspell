import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/all.dart';
import 'package:counter_spell_new/widgets/alerts/leaderboards/components/games/winner_selector.dart';


class PastGameScreen extends StatelessWidget {

  final int index;

  const PastGameScreen({@required this.index});

  static const double height = 500.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_,pastGames) {
      final PastGame game = pastGames[this.index];
      return HeaderedAlertCustom(
        GameTimeTile(game, index: index, delete: false, openable: false,),
        titleSize: 96,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Section([
            const SectionTitle("Notes"),
            CSWidgets.heigth5,
            SubSection(<Widget>[
              ListTile(
                leading: const Icon(McIcons.fountain_pen_tip),
                title: Text(game.notes ?? "", style: TextStyle(fontStyle: FontStyle.italic),),
              ),
            ], onTap: () => insertNotes(game, stage, bloc)),
            CSWidgets.heigth10,
          ]),
          Section([
            const SectionTitle("Winner"),
            CSWidgets.heigth5,
            SubSection(
              <Widget>[
                ListTile(
                  leading: const Icon(McIcons.trophy),
                  title: Text("${game.winner ?? "not detected"}"),
                ),
              ], 
              onTap: () => selectWinner(game, stage, bloc)
            ),
            CSWidgets.heigth10,
          ]),
          Section([
            const SectionTitle("Commanders"),
            CSWidgets.heigth5,
            for(final player in game.state.players.keys)
              ...[
                CommanderSubSection(game, player, index: index,),
                CSWidgets.heigth10,
              ],
          ]),
        ],),
      );
    },);
  }


  void insertNotes(PastGame game, StageData stage, CSBloc bloc){
    stage.showAlert(
      InsertAlert(
        hintText: "This game I comboed off...",
        labelText: "Insert notes",
        initialText: game.notes ?? "",
        textCapitalization: TextCapitalization.sentences,
        maxLenght: null,
        onConfirm: (notes){
          bloc.pastGames.pastGames.value[this.index].notes = notes;
          // TODO: Crea una BlocVarList che può scrivere soltanto l'indice selezionato al refresh
          bloc.pastGames.pastGames.refresh();
        },
      ),
      size: InsertAlert.height,
    );    
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
        autoClose: false,
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
      AnimatedListed(listed: partner, child: second != null 
        ? CardTile(
          second, 
          autoClose: false,
          callback: (_) => pick(false, bloc, stage),
          trailing: IconButton(
            icon: CSWidgets.deleteIcon,
            onPressed: (){
              bloc.pastGames.pastGames.value[this.index].commandersB[this.player] = null;
              bloc.pastGames.pastGames.refresh();
            }
          ),
        ) 
        : ListTile(
          leading: const Icon(McIcons.cards_outline),
          title: const Text("Select second partner") ,
          onTap: () => pick(false, bloc, stage),
        ),
      ),
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