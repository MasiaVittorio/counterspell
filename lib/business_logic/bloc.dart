import 'package:counter_spell_new/core.dart';

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
