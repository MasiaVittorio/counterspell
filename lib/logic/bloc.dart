import 'package:counter_spell/core.dart';
import 'package:counter_spell/logic/sub_blocs/backups/backup_logic.dart';

///[B]usiness [LO]gic [C]omponent for [CounterSpell]
class CSBloc extends BlocBase {
  static CSBloc of(BuildContext context) => BlocProvider.of<CSBloc>(context)!;

  @override
  void dispose() {
    achievements.dispose();
    game.dispose();
    pastGames.dispose();
    payments.dispose();
    backups.dispose();

    tutorial.dispose();

    settings.dispose();
    scroller.dispose();
    stageBloc.dispose();
    themer.dispose();
  }

  //=============================
  // Values

  late CSAchievements achievements;
  late CSGame game;
  late CSPastGames pastGames;
  late CSPayments payments;
  late CSBackupBloc backups;

  // Needs stage just to show, not to initialize
  // Needs game state ready to override with cached
  late CSTutorial tutorial;

  late CSSettings settings; // Needs tutorial to hint
  late CSScroller scroller;
  late CSStage stageBloc; // Needs scroller
  late CSThemer themer; // Needs stage

  //=============================
  // Constructor

  CSBloc() {
    achievements = CSAchievements(this);
    game = CSGame(this);
    pastGames = CSPastGames(this);
    payments = CSPayments(this);
    backups = CSBackupBloc(this);

    // Needs stage just to show, not to initialize
    // Needs game state ready to override with cached
    tutorial = CSTutorial(this);

    settings = CSSettings(this); // Needs tutorial to hint
    scroller = CSScroller(this);
    stageBloc = CSStage(this); // Needs scroller
    themer = CSThemer(this); // Needs stage
  }

  //=============================
  // Getters
  StageData<CSPage, SettingsPage> get stage => stageBloc.controller;
}
