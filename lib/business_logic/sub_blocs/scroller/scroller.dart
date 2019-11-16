import 'package:counter_spell_new/core.dart';

import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';
import 'package:vibrate/vibrate.dart';


class CSScroller {

  void dispose(){
    intValue.dispose();
    isScrolling.dispose();
  }



  //==============================
  // Values

  final CSBloc parent;
  double value = 0.0;
  final BlocVar<int> intValue;
  final DelayerController delayerController;
  BlocVar<bool> isScrolling; 
  bool ignoringThisPan = false;




  //==============================
  // Constructor

  CSScroller(this.parent): 
    delayerController = DelayerController(),
    intValue = BlocVar(0)
  {
    isScrolling = BlocVar<bool>(false, onChanged: (b){
      if(b == false){
        parent.game.gameAction.privateConfirm(parent.stageBloc.controller.pagesController.page.value);
      }
    });
  }





  //========================
  // Actions 

  static const double _maxVel = 750;
  void onDragUpdate(CSDragUpdateDetails details, double width){
    if(ignoringThisPan) return;

    this.delayerController.scrolling();

    final double vx = details.velocity.pixelsPerSecond.dx;

    final double maxSpeedWeight = this.parent.settings.scrollDynamicSpeedValue.value.clamp(0.0, 1.0);
    final double multiplierVel = this.parent.settings.scrollDynamicSpeed.value 
      ? (vx / _maxVel).abs().clamp(0.0, 1.0) * maxSpeedWeight + (1-maxSpeedWeight)
      : 1.0;

    final double multiplierPreBoost = (this.parent.settings.scrollPreBoost.value && this.value > -1.0 && this.value < 1.0)
      ? this.parent.settings.scrollPreBoostValue.value.clamp(1.0, 4.0)
      : 1.0;
    final double multiplier1Static = (this.parent.settings.scroll1Static.value && this.value.abs() > 1.0 && this.value.abs() < 2.0)
      ? this.parent.settings.scroll1StaticValue.value.clamp(0.0, 1.0)
      : 1.0;


    // final double width = this.parent.scaffold.dimensions.value.globalWidth;
    final double max = this.parent.settings.scrollSensitivity.value;
    final double fraction = details.delta.dx / width;

    this.value += fraction * max * multiplierVel * multiplier1Static * multiplierPreBoost;

    if(intValue.setDistinct(value.round()))
      feedBack();
  }
  void onDragEnd(){
    if(!ignoringThisPan) this.delayerController.leaving();
    ignoringThisPan = false;
  }

  void delayerAnimationListener(AnimationStatus status){
    if(status == AnimationStatus.dismissed) {
      isScrolling.setDistinct(false);
    }
    else {
      isScrolling.setDistinct(true);
    }
  }

  void feedBack(){
    if(parent.settings.canVibrate == true)
      if(parent.settings.wantVibrate.value)
        Vibrate.feedback(FeedbackType.success);
  }

  Future<bool> decidePop([bool alsoAttacker = false]) async {
    bool cancel = false;
    if(this.value != 0.0) cancel = true;
    if(this.intValue.value != 0) cancel = true;
    if(parent.game.gameAction.selected.value.values.any((b)=>b != false)) cancel = true;
    if(alsoAttacker){
      if(parent.game.gameAction.attackingPlayer.value != "") cancel = true;
    }

    if(cancel){
      this.cancel(alsoAttacker);
      return false;
    } else {
      return true;
    }
  }

  void cancel([bool alsoAttacker = false]){
    this.value = 0.0;
    this.intValue.set(0);
    
    //this will trigger confirm() but the action will be null, so it will
    //not affect the gamestate's history
    if(!this.forceComplete()){
      parent.game.gameAction.clearSelection(true);
    } else {
      if(alsoAttacker) 
        parent.game.gameAction.attackingPlayer.set("");
    }
  }
  bool forceComplete() => isScrolling.setDistinct(false);

}