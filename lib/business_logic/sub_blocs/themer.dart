import 'package:counter_spell_new/core.dart';

class CSThemer {

  void dispose(){
    defenceColor.dispose();
    savedSchemes.dispose();
  }

  //================================
  // Values
  final CSBloc parent;
  final PersistentVar<Color> defenceColor;
  final PersistentVar<Map<String,CSColorScheme>> savedSchemes;
  final PersistentVar<bool> flatDesign; // vs material design


  //================================
  // Constructor
  CSThemer(this.parent): 
    flatDesign = PersistentVar<bool>(
      key: "bloc_themer_blocvar_flatDesign",
      initVal: false,
    ),
    defenceColor = PersistentVar<Color>(
      key: "bloc_themer_blocvar_defenceColor",
      initVal: CSColors.blue,
      toJson: (color) => color.value,
      fromJson: (json) => Color(json),
    ),
    savedSchemes = PersistentVar<Map<String,CSColorScheme>>(
      key: "bloc_themer_blocvar_savedSchemes",
      initVal: <String,CSColorScheme>{
        // for(final e in CSColorScheme.defaults.entries)
        //   e.key: e.value,
      },
      toJson: (map) => <String,dynamic>{for(final e in map.entries)
        e.key : e.value.toJson,
      },
      fromJson: (json) => <String,CSColorScheme>{for(final e in (json as Map).entries)
        e.key as String : CSColorScheme.fromJson(e.value),
      },
    );


  static Color getHistoryChipColor({
    @required DamageType type,
    @required bool attack,
    @required Color defenceColor,
    @required Map<CSPage,Color> pageColors,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? pageColors[CSPage.commanderDamage] : defenceColor;
    } else {
      return pageColors[CSPages.fromDamage(type)];
    }
  }

  static IconData getHistoryChangeIcon({
    @required Color defenceColor,
    @required DamageType type,
    @required bool attack,
    @required Counter counter,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? CSIcons.attackIconOne : CSIcons.defenceIconFilled;
    } else if (type == DamageType.counters){
      return counter.icon;
    } else {
      return CSIcons.typeIconsFilled[type];
    }
  }

  void activateFlatDesign(){
    parent.stage.themeController.colorPlace.setDistinct(StageColorPlace.texts);
    this.flatDesign.setDistinct(true);  
    parent.stage.themeController.topBarElevations.set(_topFlatElevations);
    parent.stage.dimensionsController.dimensions.set(
      parent.stage.dimensionsController.dimensions.value.copyWith(
        // panelHorizontalPaddingOpened: 0.0,
        panelHorizontalPaddingOpened: StageDimensions
          .defaultPanelHorizontalPaddingOpened,
      ),
    );
    parent.stage.themeController.bottomBarShadow.setDistinct(false);
  }
  void deactivateFlatDesign(){
    this.flatDesign.setDistinct(false);  
    parent.stage.themeController.topBarElevations.set(_topMaterialElevations);
    parent.stage.dimensionsController.dimensions.set(
      parent.stage.dimensionsController.dimensions.value.copyWith(
        panelHorizontalPaddingOpened: StageDimensions
          .defaultPanelHorizontalPaddingOpened,
      ),
    );
    parent.stage.themeController.bottomBarShadow.setDistinct(true);
  }
  void toggleFlatDesign(){
    if(this.flatDesign.value){
      this.deactivateFlatDesign();
    } else {
      this.activateFlatDesign();
    }
  }

  void activateGoogleLikeColors(){
    parent.stage.themeController.colorPlace.setDistinct(StageColorPlace.texts);
  }
  void deactivateGoogleLikeColors(){
    this.deactivateFlatDesign();
    parent.stage.themeController
      .colorPlace.setDistinct(StageColorPlace.background);
  }
  void toggleGoogleLikeColors(){
    if(parent.stage.themeController.colorPlace.value.isTexts){
      this.deactivateGoogleLikeColors();
    } else {
      this.activateGoogleLikeColors();
    }
  }

  static const _topMaterialElevations = <StageColorPlace,double>{
    StageColorPlace.texts: 4,
    StageColorPlace.background: 8,
  };

  static const _topFlatElevations = <StageColorPlace,double>{
    StageColorPlace.texts: 0,
    StageColorPlace.background: 8,
  };
  // static const _bottomMaterial = BoxShadow;


}
