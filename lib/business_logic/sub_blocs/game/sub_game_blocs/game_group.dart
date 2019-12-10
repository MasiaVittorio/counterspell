import 'dart:async';

import 'package:counter_spell_new/core.dart';


const int maxNumberOfPlayers = 12; 

class CSGameGroup {

  void dispose(){
    this.names.dispose();
    newNamesSub.cancel();
    this.alternativeLayoutNameOrder.dispose();
    this.newNamesSub.cancel();
    this.savedNames.dispose();
    this.cardsA.dispose();
    this.cardsB.dispose();
  } 

  //========================
  // Values
  final CSGame parent;
  PersistentVar<List<String>> names;
  PersistentVar<Map<int,String>> alternativeLayoutNameOrder;
  StreamSubscription newNamesSub;
  final PersistentVar<Set<String>> savedNames;

  final CachedVar<Map<String,Set<MtgCard>>> savedCards;
  //TODO: scopri perché cancellando la cache non si cancella questa variabile

  final PersistentVar<Map<String,MtgCard>> cardsA;
  final PersistentVar<Map<String,MtgCard>> cardsB;
  BlocVar<Map<String,MtgCard>> cards(bool a) => a ? this.cardsA : this.cardsB;

  ///========================
  /// Constructor
  CSGameGroup(this.parent): 
    savedNames = PersistentVar<Set<String>>(
      initVal: <String>{},
      key: "bloc_game_group_blocvar_saved_names",
      toJson: (stringSet) => stringSet.toList(),
      fromJson: (json) => {
        for(final s in json)  
          s as String,
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
    savedCards = CachedVar<Map<String,Set<MtgCard>>>(
      "bloc_game_group_blocvar_savedCards",
      <String,Set<MtgCard>>{},
      toJson: (map) => <String,dynamic>{
        for(final entry in map.entries)
          entry.key: <dynamic>[
            for(final card in entry.value)
              card.toJson(),
          ],
      },
      fromJson: (json) => {
        for(final entry in (json as Map<String,dynamic>).entries)  
          entry.key: <MtgCard>{
            for(final code in (entry.value as List))
              MtgCard.fromJson(code),
          },
      },
    )
  {
    names = PersistentVar<List<String>>(
      key: "bloc_game_group_blocvar_names_ordered_list_counterspell",
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
      updateNames(state);
      updateNamesAltLayout(this.names.value);
    });
  }

  void updateNames(GameState state){
    final Set _names = state.names;
    for(final name in _names){
      if(!names.value.contains(name))
        names.value.add(name);
    }
    final List<String> toBeRemoved = [];
    for(final name in names.value){
      if(!_names.contains(name))
        toBeRemoved.add(name);
    }
    for(final name in toBeRemoved){
      names.value.remove(name);        
    }
    names.refresh();
  }
  void updateNamesAltLayout(List<String> newNames){
    for(final name in newNames){
      if(!alternativeLayoutNameOrder.value.containsValue(name)){
        alternativeLayoutNameOrder.value[alternativeLayoutNameOrder.value.length] = name;
      }
    }
    final List<String> current = <String>[
      for(int i=0; i<alternativeLayoutNameOrder.value.length; ++i)
        alternativeLayoutNameOrder.value[i],
    ];
    final List<String> toBeRemoved= <String>[];
    for(final name in current){
      if(!newNames.contains(name))
        toBeRemoved.add(name);
    }
    for(final name in toBeRemoved){
      current.remove(name);        
    }
    alternativeLayoutNameOrder.set(<int,String>{
      for(int i=0; i<current.length; ++i)
        i:current[i],
    });
    names.refresh();
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

  void rename(String oldName, String newName){
    final int index = this.names.value.indexOf(oldName);
    this.names.value[index] = newName;
    this.names.refresh();

    int altIndex;
    for(final entry in this.alternativeLayoutNameOrder.value.entries){
      if(entry.value == oldName){
        altIndex = entry.key;
      }
    }
    if(altIndex != null){
      this.alternativeLayoutNameOrder.value[altIndex] = newName;
      this.alternativeLayoutNameOrder.refresh();
    }
    this.saveName(newName);
  }
  void deletePlayer(String name){
    this.names.value.remove(name);
    this.names.refresh();
  }
  void newPlayer(String newName){
    this.names.value.add(newName);
    this.names.refresh();
    this.saveName(newName);
  }
  void newGroup(List<String> newNames){
    this.names.set(newNames);
    this.alternativeLayoutNameOrder.set({
      for(int i=0; i<newNames.length; ++i)
        i: newNames[i],
    });
    this.saveNames(newNames);
  }
  void saveName(String name){
    if(this.savedNames.value.add(name))
      this.savedNames.refresh();
  }
  void unSaveName(String name){
    if(this.savedNames.value.remove(name))
      this.savedNames.refresh();
  }
  void saveNames(Iterable<String> names){
    bool refresh = false;
    for(final name in names){
      if(!name.contains("Player ")){
        if(this.savedNames.value.add(name)){
          refresh = true;
        }
      }
    }
    if(refresh) this.savedNames.refresh();
  }
  void unSaveNames(Iterable<String> names){
    bool refresh = false;
    for(final name in names){
      if(this.savedNames.value.remove(name)){
        refresh = true;
      }
    }
    if(refresh) this.savedNames.refresh();
  }
}