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
  BlocVar<bool> flatDesign; // vs material design


  static const bool flatLinkedToColorPlace = false;
  // Flat design always require colorPlace to be texts, but it is not always
  // the other way around. IF this constant is TRUE, then also a text colorPlace
  // means that the design is always flat, and a material design means always 
  // that the colorPlace is background.


  //================================
  // Constructor
  // Needs stage if flatDesign gets linked with stage's textPlace
  CSThemer(this.parent): 
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
    ){
    if(flatLinkedToColorPlace){
      flatDesign = BlocVar.fromCorrelate<bool, StageColorPlace>(
        from: parent.stage.themeController.colorPlace,
        map: (StageColorPlace place)
          => place.isTexts,
      );
    } else {
      flatDesign = PersistentVar<bool>(
        key: "bloc_themer_blocvar_flatDesign",
        initVal: false,
      );
    }
    assert(flatDesign != null);

  }


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
      return attack ? CSIcons.attackOne : CSIcons.defenceFilled;
    } else if (type == DamageType.counters){
      return counter.icon;
    } else {
      return CSIcons.typeIconsFilled[type];
    }
  }

  void activateFlatDesign(){
    parent.stage.themeController.colorPlace.setDistinct(StageColorPlace.texts);
    
    if(flatLinkedToColorPlace == false){
      this.flatDesign.setDistinct(true);  
    } else {
      // should get set to true automatically
    }

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
    if(flatLinkedToColorPlace){
      parent.stage.themeController.colorPlace.set(StageColorPlace.background);
      // then flat design should become false automatically
    } else {
      this.flatDesign.setDistinct(false);  
      // colorPlace can still be texts if the two are not hard linked
    }
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
  void setFlatDesign(bool val){
    if(val) activateFlatDesign();
    else deactivateFlatDesign();
  }

  void activateGoogleLikeColors(){
    if(flatLinkedToColorPlace){
      activateFlatDesign();
    } else {
      parent.stage.themeController.colorPlace
        .setDistinct(StageColorPlace.texts);
    }
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

  void setColorPlace(StageColorPlace place){
    if(place.isTexts) activateGoogleLikeColors();
    else deactivateGoogleLikeColors();
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
