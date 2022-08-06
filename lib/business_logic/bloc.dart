import 'package:counter_spell_new/core.dart';

///[B]usiness [LO]gic [C]omponent for [CounterSpell]
class CSBloc extends BlocBase {

  static CSBloc? of(BuildContext context) => BlocProvider.of<CSBloc>(context);

  @override
  void dispose() {
    tutorial.dispose();
    achievements.dispose();
    game.dispose();
    backups.dispose();
    pastGames.dispose();
    payments.dispose();
    stageBloc.dispose();
    scroller.dispose();
    settings.dispose();
    themer.dispose();
  }



  //=============================
  // Values 


  late CSTutorial tutorial; // Needs stage just to show, not to initialize
  late CSAchievements achievements;
  late CSGame game;
  late CSPastGames pastGames;
  late CSPayments payments;
  late CSBackupBloc backups;
  late CSSettings settings;
  late CSScroller scroller;
  late CSStage stageBloc; // Needs scroller
  late CSBadges badges; // Needs stage 
  late CSThemer themer; // Needs stage


  //=============================
  // Constructor 

  CSBloc(){
    tutorial = CSTutorial(this); // Needs stage just to show, not to initialize
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
  StageData<CSPage,SettingsPage> get stage => stageBloc.controller;


}
