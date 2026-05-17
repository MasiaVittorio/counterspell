import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MoreToCloseIcon extends ImplicitlyAnimatedWidget {
  const MoreToCloseIcon({
    super.key,
    required this.open,
    this.size,
    this.color,
    super.curve = Easings.emphasized,
    super.duration = Durations.long2,
  });

  final bool open;

  final double? size;
  final Color? color;

  @override
  AnimatedWidgetBaseState<MoreToCloseIcon> createState() =>
      _MoreToCloseIconState();
}

class _MoreToCloseIconState extends AnimatedWidgetBaseState<MoreToCloseIcon> {
  Tween<double>? _open;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _open =
        visitor(
              _open,
              widget.open ? 1.0 : 0.0,
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
        painter: _MoreToCloseIconPainter(
          value: _open!.evaluate(animation),
          color:
              widget.color ??
              iconTheme.color ??
              context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _MoreToCloseIconPainter extends CustomPainter {
  final double value;
  final Color color;

  _MoreToCloseIconPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double side = math.min(size.width, size.height);

    final m = side / 24;

    final c = Offset(side / 2, side / 2);
    final deltaC = Offset(value.rangeMap(to: (6, 0)), 0) * m;
    final c1 = c - deltaC;
    final c2 = c + deltaC;

    final h = 2 * m * value.rangeMap(to: (2, 1));
    final Radius r = Radius.circular(h / 2);
    final w = value.rangeMap(to: (h, 20 * m));

    final a = value.rangeMap(to: (0, math.pi / 4));

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

    drawRRect(Rect.fromCenter(center: c1, width: w, height: h), a);

    drawRRect(Rect.fromCenter(center: c2, width: w, height: h), -a);

    canvas.drawCircle(c, value.rangeMap(to: (h / 2, h / 4)), paint);
  }

  @override
  bool shouldRepaint(covariant _MoreToCloseIconPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
