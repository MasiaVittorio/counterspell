import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

///[B]usiness [LO]gic [C]omponent for [CounterSpell]
class CSBloc extends BlocBase {

  static CSBloc of(BuildContext context) => BlocProvider.of<CSBloc>(context);

  @override
  void dispose() {
    this.game.dispose();
    this.stageBloc.dispose();
    this.scroller.dispose();
    this.settings.dispose();
    this.themer.dispose();
  }



  //=============================
  // Values 


  CSGame game;
  CSStage stageBloc;
  CSScroller scroller;
  CSSettings settings;
  CSThemer themer;




  //=============================
  // Constructor 

  CSBloc(){
    game = CSGame(this);
    settings = CSSettings(this);
    stageBloc = CSStage(this);
    scroller = CSScroller(this);
    themer = CSThemer(this);
  }


  //=============================
  // Getters 
  StageData<CSPage,SettingsPage> get stage => this.stageBloc.controller;


}
