import 'package:flutter/material.dart';

import 'dart:math';


class DelayerController {
  void Function() _start;
  void Function() _end;

  void addListeners({
    @required void Function() startListener,
    @required void Function() endListener,
  }){
    this._start = startListener;
    this._end = endListener;
  }

  void scrolling(){
    if(_start != null)
      _start();
  }
  void leaving(){
    if(_end != null)
      _end();
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

    widget.delayerController.addListeners(
      startListener: scrolling,
      endListener: leaving,
    );

  }


  void initController(){
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
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

  void scrolling(){
    if(controller.isAnimating && controller.velocity > 0)
      return;
    if(controller.value == 1.0)
      return;

    this.controller.fling();
  }
  void leaving() async {
    if(this.controller.value == 0.0)
      return;
    if(this.controller.isAnimating){
      if(this.controller.velocity < 0)
        return;
      await controller.fling();
    }
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
      final width = constraints.maxWidth;

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
                  center: Offset(
                    width - widget.circleOffset, 
                    widget.height / 2
                  ),
                  radius: s * sqrt(
                    (width - widget.circleOffset) * (width - widget.circleOffset)
                    +
                    (widget.height/2) * (widget.height/2)
                  )
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
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
