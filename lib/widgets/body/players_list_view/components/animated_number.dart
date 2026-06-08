import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedNumber extends StatefulWidget {
  const AnimatedNumber({
    super.key,
    required this.value,
    required this.delta,
    required this.size,
    required this.duration,
    required this.curve,
    required this.textColor,
  });

  final int value;
  final int delta;
  final double size;
  final Duration duration;
  final Curve curve;
  final Color? textColor;

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber> {
  late int oldValue;

  @override
  void initState() {
    super.initState();
    oldValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      oldValue = oldWidget.value;
    } else if (oldWidget.delta != 0 && widget.delta == 0) {
      oldValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericAnimatedBuilder(
      value: widget.delta != 0 ? 1 : 0,
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, expansion, child) {
        final bool isContracting =
            widget.delta == 0 && expansion > 0 && oldValue != widget.value;

        return GenericAnimatedBuilder(
          value: widget.value.toDouble(),
          duration: widget.duration,
          curve: widget.curve,
          builder: (context, animatedValue, child) {
            final bool isSwitching =
                animatedValue != widget.value &&
                widget.delta == 0 &&
                oldValue != widget.value;
            final int value = switch (isSwitching || isContracting) {
              true => oldValue,
              false => widget.value,
            };
            final int result = isSwitching || isContracting
                ? widget.value
                : widget.value + widget.delta;
            return _RenderAnimatedNumber(
              alignment: switch ((isSwitching, isContracting)) {
                (true, _) => Alignment(
                  animatedValue.rangeMap(
                    from: (oldValue, widget.value),
                    to: (-1, 1),
                  ),
                  0,
                ),
                (false, true) => Alignment.centerRight,
                (false, false) => Alignment.centerLeft,
              },
              value: value,
              result: result,
              delta: result - value,
              expansion: expansion,
              size: widget.size,
              textColor: widget.textColor,
            );
          },
        );
      },
    );
  }
}

class _RenderAnimatedNumber extends StatelessWidget {
  const _RenderAnimatedNumber({
    required this.alignment,
    required this.value,
    required this.result,
    required this.delta,
    required this.expansion,
    required this.size,
    required this.textColor,
  });

  final Alignment alignment;
  final int value;
  final int result;
  final int delta;
  final double size;
  final double expansion;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final style = theme.textTheme.titleLarge!.copyWith(color: textColor);

    return Align(
      alignment: alignment,
      widthFactor: expansion.rangeMap(to: (1 / 3, 1)),
      child: Stack(
        children: [
          SizedBox(
            height: size,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox.square(
                  dimension: size,
                  child: Center(
                    child: Text(
                      value.toString(),
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                ),
                Space.horizontal(size),
                SizedBox.square(
                  dimension: size,
                  child: Center(
                    child: Text(
                      result.toString(),
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                delta >= 0 ? '+ $delta =' : '- ${-delta} =',
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
