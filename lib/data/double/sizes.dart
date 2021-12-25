import 'dart:math' as math;
import 'package:counter_spell_new/core.dart';

class CSSizes {
  static const double barSize = kBottomNavigationBarHeight;
  static const double minTileSize = 75.0;
  static const double collapsedPanelSize = StageDimensions.defaultBarSize;
  static const double bottomBodyPadding = collapsedPanelSize/2;

  static double computeTileSize(
    BoxConstraints fullConstraints, 
    int rowCount, 
    bool flat,
  ) => math.max(
    ((fullConstraints.maxHeight - bottomBodyPadding)
      - ((rowCount - 1) + (firstFlatPadding ? 1 : 0)) * (flat ? flatPadding : 0)
    ) / rowCount,
    minTileSize,
  );

  static double computeTotalSize(
    double tileSize,
    int rowCount,
    bool flat,
  ) => tileSize * rowCount 
    + (flat ? flatPadding : 0) * (
      (rowCount - 1) + (firstFlatPadding ? 1 : 0)
    )+ bottomBodyPadding;

  static List<Widget> separateColumn(bool flat, List<Widget> children) => flat 
    ? children.separateWith(
      flatPaddingY, 
      alsoLast: lastFlatPadding,
      alsoFirst: firstFlatPadding,  
    ) 
    : children;

  static const lastFlatPadding = true;
  static const firstFlatPadding = false;
  // static const firstFlatPadding = true;

  static const double flatPadding = 12.0;
  static const Widget flatPaddingY = const SizedBox(height: flatPadding);
  static const Widget flatPaddingX = const SizedBox(width: flatPadding);

}