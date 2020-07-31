import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';

class CircleButton extends StatefulWidget {

  final double size;
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final double sizeIncrement;
  final int externalCircles;

  const CircleButton({
    this.size = _CircleButtonState.defaultSize,
    @required this.child,
    @required this.onTap,
    @required this.color,
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
    final double op = color.opacity;

    final double ms = getMaxSize(size,n,increment);
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
        overflow: Overflow.visible,
        children: <Widget>[
          for(int i = n; i >= 0; --i)
          (){
            final double s = getSize(size, i, increment);
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
                  borderRadius: BorderRadius.circular(100),
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

  int getMilliseconds(int i, int n) => (1.0 * i).mapToRangeLoose(
    300, 600,
    fromMin: 0.0, fromMax: n,
  ).round();

  double getMaxSize(double size, int n, double increment) 
    => size * (1 + n * increment);
  double getSize(double size, int i, double increment) => size * closerTo1(
    1 + i * increment,
    pressed ? 0.5 : 0.0,
  );

  double mappedOpacity(double original, int i, int n) => (1.0 * i).mapToRangeLoose(
    0.25 * original, original,
    fromMin: n,
    fromMax: 0.0,
  );

  double closerTo1(double v, double fr) => v + (1-v)*fr;

  void tapDown() => this.setState(() {
    pressed = true;
  });

  void tapUp() => this.setState(() {
    pressed = false;
  });
}