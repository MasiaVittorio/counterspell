import 'dart:math' as math;
import 'package:counter_spell_new/core.dart';

class CSSizes {

  static const double collapsedButtonOverlayHighlightPadding = 0;
  static const double barSize = kBottomNavigationBarHeight;
  static const double minTileSize = 75.0;
  static const double collapsedPanelSize = StageDimensions.defaultBarSize;
  static const double halfCollapsed = collapsedPanelSize/2;

  static double extraBottomPlayerTile(bool flat) => flat 
    ? lastAvoidCollapsed 
      ? 0 
      : (
          CSSizes.halfCollapsed 
          - (CSSizes.lastFlatPadding ? CSSizes.flatPadding : 0)
        )
    : CSSizes.halfCollapsed;
    
  static int paddingsCount(int rowCount) 
    => (rowCount - 1) 
    + (firstFlatPadding ? 1 : 0) 
    + (lastFlatPadding ? 1 : 0);

  static int paddingsCountBeforeCollapsedPanel(int rowCount) 
    => (rowCount - 1) 
    + (firstFlatPadding ? 1 : 0) 
    + (lastFlatPadding && lastAvoidCollapsed ? 1 : 0);

  static double availableSpace(
    BoxConstraints fullConstraints, 
    int rowCount, 
    bool flat,
  ) => fullConstraints.maxHeight 
    - halfCollapsed
    - (flat ? (paddingsCountBeforeCollapsedPanel(rowCount) * flatPadding) : 0);

  static double computeTileSize(
    BoxConstraints fullConstraints, 
    int rowCount, 
    bool flat,
  ) => math.max(
    availableSpace(fullConstraints, rowCount, flat) / rowCount,
    minTileSize,
  );

  static double computeTotalSize(
    double tileSize,
    int rowCount,
    bool flat,
  ) => tileSize * rowCount 
    + (flat ? flatPadding * paddingsCountBeforeCollapsedPanel(rowCount) : 0)
    + halfCollapsed;

  static List<Widget> separateColumn(bool flat, List<Widget> children) => flat 
    ? children.separateWith(
      flatPaddingY, 
      alsoLast: lastFlatPadding,
      alsoFirst: firstFlatPadding,  
    ) 
    : children;

  static const lastFlatPadding = true;
  static const firstFlatPadding = false;
  static const lastAvoidCollapsed = true;

  static const double flatPadding = 12.0;
  static const Widget flatPaddingY = SizedBox(height: flatPadding);
  static const Widget flatPaddingX = SizedBox(width: flatPadding);

}
