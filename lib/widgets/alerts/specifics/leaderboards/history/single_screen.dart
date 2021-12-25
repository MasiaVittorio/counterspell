import 'package:counter_spell_new/core.dart';
import '../all.dart';
import 'edit_custom_stats.dart'; 

class PastGameScreen extends StatelessWidget {

  final int index;

  const PastGameScreen({required this.index});

  static const double height = 500.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context)!;
    final titlesVar = bloc.pastGames.customStatTitles;
    final gamesVar = bloc.pastGames.pastGames;
    return gamesVar.build((_,pastGames) {
      final PastGame game = pastGames[this.index]!;
      return HeaderedAlertCustom(

        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AlertDrag(),
            GameTimeTile(game, index: index, delete: false),
          ],
        ),

        titleSize: 72.0 + AlertDrag.height,


        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Section(<Widget>[

            SubSection([
              const SectionTitle("Winner"),
              ListTile(
                leading: const Icon(McIcons.trophy),
                title: Text("${game.winner ?? "not detected"}"),
              ),
            ], onTap: () => selectWinner(game, stage!, bloc),),

            SubSection([
              const SectionTitle("Notes"),
              ListTile(
                leading: const Icon(McIcons.fountain_pen_tip),
                title: Text(
                  game.notes.or("[...]")!, 
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ], onTap: () => insertNotes(game, stage!, bloc)),

            SubSection(
              [
                const SectionTitle("Custom stats"),
                CSWidgets.height5,
                titlesVar.build((context, titles) => Row(children: [Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: ((){
                      final children = <Widget>[
                        for(final title in titles)
                          for(final n in (game.customStats[title] ?? []) as Iterable)
                            SidChip(text: title,subText: n,),
                      ];
                      if(children.isEmpty){
                        return [Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text("Tap to edit"),
                        )];
                      } else return children.separateWith(
                        CSWidgets.width10,
                        alsoFirstAndLast: true,
                      );
                    })(),),
                  ),
                )],),),

              ], 
              onTap: () => stage!.showAlert(
                EditCustomStats(index: index),
                size: EditCustomStats.height,
              ),
            ),

          ].separateWith(CSWidgets.height10, alsoFirstAndLast: true,),),

          Section([
            const SectionTitle("Commanders"),
            CSWidgets.height5,
            for(final player in game.state.players.keys)
              ...[
                CommanderSubSection(game, player, index: index,),
                CSWidgets.height10,
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
        maxLenght: TextField.noMaxLength,
        onConfirm: (notes){
          bloc.pastGames.pastGames.value[this.index]!.notes = notes;
          bloc.pastGames.pastGames.refresh(index: this.index);
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
          bloc.pastGames.pastGames.value[this.index]!.winner = selected;
          bloc.pastGames.pastGames.refresh(index: this.index);
        },
      ),
      size: WinnerSelector.heightCalc(game.state.players.length),
    );    
  }
}

extension on String? {
  String? or(String s) => this == null || this == "" ? s : this;
}

class CommanderSubSection extends StatelessWidget {
  final PastGame game;
  final int index;
  final String player;

  const CommanderSubSection(this.game, this.player, {required this.index});

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    final MtgCard? first = game.commandersA[player];
    final MtgCard? second = game.commandersB[player];
    final bool partner = game.state.players[player]!.havePartnerB!;

    return SubSection(<Widget>[
      SectionTitle(player),
      if(first != null) CardTile(
        first, 
        callback: (_) => pick(true, bloc, stage!),
        autoClose: false,
        trailing: IconButton(
          icon: CSWidgets.deleteIcon,
          onPressed: (){
            bloc!.pastGames.pastGames.value[this.index]!.commandersA[this.player] = null;
            bloc.pastGames.pastGames.refresh(index: this.index);
          }
        ),
      ) else ListTile(
        leading: const Icon(McIcons.cards_outline),
        title: Text(partner ? "Select first partner": "Select commander") ,
        onTap: () => pick(true, bloc, stage!),
      ),
      AnimatedListed(listed: partner, child: second != null 
        ? CardTile(
          second, 
          autoClose: false,
          callback: (_) => pick(false, bloc, stage!),
          trailing: IconButton(
            icon: CSWidgets.deleteIcon,
            onPressed: (){
              bloc!.pastGames.pastGames.value[this.index]!.commandersB[this.player] = null;
              bloc.pastGames.pastGames.refresh(index: this.index);
            }
          ),
        ) 
        : ListTile(
          leading: const Icon(McIcons.cards_outline),
          title: const Text("Select second partner") ,
          onTap: () => pick(false, bloc, stage!),
        ),
      ),
      BottomExtra(
        Text(partner ? "Merge into one commander" : "Split into two partners"), 
        onTap: (){
          bloc!.pastGames.pastGames.value[this.index]!.state.players[this.player]!.havePartnerB = !partner;
          bloc.pastGames.pastGames.refresh(index: this.index);
        },
        icon: partner ? Icons.unfold_less : Icons.unfold_more,
      ),
    ]);
  }

  void pick(bool first, CSBloc? bloc, StageData stage){
    stage.showAlert(
      ImageSearch((card){
        if(first){
          bloc!.pastGames.pastGames.value[this.index]!.commandersA[this.player] = card;
        } else {
          bloc!.pastGames.pastGames.value[this.index]!.commandersB[this.player] = card;
        }
        bloc.pastGames.pastGames.refresh(index: this.index);
      }),
      size: ImageSearch.height,
    );
  }
}