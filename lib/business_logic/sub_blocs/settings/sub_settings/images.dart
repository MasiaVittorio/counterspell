import 'package:counter_spell_new/core.dart';

class CSSettingsImages {

  //================================
  // Disposer
  void dispose(){
    this.imageAlignments.dispose();
    this.imageGradientStart.dispose();
    this.imageGradientEnd.dispose();
    this.arenaImageOpacity.dispose();
  }

  //================================
  // Values

  final CSBloc parent;
  final PersistentVar<Map<String,double>> imageAlignments;
  final PersistentVar<double> imageGradientStart;
  final PersistentVar<double> imageGradientEnd;
  final PersistentVar<double> arenaImageOpacity;

  //====================================
  // Default values
  static const double defaultImageGradientEnd = 0.3;
  static const double defaultImageGradientStart = 0.65;
  static const double defaultSimpleImageOpacity = 0.65;


  //================================
  // Constructor
  CSSettingsImages(this.parent):
    imageAlignments = PersistentVar<Map<String,double>>(
      key: "bloc_settings_blocvar_imageAlignments",
      initVal: <String,double>{},
      toJson: (map) => map,
      fromJson: (json) => <String,double>{
        for(final entry in (json as Map).entries)
          entry.key: entry.value,          
      },
    ),
    imageGradientStart = PersistentVar<double>(
      key: "bloc_settings_blocvar_imageGradientStart",
      initVal: defaultImageGradientStart,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    imageGradientEnd = PersistentVar<double>(
      key: "bloc_settings_blocvar_imageGradientEnd",
      initVal: defaultImageGradientEnd,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    arenaImageOpacity = PersistentVar<double>(
      key: "bloc_settings_blocvar_simpleImageOpacity",
      initVal: defaultSimpleImageOpacity,
      toJson: (d) => d,
      fromJson: (j) => j,
    );


  //================================
  // Methods


}

