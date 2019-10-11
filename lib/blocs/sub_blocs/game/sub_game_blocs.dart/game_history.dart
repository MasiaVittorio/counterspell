import 'dart:async';

import 'package:counter_spell_new/models/game/history_model.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:counter_spell_new/widgets/constants.dart';

import 'package:counter_spell_new/widgets/stageboard/components/body/components/history/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/animated_widgets/animated_list/sid_animated_list.dart';

import '../game.dart';

class CSGameHistory {

  void dispose(){
    stateSubscription.cancel();
  } 

  //========================
  // Values
  final CSGame parent;
  final SidAnimatedListController listController;
  StreamSubscription stateSubscription;
  List<GameHistoryData> data = [];


  ///========================
  /// Constructor
  CSGameHistory(this.parent): 
    listController = SidAnimatedListController()
  {
    /// [CSGameGroup] Must be initialized after [CSGameState]
    stateSubscription = parent.gameState.gameState.behavior.listen(
      (state){
        final int newLen = state.historyLenght;
        final newData = [
          for(int i = 1; i < newLen; ++i)
            GameHistoryData.fromStates(state, i-1 , i),
          GameHistoryNull(state, newLen - 1),
        ];

        data = newData;
        //remember to always call insert / remove / refresh from the state bloc
      }
    );
  }




  //========================
  // Actions

  void forward(int index) => this.listController.insert(
    index, 
    duration: MyDurations.fast,
  );
  void back(int index, GameHistoryData outgoingData) => listController.remove(
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
        counters: parent.gameAction.currentCounterMap,
        tileSize: null,
        theme: parent.parent.themer.currentTheme,
        pageThemes: parent.parent.stageBoard.controller.pagesController.pageThemes,
        avoidInteraction: true,
        coreTileSize: CSConstants.minTileSize,
        names: parent.gameGroup.names.value,
      )
    ),
    duration: MyDurations.fast,
  );

  void deletePlayerReferences(String name){
    final List<int> indexesToBeRemoved = <int>[];
    for(int i=0; i < this.data.length; ++i){
      if(data[i].changes == null || data[i].changes.isEmpty || data[i].changes.keys.every(
        (key) => key == name || data[i].changes[key].isEmpty
      )){
        indexesToBeRemoved.add(i);
      }
    }
    indexesToBeRemoved.sort();
    int removed=0;
    //TODO: debugga abbomba
    for(final index in indexesToBeRemoved){
      final out = data.removeAt(index - removed);
      this.back(
        data.length-(index - removed), 
        out,
      );
      ++removed;
    }
  }
}