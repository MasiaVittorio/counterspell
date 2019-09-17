import 'package:counter_spell_new/widgets/scaffold/components/panel/delayer.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/bloc/bloc_var.dart';
import 'package:vibrate/vibrate.dart';

import 'scroller_recognizer.dart';
import '../../bloc.dart';

export 'scroller_recognizer.dart';

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
        parent.game.gameAction.privateConfirm();
      }
    });
  }





  //========================
  // Actions 

  static const double _maxVel = 600;
  void onDragUpdate(CSDragUpdateDetails details){
    if(ignoringThisPan) return;

    this.delayerController.scrolling();

    final double vx = details.velocity.pixelsPerSecond.dx;
    final double multiplier = (vx / _maxVel).abs().clamp(0.0, 1.0) * 0.7 + 0.3;
    final double width = this.parent.scaffold.dimensions.value.globalWidth;
    final double max = this.parent.settings.scrollSensitivity.value;
    final double fraction = details.delta.dx / width;

    this.value += fraction * max * multiplier;

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


  void cancel(){
    this.value = 0.0;
    this.intValue.set(0);
    
    //this will trigger confirm() but the action will be null, so it will
    //not affect the gamestate's history
    if(!this.forceComplete())
      parent.game.gameAction.clearSelection();
  }
  bool forceComplete() => isScrolling.setDistinct(false);

}