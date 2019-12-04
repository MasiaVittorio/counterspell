import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/body/history/current_state_tile.dart';
import 'package:counter_spell_new/widgets/stageboard/body/history/history_player_tile.dart';

class HistoryTile extends StatelessWidget {
  final double tileSize;
  final double coreTileSize;
  final GameHistoryData data;
  final bool avoidInteraction;
  final Color defenceColor;
  final Map<CSPage,Color> pageColors;
  final Map<String, Counter> counters;
  final List<String> names;
  final Map<String,bool> havePartnerB;
  final int index;

  const HistoryTile(this.data, {
    @required this.index,
    @required this.havePartnerB,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.avoidInteraction,
    @required this.defenceColor,
    @required this.pageColors,
    @required this.counters,
    @required this.names,
  });

  static String timeString(DateTime time){
    final hours = time.hour.toString().padLeft(2, "0");
    final minutes = time.minute.toString().padLeft(2, "0");
    return "$hours: $minutes";
  }

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    if(tileSize == null){
      final howManyPlayers = data is GameHistoryNull
        ? (data as GameHistoryNull).gameState.players.length
        : data.changes.length;
      return LayoutBuilder(builder: (context, constraints)
        => buildKnowingSize(
          CSConstants.computeTileSize(
            constraints, 
            coreTileSize, 
            howManyPlayers,
          ),
          stage, 
          bloc,
        ),);
    }

    return buildKnowingSize(tileSize, stage, bloc);
  }

  Widget buildKnowingSize(double knownTileSize, StageData stage, CSBloc bloc){

    if(data is GameHistoryNull){
      return CurrentStateTile(
        (data as GameHistoryNull).gameState,
        (data as GameHistoryNull).index,
        names: names,
        defenceColor: defenceColor, 
        pagesColor: pageColors,
        tileSize: tileSize,
        coreTileSize: coreTileSize,
        counters: counters,
      );
    }


    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onLongPress: index > 0 
          ? () => stage.showAlert(ConfirmAlert(
            confirmColor: CSColors.delete,
            warningText: "Action happened at ${timeString(data.time)}. Do you want to delete this action? This cannot be undone",
            confirmText: "Yes, Delete action",
            confirmIcon: Icons.delete_forever,
            twoLinesWarning: true,
            action: () => bloc.game.gameState.forgetPast(index-1),
          ), size: ConfirmAlert.twoLinesheight) 
          : null,
        child: Container(
          height: knownTileSize * data.changes.length,
          constraints: BoxConstraints(minWidth: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for(final name in names)
                HistoryPlayerTile(
                  data.changes[name],
                  time: data.time,
                  pageColors: pageColors,
                  defenceColor: defenceColor,
                  counters: counters,
                  tileSize: knownTileSize,
                  coreTileSize: coreTileSize,
                  partnerB: havePartnerB[name] ?? false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}