// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class RandomPlayerAlert extends StatelessWidget {
  const RandomPlayerAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.gameLogic.buildWithGame(
      (context, game) => _RandomPlayerAlert(
        names: [
          for (final settings in game.settings.playerSettings) settings.name,
        ],
      ),
    );
  }
}

class _RandomPlayerAlert extends StatefulWidget {
  const _RandomPlayerAlert({required this.names});

  final List<String> names;

  @override
  State<_RandomPlayerAlert> createState() => _RandomPlayerAlertState();
}

class _RandomPlayerAlertState extends State<_RandomPlayerAlert>
    with SingleTickerProviderStateMixin {
  late int pick;
  late Duration duration;
  late int ticks;

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    pick = rng.nextInt(widget.names.length);
    duration = rng.nextDouble().rangeMap(to: (1600, 2000)).round().milliseconds;
    ticks = (rng.nextInt(2) + 7) * widget.names.length + pick;
    controller.animateTo(
      1,
      duration: duration,
      curve: Easing.emphasizedDecelerate,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final layout = theme.layout;
    final groupedTheme = GroupedCardTheme.of(context);

    return PanelList.shrink(
      title: Text('Starting player'),
      children: [
        for (int i = 0; i < widget.names.length; i++)
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final bool isThisHighlighted =
                  ((controller.value * ticks + 0.1) % widget.names.length)
                      .floor() ==
                  i;

              final bool superHighlight = controller.value == 1 && i == pick;

              final isFirst = i == 0;
              final isLast = i == widget.names.length - 1;
              final bottomMargin = isLast
                  ? (groupedTheme.lastPadding ?? layout.margin.medium)
                  : layout.spacing.tiny;

              final radius = GroupedCard.borderRadius(
                theme.layout,
                isFirst: isFirst,
                isLast: isLast,
              );
              final backgroundColor = isThisHighlighted
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surfaceContainer;
              final borderSide = superHighlight
                  ? BorderSide(color: theme.colorScheme.primary)
                  : BorderSide.none;

              return AnimatedContainer(
                margin: EdgeInsets.only(
                  bottom: bottomMargin,
                  right: layout.margin.medium,
                  left: layout.margin.medium,
                ),
                duration: Motion.beginAndEndOnScreenEmphasized.duration,
                curve: Motion.beginAndEndOnScreenEmphasized.curve,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: radius,
                  border: Border.fromBorderSide(borderSide),
                ),
                child: ListTile(
                  title: Text(
                    widget.names[i],
                    style: TextStyle(
                      color: superHighlight ? theme.colorScheme.primary : null,
                    ),
                  ),
                  trailing: superHighlight
                      ? Icon(
                          MdiIcons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
              );
            },
          ),
      ],
    );
  }
}
