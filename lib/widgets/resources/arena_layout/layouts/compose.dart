import 'package:flutter/material.dart';


class ComposeArenaLayout extends StatelessWidget {
  final Widget grid;
  final Widget? positionedCenterChild;
  final int gridQuarterTurns;
  final Widget? betweenGridAndCenter;

  const ComposeArenaLayout({
    required this.gridQuarterTurns,
    required this.grid,
    required this.positionedCenterChild,
    required this.betweenGridAndCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(child: RotatedBox(
        quarterTurns: gridQuarterTurns,
        child: grid,
      ),),

      if(betweenGridAndCenter != null)
        Positioned.fill(
          child: betweenGridAndCenter!,
        ),

      if(positionedCenterChild != null)
        positionedCenterChild!,
    ],);
  }
}