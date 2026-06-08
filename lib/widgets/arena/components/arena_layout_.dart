import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/components/button_side.dart';
import 'package:counter_spell/widgets/arena/components/horizontal_split.dart';
import 'package:counter_spell/widgets/arena/components/vertical_split.dart';
import 'package:flutter/cupertino.dart';

class ArenaLayout extends StatelessWidget {
  const ArenaLayout({
    super.key,
    required this.players,
    required this.horizontalFlip,
    required this.verticalFlip,
    required this.spacing,
    required this.mode,
    required this.foregroundBuilder,
  });

  final List<Widget> players;
  final bool horizontalFlip;
  final bool verticalFlip;
  final double spacing;
  final ArenaLayoutMode mode;
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    Offset centerButtonOffset,
    Axis centerButtonAxis,
  )?
  foregroundBuilder;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      ArenaLayoutMode.twoTall => TwoPlayersArenaLayoutTall(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.twoWide => TwoPlayersArenaLayoutWide(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.threeFFA => ThreePlayersArenaLayoutFFA(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.three2v1 => ThreePlayersArenaLayout2v1(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.fourFFA => FourPlayersArenaLayoutFFA(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.four2v2 => FourPlayersArenaLayout2v2(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.four1v2v1 => FourPlayersArenaLayout1v2v1(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.five1v2v2 => FivePlayersArenaLayout1v2v2(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.five1v2v1v1 => FivePlayersArenaLayout1v2v1v1(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.five3v2 => FivePlayersArenaLayout3v2(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.six3v3 => SixPlayersArenaLayout3v3(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
      ArenaLayoutMode.sixFFA => SixPlayersArenaLayoutFFA(
        players: players,
        horizontalFlip: horizontalFlip,
        verticalFlip: verticalFlip,
        spacing: spacing,
        foregroundBuilder: foregroundBuilder,
      ),
    };
  }
}

sealed class ArenaLayoutClass extends StatelessWidget {
  const ArenaLayoutClass({
    super.key,
    required this.players,
    required this.horizontalFlip,
    required this.verticalFlip,
    required this.spacing,
    required this.foregroundBuilder,
  });

  final List<Widget> players;
  final bool horizontalFlip;
  final bool verticalFlip;
  final double spacing;
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    Offset centerButtonOffset,
    Axis centerButtonAxis,
  )?
  foregroundBuilder;

  Offset centerButtonOffset(Size constraints);
  Axis get centerButtonAxis;

  @override
  Widget build(BuildContext context) {
    final foregroundBuilder = this.foregroundBuilder;

    if (foregroundBuilder == null) return buildContent(context);

    return Stack(
      children: [
        buildContent(context),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final offset = centerButtonOffset(constraints.biggest);
              return foregroundBuilder(context, constraints, switch ((
                verticalFlip,
                horizontalFlip,
              )) {
                (false, false) => offset,
                (false, true) => Offset(
                  constraints.maxWidth - offset.dx,
                  offset.dy,
                ),
                (true, false) => Offset(
                  offset.dx,
                  constraints.maxHeight - offset.dy,
                ),
                (true, true) => Offset(
                  constraints.maxWidth - offset.dx,
                  constraints.maxHeight - offset.dy,
                ),
              }, centerButtonAxis);
            },
          ),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context);
}

sealed class FourPlayersArenaLayout extends ArenaLayoutClass {
  const FourPlayersArenaLayout({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });
}

sealed class ThreePlayersArenaLayout extends ArenaLayoutClass {
  const ThreePlayersArenaLayout({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });
}

sealed class TwoPlayersArenaLayout extends ArenaLayoutClass {
  const TwoPlayersArenaLayout({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });
}

sealed class FivePlayersArenaLayout extends ArenaLayoutClass {
  const FivePlayersArenaLayout({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });
}

sealed class SixPlayersArenaLayout extends ArenaLayoutClass {
  const SixPlayersArenaLayout({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });
}

// portrait view divided top / bottom
// |===========|
// |           |
// |     v     |
// |           |
// |=====o=====|
// |           |
// |     ^     |
// |           |
// |===========|
final class TwoPlayersArenaLayoutTall extends TwoPlayersArenaLayout {
  const TwoPlayersArenaLayoutTall({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.horizontal;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalSplit.opposing(
      top: players[0],
      bottom: players[1],
      spacing: spacing,
      flip: verticalFlip,
    );
  }
}

// landscape view divided top / bottom
// |===========|
// |     |     |
// |     |     |
// |     |     |
// |  >  o  <  |
// |     |     |
// |     |     |
// |     |     |
// |===========|
final class TwoPlayersArenaLayoutWide extends TwoPlayersArenaLayout {
  const TwoPlayersArenaLayoutWide({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return HorizontalSplit.opposing(
      left: players[0],
      right: players[1],
      spacing: spacing,
      flip: horizontalFlip,
    );
  }
}

// portrait view, one player on top, two players on bottom split left/right
// |===========|
// |     v     |
// |===========|
// |     |     |
// |     |     |
// |  >  o  <  |
// |     |     |
// |     |     |
// |===========|
final class ThreePlayersArenaLayoutFFA extends ThreePlayersArenaLayout {
  const ThreePlayersArenaLayoutFFA({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Offset centerButtonOffset(Size constraints) {
    final h = constraints.height - spacing;
    return Offset(
      constraints.width / 2,
      constraints.height - (h * bottom / (tot)) / 2,
    );
  }

  static const int top = 10;
  static const int bottom = 22;
  static const int tot = top + bottom;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalSplit.opposing(
      spacing: spacing,
      ratios: (top, bottom),
      flip: verticalFlip,
      top: players[0],
      bottom: HorizontalSplit.opposing(
        flip: horizontalFlip,
        spacing: spacing,
        left: players[1],
        right: players[2],
      ),
    );
  }
}

// landscape view, two players on top, one player on the bottom
// |===========|
// |     |     |
// |  >  |     |
// |     |     |
// |=====o  <  |
// |     |     |
// |  >  |     |
// |     |     |
// |===========|
final class ThreePlayersArenaLayout2v1 extends ThreePlayersArenaLayout {
  const ThreePlayersArenaLayout2v1({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Widget buildContent(BuildContext context) {
    return HorizontalSplit.opposing(
      spacing: spacing,
      flip: horizontalFlip,
      right: players[2],
      left: HorizontalSplit.team(
        spacing: spacing,
        flip: verticalFlip,
        left: ButtonSide.rightUnless(verticalFlip, child: players[0]),
        right: ButtonSide.leftUnless(verticalFlip, child: players[1]),
      ),
    );
  }
}

// landscape view, two players on top, two players on the bottom
// |===========|
// |     |     |
// |  >  |  <  |
// |     |     |
// |=====o=====|
// |     |     |
// |  >  |  <  |
// |     |     |
// |===========|
final class FourPlayersArenaLayout2v2 extends FourPlayersArenaLayout {
  const FourPlayersArenaLayout2v2({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return HorizontalSplit.opposing(
      spacing: spacing,
      flip: horizontalFlip,
      left: HorizontalSplit.team(
        spacing: spacing,
        flip: verticalFlip,
        left: ButtonSide.rightUnless(verticalFlip, child: players[0]),
        right: ButtonSide.leftUnless(verticalFlip, child: players[1]),
      ),
      right: HorizontalSplit.team(
        spacing: spacing,
        flip: verticalFlip,
        left: ButtonSide.rightUnless(verticalFlip, child: players[2]),
        right: ButtonSide.leftUnless(verticalFlip, child: players[3]),
      ),
    );
  }
}

// one player for each side
// |===========|
// |     v     |
// |===========|
// |     |     |
// |  >  o  <  |
// |     |     |
// |===========|
// |     ^     |
// |===========|
final class FourPlayersArenaLayoutFFA extends FourPlayersArenaLayout {
  const FourPlayersArenaLayoutFFA({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalThreewaySplit(
      flip: verticalFlip,
      spacing: spacing,
      ratios: (1, 2, 1),
      top: players[0],
      middle: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        left: players[1],
        right: players[2],
      ),
      bottom: players[3],
    );
  }
}

// |===========|
// |     v     |
// |=====o=====|
// |  >  |     |
// |=====|  <  |
// |  >  |     |
// |===========|
final class FourPlayersArenaLayout1v2v1 extends FourPlayersArenaLayout {
  const FourPlayersArenaLayout1v2v1({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Axis get centerButtonAxis => Axis.horizontal;

  @override
  Offset centerButtonOffset(Size constraints) {
    final h = constraints.height - spacing;
    return Offset(constraints.width / 2, h * top / tot + spacing / 2);
  }

  static const int top = 10;
  static const int bottom = 24;
  static const int tot = top + bottom;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalSplit.opposing(
      ratios: (top, bottom),
      spacing: spacing,
      flip: verticalFlip,
      top: players[0],
      bottom: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        right: ButtonSide.rightUnless(horizontalFlip, child: players[1]),
        left: HorizontalSplit.team(
          spacing: spacing,
          flip: false,
          left: ButtonSide(
            data: horizontalFlip ? ButtonSideData.right : ButtonSideData.left,
            child: players[2],
          ),
          right: ButtonSide(
            data: horizontalFlip ? ButtonSideData.right : ButtonSideData.left,
            child: players[3],
          ),
        ),
      ),
    );
  }
}

// |===========|
// |     v     |
// |===========|
// |  >  |  <  |
// |  >  |  <  |
// |=====o=====|
// |  >  |  <  |
// |  >  |  <  |
// |===========|
final class FivePlayersArenaLayout1v2v2 extends FivePlayersArenaLayout {
  const FivePlayersArenaLayout1v2v2({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Axis get centerButtonAxis => Axis.horizontal;

  @override
  Offset centerButtonOffset(Size constraints) {
    final h = constraints.height - spacing * 2;
    return Offset(
      constraints.width / 2,
      constraints.height - h * bottom / tot - spacing / 2,
    );
  }

  static const int top = 10;
  static const int middle = 15;
  static const int bottom = 15;
  static const int tot = top + middle + bottom;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalThreewaySplit(
      flip: verticalFlip,
      spacing: spacing,
      ratios: (top, middle, bottom),
      top: players[0],
      middle: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        left: ButtonSide(
          data: switch ((verticalFlip, horizontalFlip)) {
            (false, false) || (true, true) => ButtonSideData.right,
            (false, true) || (true, false) => ButtonSideData.left,
          },
          child: players[1],
        ),
        right: ButtonSide(
          data: switch ((verticalFlip, horizontalFlip)) {
            (false, false) || (true, true) => ButtonSideData.left,
            (false, true) || (true, false) => ButtonSideData.right,
          },
          child: players[2],
        ),
      ),
      bottom: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        left: ButtonSide(
          data: switch ((verticalFlip, horizontalFlip)) {
            (false, false) || (true, true) => ButtonSideData.left,
            (false, true) || (true, false) => ButtonSideData.right,
          },
          child: players[3],
        ),
        right: ButtonSide(
          data: switch ((verticalFlip, horizontalFlip)) {
            (false, false) || (true, true) => ButtonSideData.right,
            (false, true) || (true, false) => ButtonSideData.left,
          },
          child: players[4],
        ),
      ),
    );
  }
}

// |===========|
// |     v     |
// |===========|
// |  >  |     |
// |=====|  <  |
// |  >  |     |
// |===========|
// |     ^     |
// |===========|
final class FivePlayersArenaLayout1v2v1v1 extends FivePlayersArenaLayout {
  const FivePlayersArenaLayout1v2v1v1({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalThreewaySplit(
      flip: verticalFlip,
      spacing: spacing,
      ratios: (10, 25, 10),
      top: players[0],
      middle: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        left: HorizontalSplit.team(
          spacing: spacing,
          flip: verticalFlip,
          left: ButtonSide.rightUnless(verticalFlip, child: players[1]),
          right: ButtonSide.leftUnless(verticalFlip, child: players[2]),
        ),
        right: players[3],
      ),
      bottom: players[4],
    );
  }
}

// |===========|
// |  >  |  <  |
// |=====|  <  |
// |  >  |=====|
// |=====|  <  |
// |  >  |  <  |
// |===========|
final class FivePlayersArenaLayout3v2 extends FivePlayersArenaLayout {
  const FivePlayersArenaLayout3v2({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return HorizontalSplit.opposing(
      spacing: spacing,
      flip: horizontalFlip,
      left: HorizontalThreewaySplit(
        left: ButtonSide.rightUnless(verticalFlip, child: players[0]),
        middle: players[1],
        right: ButtonSide.leftUnless(verticalFlip, child: players[2]),
        flip: verticalFlip,
        spacing: spacing,
        ratios: (1, 1, 1),
      ),
      right: HorizontalSplit.team(
        spacing: spacing,
        flip: verticalFlip,
        left: ButtonSide.rightUnless(verticalFlip, child: players[3]),
        right: ButtonSide.leftUnless(verticalFlip, child: players[4]),
      ),
    );
  }
}

// |===========|
// |  >  |  <  |
// |=====|=====|
// |  >  o  <  |
// |=====|=====|
// |  >  |  <  |
// |===========|
final class SixPlayersArenaLayout3v3 extends SixPlayersArenaLayout {
  const SixPlayersArenaLayout3v3({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return HorizontalSplit.opposing(
      spacing: spacing,
      flip: horizontalFlip,
      left: HorizontalThreewaySplit(
        left: ButtonSide.rightUnless(verticalFlip, child: players[0]),
        middle: players[1],
        right: ButtonSide.leftUnless(verticalFlip, child: players[2]),
        flip: verticalFlip,
        spacing: spacing,
        ratios: (1, 1, 1),
      ),
      right: HorizontalThreewaySplit(
        left: ButtonSide.rightUnless(verticalFlip, child: players[3]),
        middle: players[4],
        right: ButtonSide.leftUnless(verticalFlip, child: players[5]),
        flip: verticalFlip,
        spacing: spacing,
        ratios: (1, 1, 1),
      ),
    );
  }
}

// |===========|
// |     v     |
// |===========|
// |  >  |  <  |
// |=====o=====|
// |  >  |  <  |
// |===========|
// |     ^     |
// |===========|
final class SixPlayersArenaLayoutFFA extends SixPlayersArenaLayout {
  const SixPlayersArenaLayoutFFA({
    super.key,
    required super.players,
    required super.horizontalFlip,
    required super.verticalFlip,
    required super.spacing,
    required super.foregroundBuilder,
  });

  @override
  Offset centerButtonOffset(Size constraints) {
    return constraints.center(Offset.zero);
  }

  @override
  Axis get centerButtonAxis => Axis.vertical;

  @override
  Widget buildContent(BuildContext context) {
    return VerticalThreewaySplit(
      flip: verticalFlip,
      spacing: spacing,
      ratios: (10, 25, 10),
      top: players[0],
      middle: HorizontalSplit.opposing(
        spacing: spacing,
        flip: horizontalFlip,
        left: HorizontalSplit.team(
          spacing: spacing,
          flip: verticalFlip,
          left: ButtonSide.rightUnless(verticalFlip, child: players[1]),
          right: ButtonSide.leftUnless(verticalFlip, child: players[2]),
        ),
        right: HorizontalSplit.team(
          spacing: spacing,
          flip: verticalFlip,
          left: ButtonSide.rightUnless(verticalFlip, child: players[3]),
          right: ButtonSide.leftUnless(verticalFlip, child: players[4]),
        ),
      ),
      bottom: players[5],
    );
  }
}
