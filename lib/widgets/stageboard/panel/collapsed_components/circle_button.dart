import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';
import 'dart:math' as math;

class CircleButton extends StatefulWidget {

  final double size;
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final double sizeIncrement;
  final int externalCircles;
  final bool regularSteps;

  const CircleButton({
    this.size = _CircleButtonState.defaultSize,
    @required this.child,
    @required this.onTap,
    @required this.color,
    this.regularSteps = false,
    this.sizeIncrement = _CircleButtonState.defaultSizeIncrement,
    this.externalCircles = _CircleButtonState.defaultCircles,
  });

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {

  static const double defaultSizeIncrement = 0.50;
  static const double defaultSize = 56.0;
  static const int defaultCircles = 2;

  bool pressed = false;

  @override
  Widget build(BuildContext context) {

    final double increment = this.widget.sizeIncrement 
      ?? defaultSizeIncrement;
    final int n = this.widget.externalCircles ?? defaultCircles;
    final double size = this.widget.size ?? defaultSize;
    final Color color = this.widget.color 
        ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
    // final double op = color.opacity;
    final bool regular = widget.regularSteps ?? false;

    final double ms = getMaxSize(size, n, increment, regular);
    final double offset = 0 - ((ms - size) / 2);

    final Widget child = GestureDetector(
      onTapDown: (_) => tapDown(),
      onTapUp: (_) => tapUp(),
      onTapCancel: tapUp,
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent,
        child: widget.child,
        alignment: Alignment.center,
        width: size,
        height: size,
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          for(int i = n; i >= 0; --i)
          (){
            final double _s = getSize(size, i, increment, regular);
            final double s = getPressedSize(_s, i, regular, this.pressed);
            return Positioned(
              left: offset,
              top: offset,
              width: ms,
              height: ms,
              child: Center(child: AnimatedContainer(
                alignment: Alignment.center,
                duration: Duration(
                  milliseconds: getMilliseconds(i, n),
                ),
                curve: Curves.easeOutBack,
                width: s,
                height: s,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ms),
                  color: color,
                ),
                child: i == 0 ? child : null,
              ),),
            );

          }()
        ],
      ),
    );
  }

  static int getMilliseconds(int i, int n) => (1.0 * i).mapToRangeLoose(
    100, 800,
    fromMin: 0.0, fromMax: n,
  ).round();

  static double getMaxSize(double size, int n, double inc, bool reg) 
    => getPressedSize(
      getSize(size, n, inc, reg), 
      n, 
      reg, 
      true,
    );

  static double getSize(double size, int i, double inc, bool reg) => reg 
    ? size * (1.0 + i * inc)
    : size * math.pow(1.0 + inc, i) ;

  static double getPressedSize(double s, int i, bool reg, bool pressed) 
    => getSize(s, i, pressed ? 0.25 : 0.0, reg);

  // double mappedOpacity(double original, int i, int n, regular) => (1.0 * i).mapToRangeLoose(
  //   0.2 * original, original,
  //   fromMin: n,
  //   fromMax: 0.0,
  // );

  double closerTo1(double v, double fr) => v + (1-v)*fr;

  void tapDown() => this.setState(() {
    pressed = true;
  });

  void tapUp() => this.setState(() {
    pressed = false;
  });
}