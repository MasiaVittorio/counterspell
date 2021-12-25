import 'package:counter_spell_new/core.dart';

class CSSettingsScroll {

  //=======================================
  // Disposer

  void dispose(){
    this.confirmDelay.dispose();

    this.scrollSensitivity.dispose();

    this.scroll1Static.dispose();
    this.scroll1StaticValue.dispose();
    this.scrollPreBoost.dispose();
    this.scrollPreBoostValue.dispose();
    this.scrollDynamicSpeed.dispose();
    this.scrollDynamicSpeedValue.dispose();
  }


  //=======================================
  // Values

  final CSBloc parent;

  final PersistentVar<Duration> confirmDelay;

  final PersistentVar<double?> scrollSensitivity;

  final PersistentVar<bool?> scrollPreBoost;
  final PersistentVar<double?> scrollPreBoostValue;

  final PersistentVar<bool?> scroll1Static;
  final PersistentVar<double?> scroll1StaticValue;

  final PersistentVar<bool?> scrollDynamicSpeed;
  final PersistentVar<double?> scrollDynamicSpeedValue;


  //====================================
  // Default values
  static const double sensVal = 7.2;
  static const double sensSpeedVal = 0.4;
  static const double sensPreBoostVal= 2.0;
  static const double sens1StaticVal= 0.8;
  static const Duration confirmDelayVal = const Duration(milliseconds: 950);


  //=======================================
  // Constructor
  CSSettingsScroll(this.parent):
    confirmDelay = PersistentVar<Duration>(
      key: "bloc_settings_blocvar_confirmdelay",
      initVal: confirmDelayVal,
      toJson: (dur) => dur.inMilliseconds,
      fromJson: (json) => Duration(milliseconds: json),
    ),
    scrollSensitivity = PersistentVar<double?>(
      key: "bloc_settings_blocvar_scrollsens",
      initVal: sensVal,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scrollDynamicSpeed = PersistentVar<bool?>(
      key: "bloc_settings_blocvar_scrollDynamicSpeed",
      initVal: true,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scrollDynamicSpeedValue = PersistentVar<double?>(
      key: "bloc_settings_blocvar_scrollDynamicSpeedValue",
      initVal: sensSpeedVal, //0.1 to 0.9
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scrollPreBoost = PersistentVar<bool?>(
      key: "bloc_settings_blocvar_scrollPreBoost",
      initVal: true,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scrollPreBoostValue = PersistentVar<double?>(
      key: "bloc_settings_blocvar_scrollPreBoostValue",
      initVal: sensPreBoostVal, //1.1 to 3.5
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scroll1Static = PersistentVar<bool?>(
      key: "bloc_settings_blocvar_scroll1Static",
      initVal: true,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    scroll1StaticValue = PersistentVar<double?>(
      key: "bloc_settings_blocvar_scroll1StaticValue",
      initVal: sens1StaticVal, // 0.1 to 0.8
      toJson: (d) => d,
      fromJson: (j) => j,
    );



  //=======================================
  // Methods

}

