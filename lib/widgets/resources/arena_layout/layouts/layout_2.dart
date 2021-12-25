import 'package:flutter/material.dart';
import '../arena_layout.dart';
import 'column_of_two.dart';
import 'compose.dart';

class ArenaLayout2 extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final bool flipped;
  final Widget? betweenGridAndCenter;

  const ArenaLayout2({
    required this.childBuilder,
    required this.constraints,
    required this.centerChildBuilder,
    required this.centerAlignment,
    required this.flipped,
    required this.betweenGridAndCenter,
  });
  
  /// Landscape
  /// ||================================||
  /// ||                                ||
  /// ||               vv               ||
  /// ||===============()===============||
  /// ||               ^^               ||
  /// ||                                ||
  /// ||================================||

  /// Portrait
  /// ||==============||
  /// ||              ||
  /// ||              ||
  /// ||      vv      ||
  /// ||              ||
  /// ||======()======||
  /// ||              ||
  /// ||      ^^      ||
  /// ||              ||
  /// ||              ||
  /// ||==============||

  /// Built the same, just a column with two accordingly rotated boxes

  @override
  Widget build(BuildContext context) {
    return ComposeArenaLayout(
      gridQuarterTurns: flipped ? 2 : 0,
      grid: ColumnOfTwo(
        top: childBuilder(context, 0, Alignment.topCenter), 
        bottom: childBuilder(context, 1, Alignment.topCenter),
      ), 
      positionedCenterChild: centerChildBuilder == null 
        ? null 
        : Positioned.fill(child: Center(
          child: centerChildBuilder!(
            context,
            Axis.horizontal,
          ),
        ),),
      betweenGridAndCenter: betweenGridAndCenter,
    );
  }
}


