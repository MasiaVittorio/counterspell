import 'package:flutter/material.dart';
import 'dart:math' as math;

class CSConstants {
  static const double barSize = kBottomNavigationBarHeight;
  static const double minTileSize = 75.0;

  static double computeTileSize(BoxConstraints constraints, double coreTileSize, int length)
    => math.max(
      constraints.maxHeight / length,
      coreTileSize,
    );
}