import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/body/history/current_state_tile.dart';
import 'package:counter_spell_new/widgets/stage/body/history/history_player_tile.dart';

class HistoryTile extends StatelessWidget {

  final double? tileSize;
  final GameHistoryData data;
  final DateTime? firstTime;
  final bool avoidInteraction;
  final Color defenceColor;
  final Map<CSPage,Color> pageColors;
  final Map<String?, Counter> counters;
  final List<String> names;
  final Map<String,bool?> havePartnerB;
  final int index;
  final int dataLenght;

  const HistoryTile(this.data, {
    required this.firstTime,
    required this.index,
    required this.havePartnerB,
    required this.tileSize,
    required this.avoidInteraction,
    required this.defenceColor,
    required this.pageColors,
    required this.counters,
    required this.names,
    required this.dataLenght,
  });

  static String timeString(DateTime? time, DateTime? first, TimeMode? mode){
    switch (mode) {
      case TimeMode.clock:
        return clockString(time!);
      case TimeMode.inGame:
        return distanceString(time!, first!);
      default:
        return "";
    }
  }
  static String clockString(DateTime time){
    final hours = time.hour.toString().padLeft(2, "0");
    final minutes = time.minute.toString().padLeft(2, "0");
    return "$hours:$minutes";
  }
  static String distanceString(DateTime last, DateTime first){
    final duration = last.difference(first).abs();
    final time = DateTime(0).add(duration);
    final hours = time.hour.toString().padLeft(2, "0");
    final minutes = time.minute.toString().padLeft(2, "0");
    final seconds = time.second.toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final bloc = CSBloc.of(context);

    if(tileSize == null){
      final howManyPlayers = data is GameHistoryNull
        ? (data as GameHistoryNull).gameState.players.length
        : data.changes!.length;
      return LayoutBuilder(builder: (_, constraints) => ConstrainedBox(
        constraints: constraints, 
        child: bloc.themer.flatDesign.build((_, flat) => buildKnowingSize(
          CSSizes.computeTileSize(
            constraints, 
            howManyPlayers,
            flat,
          ),
          stage, 
          bloc,
        ),
      ),),);
    }

    return buildKnowingSize(tileSize, stage, bloc);
  }

  void askToDelete(StageData stage, CSBloc logic) {
    stage.showAlert(
      ConfirmAlert(
        confirmColor: CSColors.delete,
        twoLinesWarning: true,
        warningText: "Cancel ${actionId(logic)}? This cannot be undone",
        confirmText: "Yes, cancel action",
        confirmIcon: Icons.delete_forever,
        action: () => logic.game.gameState.forgetPast(index-1),
      ), 
      size: ConfirmAlert.twoLinesheight,
      replace: true,
    );
  }

  String actionId(CSBloc logic) {
    final timeMode = logic.settings.gameSettings.timeMode.value;
    final bool none = timeMode == TimeMode.none;
    final realMode = none ? TimeMode.clock : timeMode;
    final bool inGame = realMode == TimeMode.inGame;
    return "action happened at ${timeString(data.time, firstTime, realMode)}${inGame?" (in game)":""}";
  }
  bool get hasPrevious => index < dataLenght - 1;

  Widget buildKnowingSize(double? knownTileSize, StageData stage, CSBloc logic){

    if(data is GameHistoryNull){
      return CurrentStateTile(
        (data as GameHistoryNull).gameState,
        (data as GameHistoryNull).index,
        names: names,
        defenceColor: defenceColor, 
        pagesColor: pageColors,
        tileSize: knownTileSize,
        counters: counters,
      );
    }


    return logic.themer.flatDesign.build((context, flat) => Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: index == 0
          ? null 
          : (){
            if(!hasPrevious) {
              askToDelete(stage, logic);
            } else {
              stage.showAlert(
                AlternativesAlert(
                  alternatives: [
                    Alternative(
                      title: "Cancel action", 
                      icon: CSIcons.delete, 
                      action: () => askToDelete(stage,logic),
                    ),
                    Alternative(
                      title: "Merge with previous action ($index - ${index + 1})", 
                      icon: Icons.merge, 
                      action: () {
                        logic.game.gameState.mergeWithPrevious(index);
                        stage.closePanelCompletely();
                      },
                    ),
                  ],
                  label: actionId(logic).firstCapitalize,
                ),
                size: AlternativesAlert.heightCalc(2),
              );
            }
          },
        child: Container(
          height: CSSizes.computeTotalSize(
            knownTileSize!, 
            data.changes!.length, 
            flat,
          ),
          constraints: const BoxConstraints(minWidth: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: CSSizes.separateColumn(flat, <Widget>[
              for(final name in names) if(data.changes!.containsKey(name))
                HistoryPlayerTile(
                  data.changes![name]!,
                  time: data.time,
                  firstTime: firstTime,
                  pageColors: pageColors,
                  defenceColor: defenceColor,
                  counters: counters,
                  tileSize: knownTileSize,
                  partnerB: havePartnerB[name] ?? false,
                ),
            ],),
          ),
        ),
      ),
    ),);
  }
}

extension on String {
  String get firstCapitalize {
    if(length == 0) return "";
    final first = this[0];
    if(length == 1) return first.toUpperCase();
    final rest = substring(1);
    return first.toUpperCase() + rest;
  }
}