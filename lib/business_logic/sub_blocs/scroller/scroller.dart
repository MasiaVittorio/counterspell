import 'package:counter_spell_new/core.dart';

import 'scroller_generic.dart';

class CSScroller extends ScrollerLogic {

  //==============================
  // Values

  final CSBloc parent;


  //==============================
  // Constructor

  CSScroller(this.parent): super(
    scrollSettings: parent.settings.scrollSettings,
    okVibrate: () => parent.settings.appSettings.canVibrate! 
      && parent.settings.appSettings.wantVibrate.value,

    onConfirm: (_) => parent.game.gameAction.privateConfirm(
      parent.stageBloc.controller.mainPagesController.currentPage
    ),
    resetAfterConfirm: false,

    onCancel: (completed, alsoAttacker){
      if(!completed){
        parent.game.gameAction.clearSelection(true);
      } else {
        if(alsoAttacker) {
          parent.game.gameAction.attackingPlayer.set("");
        }
      }
    },
  );


  Future<bool> decidePop([bool alsoAttacker = false]) async {
    bool cancel = false;
    
    if (value != 0.0) {
      cancel = true;
    } else if (intValue.value != 0) {
      cancel = true;
    } else if (parent.game.gameAction.isSomeoneSelected) {
      cancel = true;
    } else if (alsoAttacker && parent.game.gameAction.attackingPlayer.value != "") {
      cancel = true;
    }

    if(cancel){
      this.cancel(alsoAttacker);
      return false;
    } else {
      return true;
    }
  }

}