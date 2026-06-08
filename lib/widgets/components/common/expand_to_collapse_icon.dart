import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExpandToCollapseIcon extends ImplicitlyAnimatedWidget {
  const ExpandToCollapseIcon({
    super.key,
    required this.expanded,
    this.size,
    this.color,
    super.curve = Easings.emphasized,
    super.duration = Durations.long2,
  });

  final bool expanded;

  final double? size;
  final Color? color;

  @override
  AnimatedWidgetBaseState<ExpandToCollapseIcon> createState() =>
      _ExpandToCollapseState();
}

class _ExpandToCollapseState
    extends AnimatedWidgetBaseState<ExpandToCollapseIcon> {
  Tween<double>? _expanded;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _expanded =
        visitor(
              _expanded,
              widget.expanded ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value),
            )
            as Tween<double>;
  }

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    return SizedBox.square(
      dimension: widget.size ?? iconTheme.size ?? 24,
      child: CustomPaint(
        painter: _ExpandToCollapseIconPainter(
          value: _expanded!.evaluate(animation),
          color:
              widget.color ??
              iconTheme.color ??
              context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _ExpandToCollapseIconPainter extends CustomPainter {
  final double value;
  final Color color;

  _ExpandToCollapseIconPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double side = math.min(size.width, size.height);

    final m = side / 24;

    final w = value.rangeMap(to: (12, 8)) * m;
    final h = value.rangeMap(to: (2.5, 2)) * m * m;

    final Radius r = Radius.circular(h / 2);

    final deltaC = Offset((w - h) / (2 * math.sqrt2), 0);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    void drawRRect(Rect rect, double angle) {
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: rect.width,
          height: rect.height,
        ),
        r,
      );
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(angle);
      canvas.drawRRect(rrect, paint);
      canvas.restore();
    }

    const dy = 5;

    final cTop = Offset(side / 2, side / 2 + value.rangeMap(to: (0, -dy * m)));
    final c1Top = cTop - deltaC;
    final c2Top = cTop + deltaC;

    const aTop = math.pi / 4;

    drawRRect(Rect.fromCenter(center: c1Top, width: w, height: h), aTop);

    drawRRect(Rect.fromCenter(center: c2Top, width: w, height: h), -aTop);

    final c = Offset(side / 2, side / 2 + value.rangeMap(to: (0, dy * m)));
    final c1 = c - deltaC;
    final c2 = c + deltaC;

    final wBottom = value.rangeMap(to: (0, 8 * m));

    final a = value.rangeMap(to: (math.pi / 4, -math.pi / 4));

    drawRRect(Rect.fromCenter(center: c1, width: wBottom, height: h), a);

    drawRRect(Rect.fromCenter(center: c2, width: wBottom, height: h), -a);

    // canvas.drawCircle(c, value.rangeMap(to: (h / 2, h / 4)), paint);
  }

  @override
  bool shouldRepaint(covariant _ExpandToCollapseIconPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
