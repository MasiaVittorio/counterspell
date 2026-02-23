import 'package:counter_spell/core.dart';

export 'sub_settings/all.dart';

class CSSettings {
  void dispose() {
    scrollSettings.dispose();
    arenaSettings.dispose();
    imagesSettings.dispose();
    appSettings.dispose();
    gameSettings.dispose();
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
  CSSettings(this.parent)
      : scrollSettings = CSSettingsScroll(parent),
        arenaSettings = CSSettingsArena(parent),
        imagesSettings = CSSettingsImages(parent),
        appSettings = CSSettingsApp(parent),
        gameSettings = CSSettingsGame(parent);

  static const int versionCode = ChangeLogData.lastBigChange;
}
