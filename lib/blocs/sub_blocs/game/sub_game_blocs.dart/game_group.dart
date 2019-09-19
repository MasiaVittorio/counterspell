import 'dart:async';

import 'package:sidereus/bloc/bloc.dart';

import '../game.dart';

class CSGameGroup {

  void dispose(){
    this.names.dispose();
    newNamesSub.cancel();
  } 

  //========================
  // Values
  final CSGame parent;
  PersistentVar<List<String>> names;
  PersistentVar<Map<int,String>> alternativeLayoutNameOrder;
  StreamSubscription newNamesSub;



  ///========================
  /// Constructor
  CSGameGroup(this.parent){
    names = PersistentVar<List<String>>(
      key: "bloc_game_group_blocvar_names",
      initVal: this.parent.gameState.gameState.value.names.toList(),
      toJson: (list) => list,
      fromJson: (json) => [
        for(final s in json)
          s as String,
      ],
    );
    alternativeLayoutNameOrder = PersistentVar<Map<int,String>>(
      key: "bloc_game_group_blocvar_alternative_layout_name_order",
      initVal: {
        for(int i=0; i<this.names.value.length; ++i)
          i: this.names.value[i],
      },
      toJson: (map) => {
        for(final entry in map.entries)
          entry.key.toString(): entry.value, 
      },
      fromJson: (json) => {
        for(final entry in (json as Map<String,dynamic>).entries)
          int.parse(entry.key): entry.value,
      },
    );

    /// [CSGameGroup] Must be initialized after [CSGameState]
    newNamesSub = this.parent.gameState.gameState.behavior.listen((state){
      final Set _names = state.names;
      
      for(final name in _names){
        if(!names.value.contains(name))
          names.value.add(name);
      }

      for(final name in names.value){
        if(!_names.contains(name))
          names.value.remove(name);
      }

      names.refresh();

    });
  }



  //========================
  // Actions

  void moveIndex(int oldIndex, int newIndex){
    this.names.value.insert(
      newIndex, 
      names.value.removeAt(oldIndex)
    );
    this.names.refresh();
  }

  void moveName(String name, int newIndex)
    => this.moveIndex(names.value.indexOf(name), newIndex);

}