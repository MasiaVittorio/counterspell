import 'package:flutter/material.dart';

import 'dart:math';

enum DelayerListenerType {
  mainScreen,
  arena
}

class DelayerController {
  Map<DelayerListenerType,bool Function()> _starts = <DelayerListenerType, bool Function()>{
    DelayerListenerType.mainScreen: null,
    DelayerListenerType.arena: null,
  };
  Map<DelayerListenerType,bool Function()> _ends = <DelayerListenerType, bool Function()>{
    DelayerListenerType.mainScreen: null,
    DelayerListenerType.arena: null,
  };

  void addListenersMain({
    @required bool Function() startListener,
    @required bool Function() endListener,
  }){
    this._starts[DelayerListenerType.mainScreen] = startListener;
    this._ends[DelayerListenerType.mainScreen] = endListener;
  }
  void addListenersArena({
    @required bool Function() startListener,
    @required bool Function() endListener,
  }){
    this._starts[DelayerListenerType.arena] = startListener;
    this._ends[DelayerListenerType.arena] = endListener;
  }

  void removeArenaListeners(){
    this._starts[DelayerListenerType.arena] = null;
    this._ends[DelayerListenerType.arena] = null;
  }

  void scrolling(){
    final arena = _starts[DelayerListenerType.arena];
    if(!(arena?.call() ?? false)){
      _starts[DelayerListenerType.mainScreen]?.call();
    }
  }
  void leaving(){
    final arena = _ends[DelayerListenerType.arena];
    if(!(arena?.call() ?? false)){
      _ends[DelayerListenerType.mainScreen]?.call();
    }
  }
}


class Delayer extends StatefulWidget {
  final Duration duration;

  final double height;

  final Color primaryColor;
  final Color onPrimaryColor;
  final Color accentColor;
  final Color onAccentColor;

  final void Function(AnimationStatus) animationListener;
  final void Function() onManualCancel;
  final void Function() onManualConfirm;
  final DelayerController delayerController;

  final String message;
  final TextStyle style;
  final double circleOffset;
  final bool half;


  Delayer({
    @required this.half,
    @required this.animationListener,
    @required this.onManualCancel,
    @required this.onManualConfirm,
    @required this.delayerController,
    @required this.circleOffset,
    @required this.duration,
    @required this.height,
    @required this.primaryColor,
    @required this.onPrimaryColor,
    @required this.accentColor,
    @required this.onAccentColor,
    @required this.message,
    @required this.style,
  });

  @override
  State createState() => new _DelayerState();
}

class _DelayerState extends State<Delayer> with TickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();

    this.initController();

    widget.delayerController.addListenersMain(
      startListener: scrolling,
      endListener: leaving,
    );

  }


  void initController(){
    controller?.dispose();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    controller.addStatusListener(widget.animationListener);
  }

  @override
  void didUpdateWidget(Delayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.duration != controller.duration){
      controller.dispose();
      initController();
    }
  }

  bool scrolling(){
    if(!mounted) return false;
    if(controller.isAnimating && controller.velocity > 0)
      return true;
    if(controller.value == 1.0)
      return true;

    this.controller.fling();
    return true;
  }

  bool leaving() {
    if(!mounted) return false;
    if(this.controller.value == 0.0)
      return true;

    bool fling = false;
    if(this.controller.isAnimating){
      if(this.controller.velocity < 0)
        return true;
      fling = true;
    }
    _leaving(fling);
    return true;
  }

  void _leaving(bool withFling) async {
    if(!mounted) return;
    if(withFling) await  this.controller.fling();
    if(!mounted) return;
    this.controller.animateBack(0.0);
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      final double width = constraints.maxWidth;
      final double xOffset = width - widget.circleOffset;
      final Offset offset = Offset(
        xOffset, 
        widget.height / 2
      );
      final double maxRadius = sqrt(
        xOffset * xOffset
        +
        (widget.height/2) * (widget.height/2)
      );

      return Stack(
        children: <Widget>[
          _Content(
            half: widget.half,
            message: widget.message,
            style: widget.style,
            color: widget.primaryColor,
            contrast: widget.onPrimaryColor,
            width: width,
            height: widget.height,
          ),
          AnimatedBuilder(
            animation: controller,
            child: _Content(
              half: widget.half,
              message: widget.message,
              style: widget.style,
              color: widget.accentColor,
              contrast: widget.onAccentColor,
              width: width,
              height: widget.height,
            ),
            builder: (BuildContext context, Widget childA) {
              double s = controller.value;
              return ClipOval(
                child: Container(
                  width: width,
                  height: widget.height,
                  child: childA,
                ),
                clipper: _CircleClipper(
                  center: offset,
                  radius: s * maxRadius,
                )
              );
            }
          ),
          _ContentTappable(
            half: widget.half,
            onCancel: widget.onManualCancel,
            onConfirm: widget.onManualConfirm,
            width: width,
            height: widget.height,
          )
        ],
      );
    });
  }
}


class _Content extends StatelessWidget{
  final double width;
  final double height;

  final Color color;
  final Color contrast;

  final String message;
  final TextStyle style;
  final bool half;

  _Content({
    @required this.half,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.contrast,
    @required this.message,
    @required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color,
      width: this.width,
      height: this.height,
      alignment: Alignment.topCenter,
      child: Container(
        height: this.height/(half?2:1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: this.height,
              height: this.height/(half?2:1),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: this.contrast,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  this.message,
                  style: this.style.copyWith(color: this.contrast),
                ),
              ),
            ),
            Container(
              width: this.height,
              height: this.height/(half?2:1),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: this.contrast,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ContentTappable extends StatelessWidget{
  final double width;
  final double height;
  final bool half;

  final void Function() onConfirm;
  final void Function() onCancel;

  _ContentTappable({
    @required this.half,
    @required this.width,
    @required this.height,
    @required this.onConfirm,
    @required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (this.height*2).clamp(0, width/2);
    final buttonHeight = this.height/(half?2:1); 

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: this.width,
        height: this.height,
        alignment: Alignment.topCenter,
        child: Container(
          height: this.height/(half?2:1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkResponse(
                onTap: this.onCancel,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                ),
              ),
              InkResponse(
                onTap: this.onConfirm,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Rect> {
  _CircleClipper({this.center, this.radius});

  final Offset center;
  final double radius;

  @override
  Rect getClip(Size size) {
    var rect = Rect.fromCircle(radius: radius, center: center);

    return rect;
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) => oldClipper.radius != this.radius || oldClipper.center != this.center;
}
