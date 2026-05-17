import 'package:counter_spell/widgets/components/builders/animated_number_circle.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileLayout extends StatelessWidget {
  const PlayerTileLayout({
    super.key,
    required this.numberCircle,
    required this.title,
    required this.bottomTrailing,
    required this.subtitle,
    required this.dense,
  });

  final Widget numberCircle;
  final Widget title;
  final Widget bottomTrailing;
  final Widget subtitle;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    return Stack(
      children: [
        Positioned.fill(
          child: Pad(
            horizontal: layout.padding.medium,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AnimatedNumberCircle.numberSize,
                  child: numberCircle,
                ),
                Space.horizontal(layout.spacing.medium),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [title, subtitle],
                    ),
                  ),
                ),
                Space.horizontal(layout.margin.medium),
              ],
            ),
          ),
        ),
        Positioned(
          right: dense ? layout.padding.smaller : layout.padding.medium,
          bottom: dense ? layout.padding.smaller : layout.padding.medium,
          child: bottomTrailing,
        ),
      ],
    );
  }
}
