import 'package:counter_spell_new/core.dart';

class ResolvableColor {

  static ResolvableColor get def => ResolvableColor(
    light: FlatSolidColor(
      flat: CSColorScheme.defaultGoogleLight.defenceColor,
      solid: CSColorScheme.defaultLight.defenceColor,
    ), 
    dark: DarkStyleColor(
      nightBlack: FlatSolidColor(
        flat: CSColorScheme.defaultGoogleNightBlack.defenceColor,
        solid: CSColorScheme.defaultNightBlack.defenceColor
      ),
      nightBlue: FlatSolidColor(
        flat: CSColorScheme.defaultGoogleNightBlue.defenceColor,
        solid: CSColorScheme.defaultNightBlue.defenceColor
      ),
      dark: FlatSolidColor(
        flat: CSColorScheme.defaultGoogleDark.defenceColor,
        solid: CSColorScheme.defaultDark.defenceColor
      ),
      amoled: FlatSolidColor(
        flat: CSColorScheme.defaultGoogleAmoled.defenceColor,
        solid: CSColorScheme.defaultAmoled.defenceColor
      ),
    ),
  ); 

  final FlatSolidColor light;
  final DarkStyleColor dark;

  ResolvableColor({
    required this.light,
    required this.dark,
  });

  Color resolveState({
    required Brightness brightness,
    required StageColorPlace place,
    required DarkStyle darkStyle,
  })=> resolve(
    isLight: brightness.isLight, 
    isFlat: place.isTexts, 
    darkStyle: darkStyle,
  );

  Color resolveStage(StageData stage) => resolveState(
    brightness: stage.themeController.brightness.brightness.value, 
    place: stage.themeController.colorPlace.value, 
    darkStyle: stage.themeController.brightness.darkStyle.value,
  );

  Widget build({
    required StageData stage, 
    required Widget Function(BuildContext, Color) builder,
  }) => buildFromDefenceColor(stage: stage, color: this, builder: builder);

  static Widget buildFromDefenceColor({
    required StageData stage, 
    required ResolvableColor color,
    required Widget Function(BuildContext, Color) builder,
  }){
    return BlocVar.build3<Brightness, StageColorPlace, DarkStyle>(
      stage.themeController.brightness.brightness, 
      stage.themeController.colorPlace, 
      stage.themeController.brightness.darkStyle, 
      builder: (context, brightness, place, darkStyle)
        => builder(context, color.resolveState(
          brightness: brightness, 
          place: place, 
          darkStyle: darkStyle,
        )),
    );
  } 

  Color resolve({
    required bool isLight,
    required bool isFlat,
    required DarkStyle darkStyle,
  }){
    if(isLight){
      return light.resolve(isFlat);
    } else {
      return dark.resolve(isFlat: isFlat, darkStyle: darkStyle);
    }
  }

  ResolvableColor copyWithState({
    required Color color,
    required bool isLight,
    required bool isFlat,
    required DarkStyle darkStyle,
  }){
    if(isLight){
      return copyWith(light: light.copyWithState(
        color: color, 
        isFlat: isFlat,
      ));
    } else {
      return copyWith(dark: dark.copyWithState(
        color: color, 
        isFlat: isFlat, 
        darkStyle: darkStyle,
      ));
    }
  }

  ResolvableColor copyWith({
    FlatSolidColor? light,
    DarkStyleColor? dark,
  }) {
    return ResolvableColor(
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  Map<String, dynamic> get map {
    return <String, dynamic>{
      'light': light.map,
      'dark': dark.map,
    };
  }

  factory ResolvableColor.fromMap(Map<String, dynamic> map) {
    return ResolvableColor(
      light: FlatSolidColor.fromMap(map['light'] as Map<String,dynamic>),
      dark: DarkStyleColor.fromMap(map['dark'] as Map<String,dynamic>),
    );
  }

  @override
  String toString() => 'ResolvableColor(light: $light, dark: $dark)';

  @override
  bool operator ==(covariant ResolvableColor other) {
    if (identical(this, other)) return true;
  
    return 
      other.light == light &&
      other.dark == dark;
  }

  @override
  int get hashCode => light.hashCode ^ dark.hashCode;
}

class FlatSolidColor {
  
  final Color flat;
  final Color solid;

  const FlatSolidColor({
    required this.flat,
    required this.solid,
  });

  Color resolve(bool isFlat){
    return isFlat ? flat : solid;
  }

  FlatSolidColor copyWithState({
    required Color color,
    required bool isFlat,
  }){
    if(isFlat){
      return copyWith(flat: color);
    } else {
      return copyWith(solid: color);
    }
  }

  FlatSolidColor copyWith({
    Color? flat,
    Color? solid,
  }) {
    return FlatSolidColor(
      flat: flat ?? this.flat,
      solid: solid ?? this.solid,
    );
  }

  Map<String, dynamic> get map {
    return <String, dynamic>{
      'flat': flat.value,
      'solid': solid.value,
    };
  }

  factory FlatSolidColor.fromMap(Map<String, dynamic> map) {
    return FlatSolidColor(
      flat: Color(map['flat'] as int),
      solid: Color(map['solid'] as int),
    );
  }

  @override
  String toString() => 'FlatSolidColor(flat: $flat, solid: $solid)';

  @override
  bool operator ==(covariant FlatSolidColor other) {
    if (identical(this, other)) return true;
  
    return 
      other.flat == flat &&
      other.solid == solid;
  }

  @override
  int get hashCode => flat.hashCode ^ solid.hashCode;
}



class DarkStyleColor {
  
  final FlatSolidColor dark;
  final FlatSolidColor nightBlack;
  final FlatSolidColor nightBlue;
  final FlatSolidColor amoled;

  DarkStyleColor({
    required this.dark,
    required this.nightBlack,
    required this.nightBlue,
    required this.amoled,
  });

  Color resolve({
    required bool isFlat,
    required DarkStyle darkStyle,
  }){
    switch (darkStyle) {
      case DarkStyle.amoled:
        return amoled.resolve(isFlat);
      case DarkStyle.dark:
        return dark.resolve(isFlat);
      case DarkStyle.nightBlack:
        return nightBlack.resolve(isFlat);
      case DarkStyle.nightBlue:
        return nightBlue.resolve(isFlat);
      default:
        return nightBlue.resolve(isFlat);
    }
  }

  DarkStyleColor copyWithState({
    required Color color,
    required bool isFlat,
    required DarkStyle darkStyle,
  }){
    switch (darkStyle) {
      case DarkStyle.amoled:
        return copyWith(
          amoled: amoled.copyWithState(color: color, isFlat: isFlat),
        );
      case DarkStyle.nightBlack:
        return copyWith(
          nightBlack: nightBlack.copyWithState(color: color, isFlat: isFlat),
        );
      case DarkStyle.nightBlue:
        return copyWith(
          nightBlue: nightBlue.copyWithState(color: color, isFlat: isFlat),
        );
      case DarkStyle.dark:
        return copyWith(
          dark: dark.copyWithState(color: color, isFlat: isFlat),
        );
      default:
        return copyWith();
    }
  }

  DarkStyleColor copyWith({
    FlatSolidColor? dark,
    FlatSolidColor? nightBlack,
    FlatSolidColor? nightBlue,
    FlatSolidColor? amoled,
  }) {
    return DarkStyleColor(
      dark: dark ?? this.dark,
      nightBlack: nightBlack ?? this.nightBlack,
      nightBlue: nightBlue ?? this.nightBlue,
      amoled: amoled ?? this.amoled,
    );
  }

  Map<String, dynamic> get map {
    return <String, dynamic>{
      'dark': dark.map,
      'nightBlack': nightBlack.map,
      'nightBlue': nightBlue.map,
      'amoled': amoled.map,
    };
  }

  factory DarkStyleColor.fromMap(Map<String, dynamic> map) {
    return DarkStyleColor(
      dark: FlatSolidColor.fromMap(map['dark']),
      nightBlack: FlatSolidColor.fromMap(map['nightBlack']),
      nightBlue: FlatSolidColor.fromMap(map['nightBlue']),
      amoled: FlatSolidColor.fromMap(map['amoled']),
    );
  }

  @override
  String toString() {
    return 'DarkStyleColor(dark: $dark, nightBlack: $nightBlack, nightBlue: $nightBlue, amoled: $amoled)';
  }

  @override
  bool operator ==(covariant DarkStyleColor other) {
    if (identical(this, other)) return true;
  
    return 
      other.dark == dark &&
      other.nightBlack == nightBlack &&
      other.nightBlue == nightBlue &&
      other.amoled == amoled;
  }

  @override
  int get hashCode {
    return dark.hashCode ^
      nightBlack.hashCode ^
      nightBlue.hashCode ^
      amoled.hashCode;
  }
}
