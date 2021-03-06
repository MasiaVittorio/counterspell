import 'package:counter_spell_new/core.dart';

import 'package:counter_spell_new/widgets/stageboard/panel/collapsed_components/delayer.dart';
import 'package:vibrate/vibrate.dart';


class CSScroller {

  void dispose(){
    intValue.dispose();
    isScrolling.dispose();
    _onNextAutoConfirm.clear();
  }



  //==============================
  // Values

  final bool justTutorial;

  final CSBloc parent;
  double value = 0.0;
  final BlocVar<int> intValue;
  final DelayerController delayerController;
  BlocVar<bool> isScrolling; 
  bool ignoringThisPan = false;
  final Map<String,VoidCallback> _onNextAutoConfirm = <String,VoidCallback>{};
  bool _clearNextAutoConfirm = false;




  //==============================
  // Constructor

  CSScroller(this.parent, {void Function(int) tutorialConfirm}): 
    delayerController = DelayerController(),
    intValue = BlocVar(0),
    justTutorial = tutorialConfirm != null //in case this is a dummy scroller for the tutorial page, it has not to interfere with the bloc 
  {
    isScrolling = BlocVar<bool>(false, onChanged: (b){
      if(b == false){
        if(tutorialConfirm != null){
          tutorialConfirm(this.intValue.value);
          this.value = 0.0;
          this.intValue.set(0);
        } else {
          parent.game.gameAction.privateConfirm(
            parent.stageBloc.controller.mainPagesController.currentPage
          );
        }
      }
    });
  }





  //========================
  // Actions 

  static const double _maxVel = 750;
  void onDragUpdate(CSDragUpdateDetails details, double width, {bool vertical = false}){
    if(ignoringThisPan) return;

    final scrollSettings = this.parent.settings.scrollSettings;
    this.delayerController.scrolling();

    final double vx = vertical 
      ? details.velocity.pixelsPerSecond.dy 
      : details.velocity.pixelsPerSecond.dx;

    final double maxSpeedWeight = scrollSettings.scrollDynamicSpeedValue.value.clamp(0.0, 1.0);
    final double multiplierVel = scrollSettings.scrollDynamicSpeed.value 
      ? (vx / _maxVel).abs().clamp(0.0, 1.0) * maxSpeedWeight + (1-maxSpeedWeight)
      : 1.0;

    final double multiplierPreBoost = (scrollSettings.scrollPreBoost.value && this.value > -1.0 && this.value < 1.0)
      ? scrollSettings.scrollPreBoostValue.value.clamp(1.0, 4.0)
      : 1.0;
    final double multiplier1Static = (scrollSettings.scroll1Static.value && this.value.abs() > 1.0 && this.value.abs() < 2.0)
      ? scrollSettings.scroll1StaticValue.value.clamp(0.0, 1.0)
      : 1.0;


    // final double width = this.parent.scaffold.dimensions.value.globalWidth;
    final double max = scrollSettings.scrollSensitivity.value;
    final double fraction = (vertical ? - details.delta.dy : details.delta.dx) / width;

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
      if(isScrolling.setDistinct(false)){
        _performAutoConfirm();
      }
      _performClearAutoConfirm();
    } else {
      if(isScrolling.setDistinct(true)){
        _performClearAutoConfirm();
      }
    }
  }

  void _performAutoConfirm(){
    if(_clearNextAutoConfirm){
      _performClearAutoConfirm();
    } else {
      for(final key in this._onNextAutoConfirm.keys){
        _onNextAutoConfirm[key]?.call();
      }
    }
  }

  void _performClearAutoConfirm(){
    this._onNextAutoConfirm.clear();
    this._clearNextAutoConfirm = false;
  }

  void registerCallbackOnNextAutoConfirm(String key, VoidCallback callback){
    if(_clearNextAutoConfirm) this._performClearAutoConfirm();   
    this._onNextAutoConfirm[key] = callback;
  } 


  void feedBack(){
    if(parent.settings.appSettings.canVibrate == true)
      if(parent.settings.appSettings.wantVibrate.value)
        Vibrate.feedback(FeedbackType.success);
  }

  Future<bool> decidePop([bool alsoAttacker = false]) async {
    bool cancel = false;
    
    if (this.value != 0.0) {
      cancel = true;
    } else if (this.intValue.value != 0) {
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

  void cancel([bool alsoAttacker = false]){
    this.value = 0.0;
    this.intValue.set(0);

    //this will trigger confirm() but the action will be null, so it will
    //not affect the gamestate's history
    bool completed = this.forceComplete();
    if(this.justTutorial) return;

    if(!completed){
      parent.game.gameAction.clearSelection(true);
    } else {
      if(alsoAttacker) 
        parent.game.gameAction.attackingPlayer.set("");
    }
    _clearNextAutoConfirm = true;
  }

  bool forceComplete() => isScrolling.setDistinct(false);

  void editVal(int by){
    this.delayerController.scrolling();
    this.intValue.value += by;
    this.intValue.refresh();
    this.delayerController.leaving();
  }

}