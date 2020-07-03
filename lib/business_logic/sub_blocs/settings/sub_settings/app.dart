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
  }

  //====================================
  // Values
  final CSBloc parent;
  final PersistentVar<bool> wantVibrate;
  bool canVibrate;
  final PersistentVar<bool> alwaysOnDisplay;
  final BlocVar<CSPage> lastPageBeforeArena;
  final PersistentVar<bool> tutored;

  final PersistentVar<int> versionShown;


  //====================================
  // Constructor
  CSSettingsApp(this.parent):
    wantVibrate = PersistentVar<bool>(
      key: "bloc_settings_blocvar_wantvibrate",
      initVal: true,
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
        if(!alreadyShown){
          Future.delayed(const Duration(seconds: 1)).then((_){
            parent.stage.showAlert(const AdvancedTutorial(), size: AdvancedTutorial.height);
            parent.settings.appSettings.tutored.setDistinct(true);
          });
        }
      } 
    ),
    lastPageBeforeArena = PersistentVar<CSPage>(
      key: "bloc_settings_blocvar_lastPageBeforeSimpleScreen",
      initVal: CSPage.life,
      toJson: (page) => CSPages.nameOf(page),
      fromJson: (name) => CSPages.fromName(name),
    ),
    versionShown = PersistentVar<int>(
      key: "bloc_settings_blocvar_versionShown",
      initVal: 0,
      toJson: (b) => b,
      fromJson: (j) => j,
      readCallback: (shown){
        Future.delayed(Duration(seconds: 2)).then((_){
          if(versionCode > shown && parent.settings.appSettings.tutored.value){
            // Don't want to show the changelog if the user has not even seen the tutorial
            parent.settings.showChangelog();
          }
        });
      }
    )
  {
    Vibrate.canVibrate.then(
      (canIt) => canVibrate = canIt
    );
  }

  static const int versionCode = ChangeLogData.lastBigChange;


}