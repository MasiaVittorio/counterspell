import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sidereus/sidereus.dart';

class CSBloc extends BlocBase {

  static CSBloc of(BuildContext context) => BlocProvider.of<CSBloc>(context);


  @override
  void dispose() {
    this.game.dispose();
    this.stageBoard.dispose();
    this.scroller.dispose();
    this.settings.dispose();
    this.themer.dispose();
  }



  //=============================
  // Values 


  CSGame game;
  CSStageBoard stageBoard;
  CSScroller scroller;
  CSSettings settings;
  CSThemer themer;




  //=============================
  // Constructor 

  CSBloc(){
    game = CSGame(this);
    settings = CSSettings(this);
    stageBoard = CSStageBoard(this);
    scroller = CSScroller(this);
    themer = CSThemer(this);
  }

}
