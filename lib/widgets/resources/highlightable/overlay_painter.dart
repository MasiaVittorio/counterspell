import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';

enum OverlayShapeType {
  circle,
  rrect,
}

class OverlayShape {

  final OverlayShapeType type;
  final Radius radius;
  final bool circleRadiusFromCorners;
  final double padding;

  const OverlayShape({
    this.radius = Radius.zero,
    required this.type,
    this.circleRadiusFromCorners = false,
    this.padding = 0,
  });

  double calcCircleRadius(Size size){
    final w = size.width;
    final h = size.height;
    return (circleRadiusFromCorners
      ? sqrt(w*w/4 + h*h/4)
      : max(w, h) / 2)
        + padding;
  }

}


class OverlayPainter extends CustomPainter {

  OverlayPainter({
    required this.shape,
    required this.fraction,
    required this.color,
    required this.center,
    required this.circleRadius,
    required this.childSize,
  });

  final OverlayShape shape;
  final double fraction;
  
  final Color color;

  final Offset center;

  // circle
  final double circleRadius;

  // rrect
  final Size childSize;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    late final Path difference;

    switch (shape.type) {
      case OverlayShapeType.rrect:
        final top = center.dy;
        final bottom = h - center.dy;
        final left = center.dx;
        final right = w - center.dx;
        final half = max(top, max(bottom, max(left, right)));

        final initialRrect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center, 
            width: half * 2, 
            height: half * 2,
          ), 
          Radius.zero,
        );

        final finalRrect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center, 
            width: childSize.width, 
            height: childSize.height,
          ), 
          shape.radius,
        );
        
        difference = Path()
          ..addRRect(RRect.lerp(
            finalRrect, 
            initialRrect, 
            fraction,
          )!);
        break;

      case OverlayShapeType.circle:
        final tl = (center - const Offset(0,0)).distance;
        final tr = (center - Offset(0,w)).distance;
        final br = (center - Offset(h,w)).distance;
        final bl = (center - Offset(h,0)).distance;
        final maxR = max(bl, max(br, max(tl, tr)));
        final d = 2 * fraction.mapToRangeLoose(circleRadius, maxR);

        difference = Path()
          ..addOval(Rect.fromCenter(center: center, width: d, height: d))
          ..close();
        break;
    }

    final paint = Paint()..color = color;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, w, h)),
        difference,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) 
    => oldDelegate.fraction != fraction
    || oldDelegate.color != color;

}