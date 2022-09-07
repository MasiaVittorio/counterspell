import 'package:counter_spell_new/core.dart';

class CSThemer {

  Color computePanelColor(double val, ThemeData theme) => Color.alphaBlend(
    parent.stage.themeController.derived.mainPageToPrimaryColor
      .value![parent.stage.mainPagesController.currentPage]!
      .withOpacity(val.mapToRangeLoose(0.1, 0.0)), 
    theme.canvasColor,
  );

  void dispose(){
    resolvableDefenceColor.dispose();
    savedSchemes.dispose();
  }

  //================================
  // Values
  final CSBloc parent;
  final PersistentVar<ResolvableColor> resolvableDefenceColor;
  late final BlocVar<Color> defenceColor;
  final PersistentVar<Map<String,CSColorScheme>> savedSchemes;
  late BlocVar<bool> flatDesign; // vs material design


  //================================
  // Constructor
  // Needs stage if flatDesign gets linked with stage's textPlace
  CSThemer(this.parent): 
    resolvableDefenceColor = PersistentVar<ResolvableColor>(
      key: "bloc_themer_blocvar_defenceResolvable",
      initVal: ResolvableColor.def,
      toJson: (color) => color.map,
      fromJson: (json) => ResolvableColor.fromMap(json),
    ),
    savedSchemes = PersistentVar<Map<String,CSColorScheme>>(
      key: "bloc_themer_blocvar_savedSchemes",
      initVal: <String,CSColorScheme>{},
      toJson: (map) => <String,dynamic>{for(final e in map.entries)
        e.key: e.value.toJson,
      },
      fromJson: (json) => <String,CSColorScheme>{for(final e in (json as Map).entries)
        e.key as String : CSColorScheme.fromJson(e.value),
      },
    ){

    flatDesign = BlocVar.fromCorrelate<bool, StageColorPlace>(
      from: parent.stage.themeController.colorPlace,
      map: (StageColorPlace place)
        => place.isTexts,
    );

    defenceColor = BlocVar.fromCorrelateLatest4<
      Color,
      Brightness,
      DarkStyle,
      StageColorPlace,
      ResolvableColor
    >(
      parent.stage.themeController.brightness.brightness, 
      parent.stage.themeController.brightness.darkStyle, 
      parent.stage.themeController.colorPlace, 
      resolvableDefenceColor, 
      map: (brightness, darkStyle, place, color){
        return color.resolveState(
          brightness: brightness, 
          place: place, 
          darkStyle: darkStyle,
        );
      },
    );

  }

  Color get resolveDefenceColor 
    => resolvableDefenceColor.value.resolveStage(parent.stage);

  Widget buildFromDefenceColor(Widget Function(BuildContext, Color) builder)
    => resolvableDefenceColor.build(
      (context, color) => color.build(stage: parent.stage, builder: builder),
    );


  static Color? getHistoryChipColor({
    required DamageType type,
    required bool? attack,
    required Color defenceColor,
    required Map<CSPage?,Color?>? pageColors,
  }){
    if(type == DamageType.commanderDamage){
      return attack! ? pageColors![CSPage.commanderDamage] : defenceColor;
    } else {
      return pageColors![CSPages.fromDamage(type)];
    }
  }

  static IconData? getHistoryChangeIcon({
    required Color defenceColor,
    required DamageType type,
    required bool? attack,
    required Counter? counter,
  }){
    if(type == DamageType.commanderDamage){
      return attack! ? CSIcons.attackOne : CSIcons.defenceFilled;
    } else if (type == DamageType.counters){
      return counter!.icon;
    } else {
      return CSIcons.typeIconsFilled[type];
    }
  }

  void activateFlatDesign(){
    parent.stage.themeController.colorPlace.setDistinct(StageColorPlace.texts);
    parent.stage.dimensionsController.dimensions.set(
      parent.stage.dimensionsController.dimensions.value.copyWith(
        panelHorizontalPaddingOpened: panelHorizontalPaddingOpenedTexts,
      ),
    );
    parent.stage.themeController.bottomBarShadow.setDistinct(false);
  }

  void deactivateFlatDesign(){
    parent.stage.themeController.colorPlace.set(StageColorPlace.background);
    // then flat design should become false automatically
    parent.stage.dimensionsController.dimensions.set(
      parent.stage.dimensionsController.dimensions.value.copyWith(
        panelHorizontalPaddingOpened: StageDimensions
          .defaultPanelHorizontalPaddingOpened,
      ),
    );
    parent.stage.themeController.bottomBarShadow.setDistinct(true);
  }

  void toggleFlatDesign(){
    if(flatDesign.value){
      deactivateFlatDesign();
    } else {
      activateFlatDesign();
    }
  }
  void setFlatDesign(bool val){
    if(val) {
      activateFlatDesign();
    } else {
      deactivateFlatDesign();
    }
  }

  static const topBarElevations = <StageColorPlace,double>{
    StageColorPlace.texts: 0,
    StageColorPlace.background: 8,
  };

  static const double panelHorizontalPaddingOpenedTexts = 0;

}
