import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sid_utils/sid_utils.dart';

class HighlightPainter extends CustomPainter {
  const HighlightPainter({
    required this.color,
    required this.fraction,
    required this.radius,
    required this.width,
  });

  final Color color;
  final double fraction;
  final double radius;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    if (fraction == 0 || color.a == 0) return;

    final radius = min(this.radius, min(h, w) / 2);
    // final tl = Offset(radius, 0);
    // final tr = Offset(w - radius, 0);
    // final rt = Offset(w, radius);
    // final rb = Offset(w, h - radius);
    // final br = Offset(w - radius, h);
    // final bl = Offset(radius, h);
    // final lb = Offset(0, h - radius);
    // final lt = Offset(0, radius);

    // final clock = {
    //   _Corner.topLeft: [lt,tl],
    //   _Corner.topRight: [tr,rt],
    //   _Corner.bottomRight: [rb,br],
    //   _Corner.bottomLeft: [bl,lb],
    // };

    // final anti = {
    //   _Corner.topLeft: [tl,lt],
    //   _Corner.topRight: [rt,tr],
    //   _Corner.bottomRight: [br,rb],
    //   _Corner.bottomLeft: [lb,lb],
    // };

    final centers = {
      _Corner.topLeft: Offset(radius, radius),
      _Corner.topRight: Offset(w - radius, radius),
      _Corner.bottomRight: Offset(w - radius, h - radius),
      _Corner.bottomLeft: Offset(radius, h - radius),
    };

    final ovals = {
      for (final c in _Corner.values)
        c: Rect.fromCenter(
          center: centers[c]!,
          width: radius * 2,
          height: radius * 2,
        ),
    };

    final clockStart = <_Corner, double>{
      _Corner.topLeft: pi,
      _Corner.topRight: -pi / 2,
      _Corner.bottomRight: 0,
      _Corner.bottomLeft: pi / 2,
    };
    final antiClockStart = <_Corner, double>{
      _Corner.topLeft: -pi / 2,
      _Corner.topRight: 0,
      _Corner.bottomRight: pi / 2,
      _Corner.bottomLeft: pi,
    };

    final cornerLenght = radius * pi / 2;
    final horizontalLenght = w - radius * 2;
    final verticalLenght = h - radius * 2;
    final lenght = horizontalLenght * 2 + verticalLenght * 2 + cornerLenght * 4;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;

    final path = Path();

    void side(bool clockwise, Path p, _Side s, double len) {
      switch (s) {
        case _Side.top:
          p.relativeLineTo(clockwise ? len : -len, 0);
          break;
        case _Side.right:
          p.relativeLineTo(0, clockwise ? len : -len);
          break;
        case _Side.bottom:
          p.relativeLineTo(clockwise ? -len : len, 0);
          break;
        case _Side.left:
          p.relativeLineTo(0, clockwise ? -len : len);
          break;
      }
    }

    void corner(bool clockwise, Path p, _Corner c, double sweep) {
      p.addArc(
        ovals[c]!,
        clockwise ? clockStart[c]! : antiClockStart[c]!,
        clockwise ? sweep : -sweep,
      );
    }

    final bool firstHalf = fraction < 0.5;
    final bool clockWise = !firstHalf;

    final double frac = firstHalf
        ? fraction * 2
        : fraction.mapToRange(1, 0, fromMin: 0.5, fromMax: 1);
    final double end = lenght * frac;

    double l = 0.0;

    late List list;
    if (firstHalf) {
      path.moveTo(radius, 0);
      list = [
        if (radius > 0) _Corner.topLeft,
        _Side.left,
        if (radius > 0) _Corner.bottomLeft,
        _Side.bottom,
        if (radius > 0) _Corner.bottomRight,
        _Side.right,
        if (radius > 0) _Corner.topRight,
        _Side.top,
      ];
    } else {
      path.moveTo(w - radius, h);
      list = [
        if (radius > 0) _Corner.bottomRight,
        _Side.bottom,
        if (radius > 0) _Corner.bottomLeft,
        _Side.left,
        if (radius > 0) _Corner.topLeft,
        _Side.top,
        if (radius > 0) _Corner.topRight,
        _Side.right,
      ];
    }
    for (final e in list) {
      double remaining = end - l;
      late double thisLenght;
      if (e is _Corner) {
        thisLenght = min(remaining, cornerLenght);
        corner(
          clockWise,
          path,
          e,
          thisLenght.mapToRange(
            0,
            pi / 2,
            fromMin: 0,
            fromMax: cornerLenght,
          ),
        );
      } else if (e is _Side) {
        thisLenght = min(
          remaining,
          e.isHorizontal ? horizontalLenght : verticalLenght,
        );
        side(
          clockWise,
          path,
          e,
          thisLenght,
        );
      } else {
        // should not happen
        thisLenght = 0;
      }
      l += thisLenght;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HighlightPainter oldDelegate) => false;
}

enum _Corner {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
}

enum _Side {
  top,
  right,
  bottom,
  left;

  bool get isHorizontal => this == top || this == bottom;
}
