import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaMenuButton extends ImplicitlyAnimatedWidget {
  const ArenaMenuButton({
    super.key,
    required this.open,
    required this.onChanged,
    required this.onUndo,
    required this.onRedo,
    required this.direction,
    super.curve = Easings.emphasized,
    super.duration = Durations.long2,
  });

  final bool open;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final Axis direction;

  @override
  AnimatedWidgetBaseState<ArenaMenuButton> createState() =>
      _DivisionAnimateState();
}

class _DivisionAnimateState extends AnimatedWidgetBaseState<ArenaMenuButton> {
  Tween<double>? _presented;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _presented =
        visitor(
              _presented,
              widget.open ? 0.0 : 1.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final double val = _presented!.evaluate(animation);
    final double fastZeroVal = Curves.easeIn.transform(val);

    final double colorVal = fastZeroVal.rangeMap(from: (0.4, 1));
    final double size = 52 * val;
    final double fastSize = 52 * fastZeroVal.rangeMap(from: (0.3, 1));

    final double opacity = Curves.easeIn.transform(
      val.rangeMap(from: (0.6, 1)),
    );
    final double fasterOpacity = Curves.easeIn.transform(
      val.rangeMap(from: (0.8, 1)),
    );

    final theme = context.theme;
    final layout = theme.layout;

    final borderRadius = BorderRadius.circular(
      fastZeroVal.rangeMap(to: (layout.radius.small * size / 52, size / 2)),
    );
    final iconsSize = val.rangeMap(to: (18, 24), from: (0.8, 1));

    final inactiveColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.38,
    );

    final bool horizontal = widget.direction == Axis.horizontal;

    final backgroundOpacity = val.rangeMap(from: (0.1, 0.4));

    return IgnorePointer(
      ignoring: widget.open,
      child: Container(
        height: horizontal ? size : null,
        width: horizontal ? null : size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Color.lerp(
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainer,
            colorVal,
          )!.withValues(alpha: backgroundOpacity),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Flex(
            direction: widget.direction,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkResponse(
                containedInkWell: false,
                onTap: widget.onUndo,
                child: SizedBox(
                  height: horizontal ? size : fastSize,
                  width: horizontal ? fastSize : size,
                  child: Center(
                    child: Opacity(
                      opacity: fasterOpacity,
                      child: RotatedBox(
                        quarterTurns: horizontal ? 0 : 1,
                        child: Icon(
                          Icons.undo,
                          color: widget.onUndo == null ? inactiveColor : null,
                          size: iconsSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: size,
                width: size,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Color.lerp(
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHigh,
                    colorVal,
                  )!.withValues(alpha: backgroundOpacity),
                ),
                child: Opacity(
                  opacity: opacity,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () => widget.onChanged(!widget.open),
                      child: RotatedBox(
                        quarterTurns: horizontal ? 0 : 1,
                        child: Icon(Icons.menu, size: iconsSize),
                      ),
                    ),
                  ),
                ),
              ),
              InkResponse(
                containedInkWell: false,
                onTap: widget.onRedo,
                child: SizedBox(
                  height: horizontal ? size : fastSize,
                  width: horizontal ? fastSize : size,
                  child: Center(
                    child: Opacity(
                      opacity: fasterOpacity,
                      child: RotatedBox(
                        quarterTurns: horizontal ? 0 : 1,
                        child: Icon(
                          Icons.redo,
                          color: widget.onRedo == null ? inactiveColor : null,
                          size: iconsSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
