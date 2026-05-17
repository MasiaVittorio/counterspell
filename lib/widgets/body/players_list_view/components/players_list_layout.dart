import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileHeight {
  final double value;

  PlayerTileHeight({required this.value});

  @override
  bool operator ==(covariant PlayerTileHeight other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

extension PlayerTileHeightFromContext on BuildContext {
  double get playerTileHeight => provide<PlayerTileHeight>().value;
}

class PlayerListLayoutBuilder extends StatelessWidget {
  static const double minSize = 120;

  const PlayerListLayoutBuilder({
    super.key,
    required this.playerCount,
    required this.builder,
  });

  final int playerCount;
  final Widget Function(
    BuildContext context,
    double totalHeight,
    bool scrollable,
  )
  builder;

  static double topMargin(Layout layout, EdgeInsets safe) =>
      layout.margin.tiny + safe.top;

  static double bottomMargin(Layout layout, EdgeInsets safe) =>
      layout.margin.medium + safe.bottom;

  static double spacing(Layout layout) => layout.spacing.smaller;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final safe = MediaQuery.paddingOf(context);
    final n = playerCount;

    final top = topMargin(layout, safe);
    final bottom = bottomMargin(layout, safe);
    final spacing = PlayerListLayoutBuilder.spacing(layout);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (n == 0) {
          return CleanProvider(
            data: PlayerTileHeight(value: minSize),
            child: builder(context, constraints.maxHeight, false),
          );
        }

        final available =
            constraints.maxHeight - spacing * (n - 1) - top - bottom;
        final each = available / n;

        final tileHeight = each.clamp(minSize, double.infinity);

        final totalHeight =
            top + bottom + (tileHeight * n) + (spacing * (n - 1));

        return ConstrainedBox(
          constraints: constraints,
          child: CleanProvider(
            data: PlayerTileHeight(value: tileHeight),
            child: builder(context, totalHeight, each < minSize),
          ),
        );
      },
    );
  }
}
