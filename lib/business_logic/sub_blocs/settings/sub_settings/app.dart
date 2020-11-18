import 'package:counter_spell_new/core.dart';
import 'package:screen/screen.dart';
import 'package:vibrate/vibrate.dart';


class CSSettingsApp {

  //====================================
  // Disposer
  void dispose(){
    this.wantVibrate.dispose();
    this.alwaysOnDisplay.dispose();
    this.lastPageBeforeArena.dispose();
    this.tutored.dispose();
    this.numberFontSizeFraction.dispose();
  }

  //====================================
  // Values
  final CSBloc parent;
  final PersistentVar<bool> wantVibrate;
  bool canVibrate;
  final PersistentVar<bool> alwaysOnDisplay;
  final BlocVar<CSPage> lastPageBeforeArena;
  final PersistentVar<bool> tutored;

  final PersistentVar<double> numberFontSizeFraction;


  //====================================
  // Constructor
  CSSettingsApp(this.parent):
    wantVibrate = PersistentVar<bool>(
      key: "bloc_settings_blocvar_wantvibrate",
      initVal: true,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    numberFontSizeFraction = PersistentVar<double>(
      key: "bloc_settings_blocvar_numberFontSizeFraction",
      initVal: 0.27,
      toJson: (b) => b,
      fromJson: (j) => j,
    ),
    alwaysOnDisplay = PersistentVar<bool>(
      key: "bloc_settings_blocvar_alwaysOnDisplay",
      initVal: true,
      toJson: (b) => b,
      fromJson: (j) => j,
      onChanged: (bool b) => Screen.keepOn(b),
      readCallback: (bool b) => Screen.keepOn(b), 
    ),
    tutored= PersistentVar<bool>(
      key: "bloc_settings_blocvar_tutorial_shown",
      initVal: false,
      toJson: (b) => b,
      fromJson: (j) => j,
      readCallback: (alreadyShown){
        // if(!alreadyShown){
        //   Future.delayed(const Duration(seconds: 1)).then((_){
        //     parent.stage.showAlert(const AdvancedTutorial(), size: AdvancedTutorial.height);
        //     parent.settings.appSettings.tutored.setDistinct(true);
        //   });
        // }
      } 
    ),
    lastPageBeforeArena = PersistentVar<CSPage>(
      key: "bloc_settings_blocvar_lastPageBeforeSimpleScreen",
      initVal: CSPage.life,
      toJson: (page) => CSPages.nameOf(page),
      fromJson: (name) => CSPages.fromName(name),
    )
  {
    Vibrate.canVibrate.then(
      (canIt) => canVibrate = canIt
    );
  }



}