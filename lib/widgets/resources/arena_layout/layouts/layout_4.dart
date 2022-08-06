import 'package:flutter/material.dart';
import '../arena_layout.dart';
import 'compose.dart';
import 'column_of_two.dart';

class ArenaLayout4 extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final ArenaLayoutType layoutType;
  final bool flipped;
  final Widget? betweenGridAndCenter;

  const ArenaLayout4({
    required this.betweenGridAndCenter,
    required this.flipped,
    required this.layoutType,
    required this.childBuilder,
    required this.constraints,
    required this.centerChildBuilder,
    required this.centerAlignment,
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

  bool get intersection => centerAlignment 
    == ArenaCenterAlignment.intersection;

  ///============================================
  ///  FREE FOR ALL
  ///===========================================

  ///    Landscape
  ///    ||=============================||
  ///    ||      ||             ||      || a
  ///    ||      ||      1      ||      ||
  /// b  ||   0  ||=====( )=====||  2   || +
  ///    ||      ||      3      ||      ||
  ///    ||      ||             ||      || a
  ///    ||=============================||
  ///        x           y           x

  /// pseudo code: Row(0, Column(1,3), 2)


  Widget buildFFA(BuildContext context) {

    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)
    /// b = 2a
    /// b * x = a * y (same surface per each tile)
    /// -> 2a * x = a * y
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
          top: childBuilder(context, 1, Alignment.topCenter), 
          bottom: childBuilder(context, 3, Alignment.topCenter),
        ),
      ),
      Expanded(
        flex: 1,
        child: RotatedBox(
          quarterTurns: 3,
          child: childBuilder(context, 2, null),
        ),
      ),
    ],);



    Widget? positionedCenterChild;

    if(centerChildBuilder != null){
      /// No padding, intersection always at center
      positionedCenterChild = Positioned.fill(
        child: Center(child: centerChildBuilder!(
          context,
          landscape ? Axis.horizontal : Axis.vertical,
        ),),
      );
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
  ///    ||      3      ||       2       ||
  ///    ||             ||               || a
  ///    ||==============================||
  ///                    x  

  /// pseudo code: Column(Row(1,0), Row(3,2))


  Widget buildSquad(BuildContext context) {

    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    final Widget grid = ColumnOfTwo(
      top: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 1, Alignment.topRight)),
        Expanded(child: childBuilder(context, 0, Alignment.topLeft)),
      ],),
      bottom: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 3, Alignment.topRight)),
        Expanded(child: childBuilder(context, 2, Alignment.topLeft)),
      ],),
    );

    Widget? positionedCenterChild;

    if(centerChildBuilder != null){
      /// No padding, intersection always at center
      positionedCenterChild = Positioned.fill(
        child: Center(child: centerChildBuilder!(
          context,
          landscape ? Axis.horizontal : Axis.vertical 
        )),
      );
    }

    return ComposeArenaLayout(
      grid: grid, 
      gridQuarterTurns: gridQuarterTurns,
      positionedCenterChild: positionedCenterChild,
      betweenGridAndCenter: betweenGridAndCenter,
    );

  }

}