import 'package:counter_spell_new/core.dart';


class CSSettingsArena {


  //======================================
  // Disposer
  void dispose(){
    scrollOverTap.dispose();
    layoutType.dispose();
    flipped.dispose();
    verticalScroll.dispose();
    verticalTap.dispose();
    hideNameWhenImages.dispose();
    fullScreen.dispose();
  }


  //======================================
  // Values

  final CSBloc parent;

  final PersistentVar<ArenaLayoutType?> layoutType;
  final PersistentVar<Map<ArenaLayoutType?,bool>> flipped;

  final PersistentVar<bool> verticalScroll;
  final PersistentVar<bool> verticalTap;

  final PersistentVar<bool> scrollOverTap;

  final PersistentVar<bool> hideNameWhenImages;

  final PersistentVar<bool> fullScreen;


  //======================================
  // Constructor
  CSSettingsArena(this.parent):
    scrollOverTap = PersistentVar<bool>(
      key: "bloc_settings_blocvar_arenaScrollOverTap",
      initVal: false,
    ),
    layoutType = PersistentVar<ArenaLayoutType?>(
      key: "bloc_settings_blocvar_arenaLayoutType",
      initVal: ArenaLayoutType.ffa,
      toJson: (t) => t.name,
      fromJson: (n) => ArenaLayoutTypes.fromName(n),
    ),
    flipped = PersistentVar<Map<ArenaLayoutType?,bool>>(
      key: "bloc_settings_blocvar_arenaLayoutFlipped",
      initVal: {
        ArenaLayoutType.ffa: false,
        ArenaLayoutType.squad: false,
      },
      toJson: (map) => <String?,bool>{
        for(final e in map.entries)
          e.key.name: e.value,
      },
      fromJson: (json) => <ArenaLayoutType?,bool>{
        for(final e in (json as Map).entries)
          ArenaLayoutTypes.fromName(e.key as String): e.value as bool,
      },
    ),
    verticalScroll = PersistentVar<bool>(
      key: "bloc_settings_blocvar_simpleScreenVerticalScroll",
      initVal: false,
    ),
    verticalTap = PersistentVar<bool>(
      key: "bloc_settings_blocvar_simpleScreenVerticalTap",
      initVal: true,
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