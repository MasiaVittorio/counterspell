import 'package:counter_spell_new/core.dart';


import 'sub_settings/all.dart';
export 'sub_settings/all.dart';

class CSSettings {

  void dispose(){
    this.scrollSettings.dispose();
    this.arenaSettings.dispose();
    this.imagesSettings.dispose();
    this.appSettings.dispose();
    this.gameSettings.dispose();
  }


  //===================================
  // Values
  final CSBloc parent;

  final CSSettingsScroll scrollSettings;
  final CSSettingsArena arenaSettings;
  final CSSettingsImages imagesSettings;
  final CSSettingsApp appSettings;
  final CSSettingsGame gameSettings;


  //===================================
  // Constructor
  CSSettings(this.parent): 
    scrollSettings = CSSettingsScroll(parent),
    arenaSettings = CSSettingsArena(parent),
    imagesSettings = CSSettingsImages(parent),
    appSettings = CSSettingsApp(parent),
    gameSettings = CSSettingsGame(parent);


  void showChangelog(){
    parent.stage.showAlert(const Changelog(), size: Changelog.height);
    appSettings.versionShown.set(versionCode);
  }

  static const int versionCode = ChangeLogData.lastBigChange;

}