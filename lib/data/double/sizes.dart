import 'package:flutter/material.dart';
import 'dart:math' as math;

class CSSizes {
  static const double barSize = kBottomNavigationBarHeight;
  static const double minTileSize = 75.0;

  static double computeTileSize(
    BoxConstraints constraints, 
    double coreTileSize, 
    int length, 
    double padding,
  ) => math.max(
    (constraints.maxHeight
      - ((length + 1) * padding)
    ) / length,
    coreTileSize,
  );
}