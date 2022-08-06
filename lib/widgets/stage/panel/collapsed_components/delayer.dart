import 'package:flutter/material.dart';

import 'dart:math';

enum DelayerListenerType {
  mainScreen,
  arena
}

class DelayerController {
  final Map<DelayerListenerType,bool Function()?> _starts = <DelayerListenerType, bool Function()?>{
    DelayerListenerType.mainScreen: null,
    DelayerListenerType.arena: null,
  };
  final Map<DelayerListenerType,bool Function()?> _ends = <DelayerListenerType, bool Function()?>{
    DelayerListenerType.mainScreen: null,
    DelayerListenerType.arena: null,
  };

  void addListenersMain({
    required bool Function() startListener,
    required bool Function() endListener,
  }){
    _starts[DelayerListenerType.mainScreen] = startListener;
    _ends[DelayerListenerType.mainScreen] = endListener;
  }
  void addListenersArena({
    required bool Function() startListener,
    required bool Function() endListener,
  }){
    _starts[DelayerListenerType.arena] = startListener;
    _ends[DelayerListenerType.arena] = endListener;
  }

  void removeArenaListeners(){
    _starts[DelayerListenerType.arena] = null;
    _ends[DelayerListenerType.arena] = null;
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
  final Duration? duration;

  final double height;

  final Color primaryColor;
  final Color onPrimaryColor;
  final Color? accentColor;
  final Color onAccentColor;

  final void Function(AnimationStatus) animationListener;
  final void Function()? onManualCancel;
  final void Function()? onManualConfirm;
  final DelayerController delayerController;

  final String message;
  final TextStyle? style;
  final double circleOffset;
  final bool half;


  const Delayer({
    required this.half,
    required this.animationListener,
    required this.onManualCancel,
    required this.onManualConfirm,
    required this.delayerController,
    required this.circleOffset,
    required this.duration,
    required this.height,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.accentColor,
    required this.onAccentColor,
    required this.message,
    required this.style,
  });

  @override
  State createState() => _DelayerState();
}

class _DelayerState extends State<Delayer> with TickerProviderStateMixin {

  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    initController();

    widget.delayerController.addListenersMain(
      startListener: scrolling,
      endListener: leaving,
    );

  }


  void initController(){
    _disposeController();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    controller!.addStatusListener(widget.animationListener);
  }

  @override
  void didUpdateWidget(Delayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.duration != controller!.duration){
      initController();
    }
  }

  bool scrolling(){
    if(!mounted) return false;
    if(controller!.isAnimating && controller!.velocity > 0) {
      return true;
    }
    if(controller!.value == 1.0) {
      return true;
    }

    controller!.fling();
    return true;
  }

  bool leaving() {
    if(!mounted) return false;
    if(controller!.value == 0.0) {
      return true;
    }

    bool fling = false;
    if(controller!.isAnimating){
      if(controller!.velocity < 0) {
        return true;
      }
      fling = true;
    }
    _leaving(fling);
    return true;
  }

  void _leaving(bool withFling) async {
    if(!mounted) return;
    if(withFling) await  controller!.fling();
    if(!mounted) return;
    controller!.animateBack(0.0);
  }

  void _disposeController(){
    controller?.dispose();
    controller = null;
  }

  @override
  void dispose() {
    _disposeController();
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
            animation: controller!,
            child: _Content(
              half: widget.half,
              message: widget.message,
              style: widget.style,
              color: widget.accentColor,
              contrast: widget.onAccentColor,
              width: width,
              height: widget.height,
            ),
            builder: (BuildContext context, Widget? childA) {
              double s = controller!.value;
              return ClipOval(
                clipper: _CircleClipper(
                  center: offset,
                  radius: s * maxRadius,
                ),
                child: SizedBox(
                  width: width,
                  height: widget.height,
                  child: childA,
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

  final Color? color;
  final Color contrast;

  final String message;
  final TextStyle? style;
  final bool half;

  const _Content({
    required this.half,
    required this.width,
    required this.height,
    required this.color,
    required this.contrast,
    required this.message,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      height: height,
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: height/(half?2:1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: height,
              height: height/(half?2:1),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: contrast,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  message,
                  style: style!.copyWith(color: contrast),
                ),
              ),
            ),
            SizedBox(
              width: height,
              height: height/(half?2:1),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: contrast,
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

  final void Function()? onConfirm;
  final void Function()? onCancel;

  const _ContentTappable({
    required this.half,
    required this.width,
    required this.height,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = (height*2).clamp(0, width/2);
    final buttonHeight = height/(half?2:1); 

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: height/(half?2:1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkResponse(
                onTap: onCancel,
                child: SizedBox(
                  width: buttonWidth as double?,
                  height: buttonHeight,
                ),
              ),
              InkResponse(
                onTap: onConfirm,
                child: SizedBox(
                  width: buttonWidth as double?,
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

  final Offset? center;
  final double? radius;

  @override
  Rect getClip(Size size) {
    var rect = Rect.fromCircle(radius: radius!, center: center!);

    return rect;
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) => oldClipper.radius != radius || oldClipper.center != center;
}
