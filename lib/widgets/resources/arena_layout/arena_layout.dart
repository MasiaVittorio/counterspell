import 'package:flutter/material.dart';
import 'layouts/all.dart';
import 'model.dart';
export 'model.dart';

typedef CenterChildBuilder = Widget Function(
  BuildContext context, 
  Axis intersectionAxis
);

typedef ArenaChildBuilder = Widget Function(
  BuildContext, 
  int index, 
  Alignment? intersectionAlignment,
);

class ArenaLayout extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final int howManyChildren;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final Widget? ifNumberNotSupported;
  final ArenaLayoutType layoutType;
  final bool? flipped;
  final bool animateCenterWidget;
  final Widget? betweenGridAndCenter;

  const ArenaLayout({
    required this.layoutType,
    required this.childBuilder,
    required this.howManyChildren,
    this.centerChildBuilder,
    this.centerAlignment = ArenaCenterAlignment.intersection,
    this.betweenGridAndCenter,
    this.ifNumberNotSupported,
    this.flipped = false,
    this.animateCenterWidget = true,
  });
  
  static const Set<int> howManyChildrenOk = <int>{
    2,3,4,5,6,
  };

  bool get numberSupported => howManyChildrenOk.contains(howManyChildren);

  @override
  Widget build(BuildContext context) {
    if(!numberSupported) {
      return ifNumberNotSupported ?? Container();
    }

    return LayoutBuilder(builder: (_,constraints) => ConstrainedBox(
      constraints: constraints,
      child: _ArenaLayout(
        childBuilder: childBuilder,
        howManyChildren: howManyChildren,
        centerAlignment: centerAlignment,
        centerChildBuilder: centerChildBuilder,
        constraints: constraints,
        layoutType: layoutType,
        flipped: flipped ?? false,
        animateCenterWidget: animateCenterWidget,
        betweenGridAndCenter: betweenGridAndCenter,
      ),
    ),);
  }
}

class _ArenaLayout extends StatelessWidget {

  final ArenaChildBuilder childBuilder;
  final int howManyChildren;
  final CenterChildBuilder? centerChildBuilder;
  final ArenaCenterAlignment centerAlignment;
  final BoxConstraints constraints;
  final ArenaLayoutType layoutType;
  final bool flipped;
  final bool animateCenterWidget;
  final Widget? betweenGridAndCenter;

  const _ArenaLayout({
    required this.betweenGridAndCenter,
    required this.flipped,
    required this.layoutType,
    required this.childBuilder,
    required this.howManyChildren,
    required this.constraints,
    required this.centerChildBuilder,
    required this.centerAlignment,
    required this.animateCenterWidget,
  });
  

  @override
  Widget build(BuildContext context) {
    switch (howManyChildren) {
      case 2:
        return ArenaLayout2(
          centerAlignment: centerAlignment,
          centerChildBuilder: centerChildBuilder,
          childBuilder: childBuilder,
          constraints: constraints,
          flipped: flipped,
          betweenGridAndCenter: betweenGridAndCenter,
        );
      case 3:
        return ArenaLayout3(
          centerAlignment: centerAlignment,
          centerChildBuilder: centerChildBuilder,
          childBuilder: childBuilder,
          constraints: constraints,
          layoutType: layoutType,
          flipped: flipped,
          animateCenterWidget: animateCenterWidget,
          betweenGridAndCenter: betweenGridAndCenter,
        );
      case 4:
        return ArenaLayout4(
          centerAlignment: centerAlignment,
          centerChildBuilder: centerChildBuilder,
          childBuilder: childBuilder,
          constraints: constraints,
          layoutType: layoutType,
          flipped: flipped,
          betweenGridAndCenter: betweenGridAndCenter,
        );
      case 5:
        return ArenaLayout5(
          centerAlignment: centerAlignment,
          centerChildBuilder: centerChildBuilder,
          childBuilder: childBuilder,
          constraints: constraints,
          layoutType: layoutType,
          flipped: flipped,
          animateCenterWidget: animateCenterWidget,
          betweenGridAndCenter: betweenGridAndCenter,
        );
      case 6:
        return ArenaLayout6(
          centerAlignment: centerAlignment,
          centerChildBuilder: centerChildBuilder,
          childBuilder: childBuilder,
          constraints: constraints,
          layoutType: layoutType,
          flipped: flipped,
          betweenGridAndCenter: betweenGridAndCenter,
        );
      default:
        return Container();
    }
  }
}






