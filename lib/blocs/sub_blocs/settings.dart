import 'dart:async';

import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:sidereus/bloc/bloc_var_persistent.dart';
import 'package:vibrate/vibrate.dart';

import '../bloc.dart';

class CSSettings {

  void dispose(){
    this.scrollSensitivity.dispose();
    this.wantVibrate.dispose();
    this.startingLife.dispose();
    this.minValue.dispose();
    this.maxValue.dispose();
    this.enabledPages.dispose();
    this.enabledCounters.dispose();
    customCountersSubscription.cancel();
    this.confirmDelay.dispose();
  }


  //===================================
  // Values
  final CSBloc parent;

  final PersistentVar<double> scrollSensitivity;
  final PersistentVar<bool> wantVibrate;
  bool canVibrate;
  final PersistentVar<int> startingLife;
  final PersistentVar<int> minValue;
  final PersistentVar<int> maxValue;
  final PersistentVar<Map<CSPage, bool>> enabledPages;
  final PersistentVar<Map<String, bool>> enabledCounters;
  StreamSubscription customCountersSubscription;
  final PersistentVar<Duration> confirmDelay;



  //===================================
  // Constructor
  CSSettings(this.parent): 
    scrollSensitivity = PersistentVar<double>(
      key: "bloc_settings_blocvar_scrollsens",
      initVal: 8,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    wantVibrate = PersistentVar<bool>(
      key: "bloc_settings_blocvar_wantvibrate",
      initVal: true,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    startingLife = PersistentVar<int>(
      key: "bloc_settings_blocvar_startinglife",
      initVal: 40,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    minValue = PersistentVar<int>(
      key: "bloc_settings_blocvar_minvalue",
      initVal: -999,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    maxValue = PersistentVar<int>(
      key: "bloc_settings_blocvar_maxvalue",
      initVal: 9999,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    enabledPages = PersistentVar<Map<CSPage, bool>>(
      key: "bloc_settings_blocvar_enabledpages",
      initVal: {
        CSPage.history: true,
        CSPage.counters: false,
        CSPage.life: true,
        CSPage.commander: false,
      },
      toJson: (map) => {
        for(final entry in map.entries)
          CSPAGE_TO_STRING[entry.key] : entry.value,
      },
      fromJson: (json) => {
        for(final entry in json.entries)
          STRING_TO_CSPAGE[entry.key] : entry.value,
      },

    ),
    enabledCounters = PersistentVar<Map<String, bool>>(
      key: "bloc_settings_blocvar_enabledcounters",
      initVal: ((int inEn)=> {
        for(int i=0; i<inEn; ++i)
          DEFAULT_CUSTOM_COUNTERS[i].longName: true,
        for(final c in DEFAULT_CUSTOM_COUNTERS.skip(inEn))
          c.longName: false,
      })(3),
      toJson: (map) => map,
      fromJson: (json) => json,
    ),
    confirmDelay = PersistentVar<Duration>(
      key: "bloc_settings_blocvar_confirmdelay",
      initVal: const Duration(milliseconds: 700),
      toJson: (dur) => dur.inMilliseconds,
      fromJson: (json) => Duration(milliseconds: json),
    )
  {
    Vibrate.canVibrate.then(
      (canIt) => canVibrate = canIt
    );
    final gameAction = this.parent.game.gameAction;
    customCountersSubscription = gameAction
      .counterSet
      .variable
      .behavior
      .listen((_){

        //possibly updated, IF you remember to call counterSet.refresh() every time you 
        //change its underlying list of counters (e.g.: adding a new custom counter)
        final updatedList = gameAction.counterSet.list;
        bool updated = false;

        //add new counter names (enabled by default)
        for(final counter in updatedList){
          if(!this.enabledCounters.value.containsKey(counter.longName)){
            this.enabledCounters.value[counter.longName] = true;
            updated = true;
          }
        }

        //remove deleted counter names (carefully)
        List<String> namesToBeRemoved = <String>[];
        for(final name in this.enabledCounters.value.keys){
          if(!updatedList.any((counter) => counter.longName == name)){
            namesToBeRemoved.add(name);
            updated = true;
            //do not modify a map while iterating on its values
          }
        }
        for(final nameToBeRemoved in namesToBeRemoved){
          this.enabledCounters.value.remove(nameToBeRemoved);
        }

        //finally refresh this variable to make the  
        //dependent widgets see the changes (like the history section)
        if(updated) this.enabledCounters.refresh();
      });
  }


  //===================================
  // Action
  void disablePage(CSPage page){
    assert(this.enabledPages.value[page]);
    assert(page != CSPage.life);
    if(parent.scaffold.page.value == page){
      parent.scaffold.page.set(CSPage.life);
    }
    this.enabledPages.value[page] = false;
    this.enabledPages.refresh();
    // final scaffold = parent.scaffold;
    // final mainIndex = scaffold.mainIndex;
    // final pageToIndex = scaffold.pageToIndex;
    // final indexToAvoid = pageToIndex[page];
    // final targetIndex = mainIndex.value == indexToAvoid
    //   ? pageToIndex[CSPage.life]
    //   : mainIndex.value;
    
    // final fixedTarget = targetIndex >= indexToAvoid
    //   ? targetIndex - 1
    //   : targetIndex;
    
    // mainIndex.set(fixedTarget);
    // enabledPages.value[page] = false;
    // enabledPages.refresh();
  }
  void enablePage(CSPage page){
    assert(!this.enabledPages.value[page]);
    assert(page != CSPage.life);

    this.enabledPages.value[page] = true;
    this.enabledPages.refresh();
    // final scaffold = parent.scaffold;
    // final mainIndex = scaffold.mainIndex;
    // final indexToPage = scaffold.indexToPage;
    // final previousIndex = mainIndex.value;
    // final previousPage = indexToPage[previousIndex];
    
    // enabledPages.value[page] = true;
    // enabledPages.refresh();
    // mainIndex.set(
    //   scaffold.pageToIndex[previousPage]
    // );
  }

  void togglePage(CSPage page){
    if(enabledPages.value[page])
      disablePage(page);
    else
      enablePage(page);
  }

}