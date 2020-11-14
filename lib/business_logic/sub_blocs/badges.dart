import 'package:counter_spell_new/core.dart';


class CSBadges {

  //================================
  // Dispose resources 
  void dispose(){
    this.versionShown.dispose();
    this.stuffILikeShown.dispose();
  }

  //================================
  // Values 
  final CSBloc parent; 

  PersistentVar<int> versionShown;
  bool get changelogBadge => versionShown.value < versionCode;
  PersistentVar<int> stuffILikeShown;
  bool get stuffILikeBadge => stuffILikeShown.value < lastStuffILike;

  CSBadges(this.parent){ // needs to be after stage to show badges
    versionShown = PersistentVar<int>(
      key: "bloc_badges_blocvar_versionShown",
      initVal: 0,
      toJson: (b) => b,
      fromJson: (j) => j,
      readCallback: (shown){
        Future.delayed(Duration(seconds: 2)).then((_){
          if(!stuffILikeShown.reading){
            _check();
          }
        });
      }
    );
    stuffILikeShown = PersistentVar<int>(
      key: "bloc_badges_blocvar_stuffILikeShown",
      initVal: 0,
      toJson: (b) => b,
      fromJson: (j) => j,
      readCallback: (shown){
        Future.delayed(Duration(seconds: 2)).then((_){
          if(!versionShown.reading){
            _check();
          }
        });
      }
    );
  } 

  bool checked = false;
  void _check(){
    if(checked) return;
    if(this.changelogBadge || this.stuffILikeBadge){
      parent.stage.badgesController.showPanelPage(SettingsPage.info);
    } else {
      parent.stage.badgesController.clearPanelPage(SettingsPage.info);
    }
    checked = true;
  }

  void showChangelog(){
    parent.stage.showAlert(const Changelog(), size: Changelog.height);
    versionShown.set(versionCode);
    if(!stuffILikeBadge) {
      parent.stage.badgesController.clearPanelPage(SettingsPage.info);
    }
  }

  void showStuffILike(){
    parent.stage.showAlert(const StuffILikeAlert(), size: StuffILikeAlert.height);
    stuffILikeShown.set(lastStuffILike);
    if(!changelogBadge) {
      parent.stage.badgesController.clearPanelPage(SettingsPage.info);
    }
  }

  static const int versionCode = ChangeLogData.lastBigChange;
  static const int lastStuffILike = 4;
  // 4 Command Bros


}

