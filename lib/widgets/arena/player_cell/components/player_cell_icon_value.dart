import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellIconValue extends StatelessWidget {
  const PlayerCellIconValue({
    super.key,
    required this.icon,
    required this.value,
    this.smaller = 0.8,
    this.highlightIcon = false,
  });

  final IconData icon;
  final Widget value;
  final double smaller;
  final bool highlightIcon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Center(
      child: BiggestSquare(
        child: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) => Icon(
                  icon,
                  color: theme.brightness.contrast.withValues(
                    alpha: highlightIcon ? 1 : 0.3,
                  ),
                  size: constraints.maxWidth * smaller,
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Pad(
                  all: layout.margin.medium,
                  child: DefaultTextStyle(
                    style: DefaultTextStyle.of(context).style.merge(
                      theme.textTheme.displayLarge!.copyWith(
                        fontSize: theme.textTheme.displayLarge!.fontSize! * 1.2,
                        color: theme.brightness.contrast,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    child: value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
