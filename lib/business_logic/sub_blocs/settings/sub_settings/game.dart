import 'package:counter_spell_new/core.dart';

class CSSettingsGame {

  //====================================
  // Disposer
  void dispose(){
    _startingLife.dispose();
    minValue.dispose();
    maxValue.dispose();
    timeMode.dispose();
    keepCommanderSettingsBetweenGames.dispose();
  }

  //====================================
  // Values
  final CSBloc parent;
  final PersistentVar<int> _startingLife;
  final PersistentVar<int> minValue;
  final PersistentVar<int> maxValue;

  final PersistentVar<TimeMode?> timeMode;

  final PersistentVar<bool?> keepCommanderSettingsBetweenGames;


  //====================================
  // Constructor
  CSSettingsGame(this.parent):
    _startingLife = PersistentVar<int>(
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
    timeMode = PersistentVar<TimeMode?>(
      key: "bloc_settings_blocvar_timeMode",
      initVal: TimeMode.clock,
      toJson: (mode) => TimeModes.nameOf(mode),
      fromJson: (name) => TimeModes.fromName(name),
    ),
    keepCommanderSettingsBetweenGames = PersistentVar<bool?>(
      key: "bloc_settings_blocvar_keepCommanderSettingsBetweenGames",
      initVal: false,
      toJson: (b) => b,
      fromJson: (j) => j,
    );

  //==========================
  // Methods

  int get currentStartingLife => _startingLife.value;
  BlocVar<int?> get startingLifeBlocVar => _startingLife;

  void changeStartingLife(int newLife){
    if(newLife == currentStartingLife) return;
    _startingLife.set(newLife);
    if(parent.game.gameState.gameState.value.historyLenght <= 1){
      parent.game.gameState.restart(null, avoidClosingPanel: true);
    } 
  }


}