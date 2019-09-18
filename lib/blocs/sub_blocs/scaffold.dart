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
    page.dispose();
    dimensions.dispose();
    isPanelMostlyOpen.dispose();
  }




  //============================
  // Values

  final CSBloc parent;

  final BlocVar<CSPage> page;

  BlocVar<SidDimensions> dimensions;
  SidController controller;
  BoxConstraints constraints;
  BuildContext context;

  final BlocVar<bool> isPanelMostlyOpen;





  //===============================
  // Constructor

  CSScaffold(this.parent): 
    isPanelMostlyOpen = BlocVar<bool>(false),
    page = BlocVar<CSPage>(CSPage.life);





  //=============================
  // Actions

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
      CSPage page, 
      bool open, 
      bool casting, 
      Counter counter,
    ) builder,
  ) => parent.themer.animatedCurrentWidget(builder: (context, theme) =>  BlocVar.build4(
    page,
    isPanelMostlyOpen,
    parent.game.gameAction.isCasting,
    parent.game.gameAction.counterSet.variable,
    builder: (con, pag, ope, cas, cou) => builder(con, theme, pag, ope, cas, cou),
  ));


}