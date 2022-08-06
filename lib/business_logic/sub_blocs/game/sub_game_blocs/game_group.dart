import 'dart:async';

import 'package:counter_spell_new/core.dart';


const int maxNumberOfPlayers = 12; 

class CSGameGroup {

  void dispose(){
    names.dispose();
    newNamesSub.cancel();
    arenaNameOrder.dispose();
    newNamesSub.cancel();
    savedNames.dispose();
    savedCards.dispose();
    cardsA.dispose();
    cardsB.dispose();
  } 

  //========================
  // Values
  final CSGame parent;
  late PersistentVar<List<String>> names;
  late PersistentVar<Map<int,String?>> arenaNameOrder;
  late StreamSubscription newNamesSub;
  final PersistentVar<Set<String?>> savedNames;

  final BlocMap<String,Set<MtgCard>> savedCards;

  final PersistentVar<Map<String,MtgCard>> cardsA;
  final PersistentVar<Map<String,MtgCard>> cardsB;
  BlocVar<Map<String,MtgCard>> cards(bool partnerA) => partnerA ? cardsA : cardsB;

  ///========================
  /// Constructor
  CSGameGroup(this.parent): 
    savedNames = PersistentVar<Set<String?>>(
      initVal: <String>{},
      key: "bloc_game_group_blocvar_saved_names",
      toJson: (stringSet) => stringSet.toList(),
      fromJson: (json) => {
        for(final s in json)  
          s as String?,
      },
    ),
    cardsA = PersistentVar<Map<String,MtgCard>>(
      initVal: <String,MtgCard>{},
      key: "bloc_game_group_blocvar_cardsA",
      toJson: (map) => <String,dynamic>{
        for(final entry in map.entries)
          entry.key: entry.value.toJson(),
      },
      fromJson: (json) => {
        for(final entry in (json as Map<String,dynamic>).entries)  
          entry.key: MtgCard.fromJson(entry.value),
      },
    ),
    cardsB = PersistentVar<Map<String,MtgCard>>(
      initVal: <String,MtgCard>{},
      key: "bloc_game_group_blocvar_cardsB",
      toJson: (map) => <String,dynamic>{
        for(final entry in map.entries)
          entry.key: entry.value.toJson(),
      },
      fromJson: (json) => {
        for(final entry in (json as Map<String,dynamic>).entries)  
          entry.key: MtgCard.fromJson(entry.value),
      },
    ),
    savedCards = BlocMap<String,Set<MtgCard>>(
      <String,Set<MtgCard>>{},
      key: "bloc_game_group_blocvar_savedCards",
      itemToJson: (setOfCards) => <dynamic>[
        for(final card in setOfCards!)
          card.toJson(),
      ],
      jsonToItem: (json) => <MtgCard>{
        for(final code in (json as List))
          MtgCard.fromJson(code),
      },
    )
  {
    names = PersistentVar<List<String>>(
      key: "bloc_game_group_blocvar_names_ordered_list_counterspell",
      initVal: parent.gameState.gameState.value.names.toList(),
      toJson: (list) => list,
      fromJson: (json) => [
        for(final s in json)
          s as String,
      ],
      equals: (a,b){
        if(a.length != b.length) return false;
        for(int i=0; i<a.length; ++i) {
          if(a[i] != b[i]) return false;
        }
        return true;
      }
    );
    arenaNameOrder = PersistentVar<Map<int,String?>>(
      key: "bloc_game_group_blocvar_alternative_layout_name_order",
      initVal: <int,String?>{
        for(int i=0; i<names.value.length; ++i)
          i: names.value[i],
      },
      toJson: (map) => <String,dynamic>{
        for(final entry in map.entries)
          entry.key.toString(): entry.value, 
      },
      fromJson: (json) => <int,String?>{
        for(final entry in (json as Map<String,dynamic>).entries)
          int.parse(entry.key): entry.value as String?,
      },
    );

    /// [CSGameGroup] Must be initialized after [CSGameState]
    newNamesSub = parent.gameState.gameState.behavior.listen((state){
      updateNames(state);
      updateNamesAltLayout(names.value);
    });
  }

  void updateNames(GameState state){
    for(final name in state.names){
      if(!names.value.contains(name)) {
        names.value.add(name);
      }
    }
    final List<String> toBeRemoved = [];
    for(final name in names.value){
      if(!state.names.contains(name)) {
        toBeRemoved.add(name);
      }
    }
    for(final name in toBeRemoved){
      names.value.remove(name);        
    }
    names.refreshDistinct();
  }
  void updateNamesAltLayout(List<String> newNames){
    for(final name in newNames){
      if(!arenaNameOrder.value.containsValue(name)){
        arenaNameOrder.value[arenaNameOrder.value.length] = name;
      }
    }
    final List<String> current = <String>[
      for(int i=0; i<arenaNameOrder.value.length; ++i)
        if(newNames.contains(arenaNameOrder.value[i]))
          arenaNameOrder.value[i]!,
    ];
    // ignore: unnecessary_cast
    arenaNameOrder.set(<int,String>{
      for(int i=0; i<current.length; ++i)
        i: current[i],
    } as Map<int,String?>);
    names.refreshDistinct();
  }


  //========================
  // Actions

  void onReorder(int from, int to){
    final list = <String?>[...names.value];
    final removed = list[from]!;
    list[from] = null;
    list.insert(to, removed);
    names.value = <String>[
      for(final String? e in list)
        if(e != null)
          e,
    ];
    names.refresh();
  }

  void moveIndex(int oldIndex, int newIndex){
    debugPrint("from $oldIndex to $newIndex");
    names.value.insert(
      newIndex, 
      names.value.removeAt(oldIndex)
    );
    names.refresh();
  }

  void moveName(String name, int newIndex)
    => moveIndex(names.value.indexOf(name), newIndex);

  void rename(String oldName, String newName){
    final int index = names.value.indexOf(oldName);
    names.value[index] = newName;
    names.refresh();

    int? altIndex;
    for(final entry in arenaNameOrder.value.entries){
      if(entry.value == oldName){
        altIndex = entry.key;
      }
    }
    if(altIndex != null){
      arenaNameOrder.value[altIndex] = newName;
      arenaNameOrder.refresh();
    }
    saveName(newName);
  }
  void deletePlayer(String name){
    names.value.remove(name);
    names.refresh();
  }
  void newPlayer(String newName){
    names.value.add(newName);
    names.refresh();
    saveName(newName);
  }
  void newGroup(List<String> newNames){
    names.set(newNames);
    arenaNameOrder.set({
      for(int i=0; i<newNames.length; ++i)
        i: newNames[i],
    });
    saveNames(newNames);
  }
  void saveName(String name){
    if(savedNames.value.add(name)) {
      savedNames.refresh();
    }
  }
  void unSaveName(String? name){
    if(savedNames.value.remove(name)) {
      savedNames.refresh();
    }
  }
  void saveNames(Iterable<String> names){
    bool refresh = false;
    for(final name in names){
      if(!name.contains("Player ")){
        if(savedNames.value.add(name)){
          refresh = true;
        }
      }
    }
    if(refresh) savedNames.refresh();
  }
  void unSaveNames(Iterable<String> names){
    bool refresh = false;
    for(final name in names){
      if(savedNames.value.remove(name)){
        refresh = true;
      }
    }
    if(refresh) savedNames.refresh();
  }
}