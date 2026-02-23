import 'dart:async';

import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/stage/body/history/history_tile.dart';

class CSGameHistory {
  void dispose() {
    stateSubscription.cancel();
  }

  //========================
  // Values
  final CSGame parent;
  final SidAnimatedListController listController;
  late StreamSubscription stateSubscription;
  List<GameHistoryData> data = [];

  ///========================
  /// Constructor
  CSGameHistory(this.parent) : listController = SidAnimatedListController() {
    /// [CSGameGroup] Must be initialized after [CSGameState]
    stateSubscription = parent.gameState.gameState.behavior.listen((state) {
      final int newLen = state.historyLenght;
      final newData = [
        for (int i = 1; i < newLen; ++i)
          GameHistoryData.fromStates(
            state,
            i - 1,
            i,
            types: DamageTypes.fromPages(parent.parent.stageBloc.controller
                    .mainPagesController.currentlyEnabledPages ??
                <CSPage, bool>{
                  for (final p in CSPage.values) p: true,
                }),
            counterMap: parent.gameAction.currentCounterMap,
          ),
        GameHistoryNull(state, newLen - 1),
      ];

      data = newData;
      //remember to always call insert / remove / refresh from the state bloc
    });
  }

  //========================
  // Actions

  void forward() => animateRemember(1);
  void animateRemember(int index) => listController.insert(
        index,
        duration: CSAnimations.fast,
      );

  void back(GameHistoryData outgoingData, DateTime? firstTime) =>
      animateForget(1, outgoingData, firstTime);
  void animateForget(
          int index, GameHistoryData outgoingData, DateTime? firstTime) =>
      listController.remove(
        //0 = nonsense (the first column on the right is the current state)
        //1 = latest game action
        //history data lenght = first game action
        index,

        ///this builder, and  the parameter [outgoingData] are critically important:
        /// the list is immediately updated but the UI is animated, so when you remove an item
        /// this builder will display it for the duration of the removing animation
        /// while the item is no longer actually in the data list!
        (context, animation) => SizeTransition(
            axisAlignment: -1.0,
            axis: Axis.horizontal,
            sizeFactor: animation,
            child: HistoryTile(
              outgoingData,
              firstTime: firstTime,
              index: index - 1,
              counters: parent.gameAction.currentCounterMap,
              tileSize: null,
              defenceColor: parent.parent.themer.resolveDefenceColor,
              pageColors: parent.parent.stageBloc.controller.themeController
                  .derived.mainPageToPrimaryColor.value!,
              avoidInteraction: true,
              names: parent.gameGroup.orderedNames.value,
              havePartnerB: <String, bool?>{
                for (final entry
                    in parent.gameState.gameState.value.players.entries)
                  entry.key: entry.value.havePartnerB,
              },
              dataLenght: data.length,
            )),
        duration: CSAnimations.fast,
      );
}
