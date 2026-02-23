import 'dart:math';

import 'package:flutter/material.dart';

import '../arena_layout.dart';
import 'column_of_two.dart';
import 'compose.dart';

class ArenaLayout3 extends StatelessWidget {
  final ArenaChildBuilder childBuilder;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final ArenaLayoutType layoutType;
  final bool flipped;
  final bool animateCenterWidget;
  final Widget? betweenGridAndCenter;

  const ArenaLayout3({super.key, 
    required this.betweenGridAndCenter,
    required this.layoutType,
    required this.childBuilder,
    required this.flipped,
    required this.constraints,
    required this.centerChildBuilder,
    required this.centerAlignment,
    required this.animateCenterWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (layoutType) {
      case ArenaLayoutType.ffa:
        return buildFFA(context);
      case ArenaLayoutType.squad:
        return buildSquad(context);
    }
  }

  bool get intersection => centerAlignment == ArenaCenterAlignment.intersection;

  ///==============================================
  ///   FREE FOR ALLL
  ///=============================================

  ///    Landscape
  ///    ||==============================||
  ///    ||        ||                    || a
  ///    ||        ||         1          ||
  /// b  ||    0   ()====================||
  ///    ||        ||         2          ||
  ///    ||        ||                    || a
  ///    ||==============================||
  ///          x              y

  /// pseudo code: Row(0, Column(1,2))

  Widget buildFFA(BuildContext context) {
    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)
    /// b = smallerSide
    /// x + y = biggerSide
    /// x * b = y * a  //(same surface for each tile)
    /// b = 2a
    /// -> x * 2a = y * a
    /// ===>  xFlex = 1  //  yFlex = 2

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    final Widget grid = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RotatedBox(
            quarterTurns: 1,
            child: childBuilder(context, 0, Alignment.topCenter),
          ),
        ),
        Expanded(
          flex: 2,
          child: ColumnOfTwo(
            top: childBuilder(context, 1, Alignment.topRight),
            bottom: childBuilder(context, 2, Alignment.topLeft),
          ),
        ),
      ],
    );

    Widget? positionedCenterChild;

    if (centerChildBuilder != null) {
      final bool portrait = !landscape;
      final bool normal = !flipped;

      /// landscape
      ///  - normal -> padding on the right (0 quarterTurns)
      ///  - flipped -> padding on the left (2 quarterTurns)
      /// portrait
      ///  - normal -> padding on the bottom (1 quarterTurns)
      ///  - flipped -> padding on the top (3 quarterTurns)

      /// bottom: portrait & normal
      /// top: portrait & flipped
      /// right: landscape & normal
      /// left: landscape & flipped

      final double bigger = max(
        constraints.maxWidth,
        constraints.maxHeight,
      );
      final double centerPadding = intersection ? bigger / 3 : 0.0;

      if (animateCenterWidget) {
        positionedCenterChild = AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: landscape & normal ? centerPadding : 0.0,
          left: landscape & flipped ? centerPadding : 0.0,
          bottom: portrait & normal ? centerPadding : 0.0,
          top: portrait & flipped ? centerPadding : 0.0,
          child: Center(
            child: centerChildBuilder!(
                context, landscape ? Axis.vertical : Axis.horizontal),
          ),
        );
      } else {
        positionedCenterChild = Positioned(
          right: landscape & normal ? centerPadding : 0.0,
          left: landscape & flipped ? centerPadding : 0.0,
          bottom: portrait & normal ? centerPadding : 0.0,
          top: portrait & flipped ? centerPadding : 0.0,
          child: Center(
            child: centerChildBuilder!(
                context, landscape ? Axis.vertical : Axis.horizontal),
          ),
        );
      }
    }

    return ComposeArenaLayout(
      grid: grid,
      gridQuarterTurns: gridQuarterTurns,
      positionedCenterChild: positionedCenterChild,
      betweenGridAndCenter: betweenGridAndCenter,
    );
  }

  ///=======================================
  ///  SQUAD
  ///=======================================

  ///    Landscape
  ///            y               y
  ///    ||==============================||
  ///    ||             ||               || a
  ///    ||      0      ||       1       ||
  /// b  ||=============()===============||
  ///    ||             02               ||
  ///    ||                              || a
  ///    ||==============================||
  ///                    x

  /// pseudo code: Column(Row(1,0), 2)

  Widget buildSquad(BuildContext context) {
    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    final Widget grid = ColumnOfTwo(
      top: Row(
        children: <Widget>[
          Expanded(child: childBuilder(context, 1, Alignment.topRight)),
          Expanded(child: childBuilder(context, 0, Alignment.topLeft)),
        ],
      ),
      bottom: childBuilder(context, 2, Alignment.topCenter),
    );

    Widget? positionedCenterChild;

    if (centerChildBuilder != null) {
      /// No padding, intersection always at center
      if (animateCenterWidget) {
        /// Still putting in the animation because the tree has to be the same
        /// wether the layout type gets changed in another one or not
        /// so the state of the child can be preserved
        positionedCenterChild = AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 0.0,
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: centerChildBuilder!(
              context,
              landscape ? Axis.horizontal : Axis.vertical,
            ),
          ),
        );
      } else {
        positionedCenterChild = Positioned.fill(
          child: Center(
            child: centerChildBuilder!(
              context,
              landscape ? Axis.horizontal : Axis.vertical,
            ),
          ),
        );
      }
    }

    return ComposeArenaLayout(
      grid: grid,
      gridQuarterTurns: gridQuarterTurns,
      positionedCenterChild: positionedCenterChild,
      betweenGridAndCenter: betweenGridAndCenter,
    );
  }
}
