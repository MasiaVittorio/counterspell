import 'package:counter_spell_new/core.dart';

///[B]usiness [LO]gic [C]omponent for [CounterSpell]
class CSBloc extends BlocBase {

  static CSBloc of(BuildContext context) => BlocProvider.of<CSBloc>(context);

  @override
  void dispose() {
    print("disposing all counterspell logic from inside");
    this.achievements.dispose();
    this.game.dispose();
    this.backups.dispose();
    this.pastGames.dispose();
    this.payments.dispose();
    this.stageBloc.dispose();
    this.scroller.dispose();
    this.settings.dispose();
    this.themer.dispose();
  }



  //=============================
  // Values 


  CSAchievements achievements;
  CSGame game;
  CSPastGames pastGames;
  CSPayments payments;
  CSBackupBloc backups;
  CSStage stageBloc; // Needs scroller
  CSBadges badges; // Needs stage 
  CSScroller scroller;
  CSSettings settings;
  CSThemer themer; // Needs stage


  //=============================
  // Constructor 

  CSBloc(){
    achievements = CSAchievements(this);
    game = CSGame(this);
    pastGames = CSPastGames(this);
    payments = CSPayments(this);
    backups = CSBackupBloc(this);
    settings = CSSettings(this);
    scroller = CSScroller(this);
    stageBloc = CSStage(this); // Needs scroller
    badges = CSBadges(this); // Needs stage 
    themer = CSThemer(this); // Needs stage
  }


  //=============================
  // Getters 
  StageData<CSPage,SettingsPage> get stage => this.stageBloc.controller;


}
