import 'package:flutter/material.dart';

class ColumnOfTwo extends StatelessWidget {

  const ColumnOfTwo({super.key, 
    required this.top,
    required this.bottom,
    this.flexTop = 1,
    this.flexBottom = 1,
  });

  final Widget top;
  final Widget bottom;
  final int flexTop;
  final int flexBottom;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        flex: flexTop,
        child: RotatedBox(
          quarterTurns: 2,
          child: top,
        ),
      ),
      Expanded(
        flex: flexBottom,
        child: bottom,
      ),
    ],);
  }
}