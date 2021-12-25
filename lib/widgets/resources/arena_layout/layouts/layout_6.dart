import 'package:flutter/material.dart';
import '../arena_layout.dart';
import 'compose.dart';
import 'column_of_two.dart';

class ArenaLayout6 extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final ArenaLayoutType layoutType;
  final bool flipped;
  final Widget? betweenGridAndCenter;

  const ArenaLayout6({
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
        break;
      case ArenaLayoutType.squad:
        return buildSquad(context);
      default:
        return Container();
    }
  }

  bool get intersection => this.centerAlignment 
    == ArenaCenterAlignment.intersection;




  ///=======================================
  ///  FREE FOR ALL
  ///=======================================

  ///    Landscape
  ///    ||============================||
  ///    ||    ||       ||       ||    || a
  ///    ||    ||   1   ||   2   ||    ||
  /// b  ||  0 ||=======()=======|| 3  || +
  ///    ||    ||   5   ||   4   ||    ||
  ///    ||    ||       ||       ||    || a
  ///    ||============================||
  ///        x      y        y      x

  /// pseudo code: Row(0, Column(1,5), Column(2,4), 3)


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
          top: childBuilder(context, 1, Alignment.topLeft), 
          bottom: childBuilder(context, 5, Alignment.topRight),
        ),
      ),
      Expanded(
        flex: 2,
        child: ColumnOfTwo(
          top: childBuilder(context, 2, Alignment.topRight), 
          bottom: childBuilder(context, 4, Alignment.topLeft),
        ),
      ),
      Expanded(
        flex: 1,
        child: RotatedBox(
          quarterTurns: 3,
          child: childBuilder(context, 3, null),
        ),
      ),
    ],);

    Widget? positionedCenterChild;

    if(this.centerChildBuilder != null){
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



  ///======================================
  ///  SQUAD
  ///======================================

  ///    Landscape
  ///          y          y          y  
  ///    ||===============================||
  ///    ||         ||         ||         || a
  ///    ||    0    ||    1    ||    2    ||
  /// b  ||==============( )==============||
  ///    ||    5    ||    4    ||    3    ||
  ///    ||         ||         ||         || a
  ///    ||===============================||
  ///                    x  

  /// pseudo code: Column(Row(2,1,0), Row(5,4,3))


  Widget buildSquad(BuildContext context) {

    final bool landscape = constraints.maxWidth >= constraints.maxHeight;

    /// See figure above
    /// Build assuming landscape (rotated if not landscape)

    final int gridQuarterTurns = (flipped ? 2 : 0) + (landscape ? 0 : 1);

    final Widget grid = ColumnOfTwo(
      top: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 2, null)),
        Expanded(child: childBuilder(context, 1, Alignment.topCenter)),
        Expanded(child: childBuilder(context, 0, null)),
      ],),
      bottom: Row(children: <Widget>[
        Expanded(child: childBuilder(context, 5, null)),
        Expanded(child: childBuilder(context, 4, Alignment.topCenter)),
        Expanded(child: childBuilder(context, 3, null)),
      ],),
    );

    Widget? positionedCenterChild;

    if(this.centerChildBuilder != null){
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

}