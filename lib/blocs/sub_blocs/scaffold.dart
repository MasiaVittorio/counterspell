import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'dart:math' as math;

import '../bloc.dart';

class CSScaffold {

  void dispose(){
    mainIndex.dispose();
    dimensions.dispose();
    isPanelMostlyOpen.dispose();
  }




  //============================
  // Values

  final CSBloc parent;

  BlocVar<int> mainIndex;

  BlocVar<SidDimensions> dimensions;
  SidController controller;
  BoxConstraints constraints;
  BuildContext context;

  final BlocVar<bool> isPanelMostlyOpen;




  //===============================
  // Getters
  
  Map<int,CSPage> get indexToPage {
    final enabled = parent.settings.enabledPages.value;

    Map<int, CSPage> result = <int, CSPage>{};
    int n = 0;
    for(final entry in enabled.entries){
      if(entry.value){
        result[n] = entry.key;
        ++n;
      }
    }

    return result;
  }
  Map<CSPage, int> get pageToIndex {
    final map = indexToPage;
    return {
      for(final entry in map.entries)
        entry.value: entry.key
    };
  }
  CSPage get currentPage => indexToPage[mainIndex.value];
  int get howManyPages {
    int n = 0;
    for(final enabled in parent.settings.enabledPages.value.values){
      if(enabled) ++n;
    }
    return n;
  }



  //===============================
  // Constructor

  CSScaffold(this.parent): 
    isPanelMostlyOpen = BlocVar<bool>(false)
  {
    ///[CSScaffold] must be initialized after [CSSettings]
    mainIndex = BlocVar<int>(pageToIndex[CSPage.life]);
  }




  //=============================
  // Actions

  void goToIndex(int index){
    if(index == null) return;
    if(index < 0) return;
    if(index >= howManyPages) return;
    this.mainIndex.set(index);
  }

  void goToPage(CSPage page){
    this.mainIndex.set(pageToIndex[page]);
  }

  void updateDimensions(BuildContext newContext, BoxConstraints newConstraints){
    this.constraints = newConstraints;
    this.context = newContext;

    final _newDim = SidDimensions(
      context: this.context,
      constraints: this.constraints,
      barSize: CSConstants.barSize,
      landscapePanelSize: double.infinity,
      portraitPanelSize: 0.8*constraints.maxHeight,
      bottomPaddingGetter: (double p) => math.max(0, p-8.0),
    );

    if(dimensions == null)
      dimensions = BlocVar<SidDimensions>(_newDim);
    else{
      dimensions.set(_newDim);
    }

  }




  //============================
  // Builders

  Widget reactiveBuild(
    Widget Function(
      BuildContext context, 
      CSTheme theme,
      int index, 
      bool open, 
      bool casting, 
      Counter counter,
    ) builder,
  ) => parent.themer.animatedCurrentWidget(builder: (context, theme) =>  BlocVar.build4(
    mainIndex,
    isPanelMostlyOpen,
    parent.game.gameAction.isCasting,
    parent.game.gameAction.counterSet.variable,
    builder: (con, ind, ope, cas, cou) => builder(con, theme, ind, ope, cas, cou),
  ));


}