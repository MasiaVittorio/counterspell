import 'package:counter_spell_new/core.dart';


class CSSettingsArena {


  //======================================
  // Disposer
  void dispose(){
    this.squadLayout.dispose();
    this.verticalScroll.dispose();
    this.hideNameWhenImages.dispose();
    this.fullScreen.dispose();
  }


  //======================================
  // Values

  final CSBloc parent;

  final PersistentVar<bool> squadLayout;

  final PersistentVar<bool> verticalScroll;

  final PersistentVar<bool> hideNameWhenImages;

  final PersistentVar<bool> fullScreen;


  //======================================
  // Constructor
  CSSettingsArena(this.parent):
    squadLayout= PersistentVar<bool>(
      key: "bloc_settings_blocvar_simpleSquadLayout",
      initVal: true,
    ),
    verticalScroll = PersistentVar<bool>(
      key: "bloc_settings_blocvar_simpleScreenVerticalScroll",
      initVal: false,
    ),
    hideNameWhenImages = PersistentVar<bool>(
      key: "bloc_settings_blocvar_arenaHideNameWhenImages",
      initVal: false,
    ),
    fullScreen = PersistentVar<bool>(
      key: "bloc_settings_blocvar_arenaFullScreen",
      initVal: true,
    );


  //======================================
  // Methods

}