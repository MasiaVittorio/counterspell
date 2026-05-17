import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/animated_number.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/split_theme.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AnimatedNumberCircle extends StatelessWidget {
  const AnimatedNumberCircle({
    super.key,
    required this.isAttacking,
    required this.page,
    required this.isSomeoneAttacking,
    required this.value,
    required this.increment,
    required this.highlight,
  });

  final bool isAttacking;
  final BodyPage page;
  final bool isSomeoneAttacking;
  final int value;
  final int increment;

  final bool highlight;

  static const double numberSize = 52;

  @override
  Widget build(BuildContext context) {
    final theme = context.leftTheme;
    final layout = theme.layout;

    return AnimatedContainer(
      duration: Motion.beginAndEndOnScreenStandard.duration,
      curve: Motion.beginAndEndOnScreenStandard.curve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: highlight
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.8)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(
          isAttacking && page == BodyPage.damage
              ? layout.radius.small
              : numberSize / 2,
        ),
      ),
      child: AnimatedOpacity(
        duration: Motion.beginAndEndOnScreenEmphasized.duration,
        curve: Motion.beginAndEndOnScreenEmphasized.curve,
        opacity: switch ((page, isSomeoneAttacking)) {
          (BodyPage.damage, false) => 0,
          _ => 1,
        },
        child: AnimatedNumber(
          textColor:
              (highlight
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest)
                  .contrast,
          duration: Motion.beginAndEndOnScreenEmphasized.duration,
          curve: Motion.beginAndEndOnScreenEmphasized.curve,
          size: numberSize,
          value: value,
          delta: increment,
        ),
      ),
    );
  }
}
