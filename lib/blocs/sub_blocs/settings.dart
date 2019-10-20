import 'package:sidereus/bloc/bloc_var_persistent.dart';
import 'package:vibrate/vibrate.dart';

import '../bloc.dart';

class CSSettings {

  void dispose(){
    this.scrollSensitivity.dispose();
    this.wantVibrate.dispose();
    this.startingLife.dispose();
    this.minValue.dispose();
    this.maxValue.dispose();
    this.confirmDelay.dispose();
  }


  //===================================
  // Values
  final CSBloc parent;

  final PersistentVar<double> scrollSensitivity;
  final PersistentVar<bool> wantVibrate;
  bool canVibrate;
  final PersistentVar<int> startingLife;
  final PersistentVar<int> minValue;
  final PersistentVar<int> maxValue;

  final PersistentVar<Duration> confirmDelay;
  final PersistentVar<bool> applyDamageToLife;



  //===================================
  // Constructor
  CSSettings(this.parent): 
    scrollSensitivity = PersistentVar<double>(
      key: "bloc_settings_blocvar_scrollsens",
      initVal: 8,
      toJson: (d) => d,
      fromJson: (j) => j,
    ),
    wantVibrate = PersistentVar<bool>(
      key: "bloc_settings_blocvar_wantvibrate",
      initVal: true,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    applyDamageToLife= PersistentVar<bool>(
      key: "bloc_settings_blocvar_applyDamageToLife",
      initVal: true,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    startingLife = PersistentVar<int>(
      key: "bloc_settings_blocvar_startinglife",
      initVal: 40,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    minValue = PersistentVar<int>(
      key: "bloc_settings_blocvar_minvalue",
      initVal: -999,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    maxValue = PersistentVar<int>(
      key: "bloc_settings_blocvar_maxvalue",
      initVal: 9999,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    confirmDelay = PersistentVar<Duration>(
      key: "bloc_settings_blocvar_confirmdelay",
      initVal: const Duration(milliseconds: 700),
      toJson: (dur) => dur.inMilliseconds,
      fromJson: (json) => Duration(milliseconds: json),
    )
  {
    Vibrate.canVibrate.then(
      (canIt) => canVibrate = canIt
    );
  }


  //===================================
  // Action


}