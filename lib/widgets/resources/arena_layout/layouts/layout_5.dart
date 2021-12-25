import 'dart:math';

import 'package:flutter/material.dart';
import '../arena_layout.dart';
import 'compose.dart';
import 'column_of_two.dart';

class ArenaLayout5 extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final ArenaLayoutType layoutType;
  final bool flipped;
  final bool animateCenterWidget;
  final Widget? betweenGridAndCenter;

  const ArenaLayout5({
    required this.betweenGridAndCenter,
    required this.flipped,
    required this.layoutType,
    required this.childBuilder,
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
      default:
        return Container();
    }
  }

  bool get intersection => this.centerAlignment 
    == ArenaCenterAlignment.intersection;


  ///======================================
  ///  FREE FOR ALL
  ///======================================


  ///    Landscape
  ///    ||==============================||
  ///    ||      ||          ||          || a
  ///    ||      ||    01    ||    02    ||
  /// b  ||  00  ||==========()==========||
  ///    ||      ||    04    ||    03    ||
  ///    ||      ||          ||          || a
  ///    ||==============================||
  ///         x         y            y        

  /// pseudo code: Row(0, Column(1,4), Column(2,3)))


  Widget buildFFA(BuildContext context) {

    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)
    /// b = smallerSide
    /// x + 2y = biggerSide
    /// b = 2a
    /// x * b = y * a  // (same surface for each tile)
    /// -> x * 2a = y * a 
    /// ===>  xFlex = 1  //  yFlex = 2

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    final Widget grid = Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: RotatedBox(
          quarterTurns: 1,
          child: childBuilder(context, 0, null),
        ),
      ),
      Expanded(
        flex: 2,
        child: ColumnOfTwo(
          top: childBuilder(context, 1, Alignment.topLeft), 
          bottom: childBuilder(context, 4, Alignment.topRight),
        ),
      ),
      Expanded(
        flex: 2,
        child: ColumnOfTwo(
          top: childBuilder(context, 2, Alignment.topRight), 
          bottom: childBuilder(context, 3, Alignment.topLeft),
        ),
      ),
    ],);



    Widget? positionedCenterChild;

    if(this.centerChildBuilder != null){

      final bool portrait = !landscape;
      final bool normal = !flipped;

      /// landscape
      ///  - normal -> padding on the left (0 quarterTurns)
      ///  - flipped -> padding on the right (2 quarterTurns)
      /// portrait
      ///  - normal -> padding on the top (1 quarterTurns)
      ///  - flipped -> padding on the bottom (3 quarterTurns)

      /// top: portrait & normal
      /// bottom: portrait & flipped
      /// left: landscape & normal
      /// right: landscape & flipped

      final double bigger = max(
        constraints.maxWidth, 
        constraints.maxHeight,
      );

      /// See figure above:
      /// -> centerChild is centered in a region wide 2y
      /// -> y is biggerSide * 2 / 5
      /// ====> padding = biggerSide / 5 

      final double centerPadding = intersection 
        ? bigger / 5
        : 0.0;
      
      if(animateCenterWidget){
        positionedCenterChild = AnimatedPositioned(
          duration: const Duration(milliseconds: 300),

          left: landscape & normal ? centerPadding : 0.0,
          right: landscape & flipped ? centerPadding : 0.0,
          top: portrait & normal ? centerPadding : 0.0,
          bottom: portrait & flipped ? centerPadding : 0.0,

          child: Center(child: centerChildBuilder!(
            context,
            landscape ? Axis.horizontal : Axis.vertical,
          ),),
        );
      } else {
        positionedCenterChild = Positioned(
          left: landscape & normal ? centerPadding : 0.0,
          right: landscape & flipped ? centerPadding : 0.0,
          top: portrait & normal ? centerPadding : 0.0,
          bottom: portrait & flipped ? centerPadding : 0.0,

          child: Center(child: centerChildBuilder!(
            context,
            landscape ? Axis.horizontal : Axis.vertical,
          ),),
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



  ///====================================
  ///  SQUAD
  ///====================================

  ///    Landscape
  ///          y         y          y
  ///    ||===============================||
  ///    ||         ||        ||          ||a
  ///    ||    0    ||   01   ||    2     ||
  /// b  ||==============()===============||
  ///    ||      4       ||       3       ||
  ///    ||              ||               || a
  ///    ||===============================||
  ///                    x  

  /// pseudo code: Column(Row(2,1,0), Row(4,3))


  Widget buildSquad(BuildContext context) {

    final Widget grid = ColumnOfTwo(
      top: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 2, null)),
        Expanded(child: childBuilder(context, 1, Alignment.topCenter)),
        Expanded(child: childBuilder(context, 0, null)),
      ],),
      bottom: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 4, Alignment.topRight)),
        Expanded(child: childBuilder(context, 3, Alignment.topLeft)),
      ],),
    );

    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    Widget? positionedCenterChild;

    if(this.centerChildBuilder != null){
      /// No padding, intersection always at center

      if(animateCenterWidget){
        positionedCenterChild = AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 0.0,
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(child: centerChildBuilder!(
            context,
            landscape ? Axis.horizontal : Axis.vertical,
          ),),
        );
      } else {
        positionedCenterChild = Positioned.fill(
          child: Center(child: centerChildBuilder!(
            context,
            landscape ? Axis.horizontal : Axis.vertical,
          ),),
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
