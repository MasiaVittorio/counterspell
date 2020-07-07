import 'package:counter_spell_new/core.dart';

class Achievements{
  //=====================================
  // Data ===========================
  static const String countersShortTitle = "Counters master";
  static const Achievement counters = QualityAchievement(
    countersShortTitle,
    title: "Track different counters in a single game",
    text: 'You can select a new counter in the "Counters" page by tapping on the icon at the right of the bottom panel',
    targets: <String,bool>{
      Counter.poisonLongName: false,
      Counter.experienceLongName: false,
      Counter.stormLongName: false,
      Counter.manaLongName: false,
      Counter.blessingLongName: false,
      Counter.monarchLongName: false,
      Counter.energyLongName: false,
    },
    targetBronze: 7,
    targetSilver: 7,
    targetGold: 7,
  );
  static const String uiExpertShortTitle = "UI expert";
  static const Achievement uiExpert = QualityAchievement(
    uiExpertShortTitle,
    title: "Restart the game or edit the playgroup in different ways",
    text: "You can use the closed panel's right button (History and Life pages) or the main menu's buttons (\"Game\" tab)",
    targets: <String,bool>{
      GameRestartedFromNames._gameRestartedFromHistoryPage: false,
      GameRestartedFromNames._gameRestartedFromMenu: false,
      GameRestartedFromNames._gameRestartedFromArena: false,
      "Playgroup panel": false,
      "Playgroup menu": false,
    },
    targetBronze: 2,
    targetSilver: 3,
    targetGold: 4,
  );
  static const String rollerShortTitle = "The roller";
  static const Achievement roller = QuantityAchievement(
    rollerShortTitle,
    title: "Flip a ton of coins, roll a bunch of dice",
    text: 'Open the main menu. In the "Game" tab you\'ll find the "Random" button',
    currentCount: 0,
    targetBronze: 10,
    targetSilver: 25,
    targetGold: 50,
  );
  static const String vampireShortTitle = "The vampire";
  static const Achievement vampire = QuantityAchievement(
    vampireShortTitle,
    title: "Steal a bunch of life via lifelink",
    text: 'A long press on the checkbox of a player will anti-select it to receive the opposite damage of any other player',
    currentCount: 0,
    targetBronze: 10,
    targetSilver: 25,
    targetGold: 50,
  );

  static const Map<String,Achievement> map = <String,Achievement>{
    vampireShortTitle: vampire,
    countersShortTitle: counters,
    uiExpertShortTitle: uiExpert,
    rollerShortTitle: roller,
  };
  static const Map<String,QualityAchievement> mapQuality = <String,QualityAchievement>{
    countersShortTitle: counters,
    uiExpertShortTitle: uiExpert,
  };
  static const Map<String,QuantityAchievement> mapQuantity = <String,QuantityAchievement>{
    vampireShortTitle: vampire,
    rollerShortTitle: roller,
  };

  static const Map<String,IconData> icons = <String,IconData>{
    Achievements.vampireShortTitle: McIcons.heart_pulse,
    Achievements.countersShortTitle: CSIcons.counterIconFilled,
    Achievements.rollerShortTitle: McIcons.dice_multiple,
    Achievements.uiExpertShortTitle: Icons.radio_button_checked,
  };
}


enum GameRestartedFrom{
  arena,
  historyPage,
  menu,
}


extension GameRestartedFromNames on GameRestartedFrom {
  static const String _gameRestartedFromArena = "arena";
  static const String _gameRestartedFromHistoryPage = "historyPage";
  static const String _gameRestartedFromMenu = "menu";
  static const Map<GameRestartedFrom,String> names = <GameRestartedFrom,String>{
    GameRestartedFrom.arena : GameRestartedFromNames._gameRestartedFromArena,
    GameRestartedFrom.menu : GameRestartedFromNames._gameRestartedFromMenu,
    GameRestartedFrom.historyPage : GameRestartedFromNames._gameRestartedFromHistoryPage,
  };

  String get name => names[this];
}
