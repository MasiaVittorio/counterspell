import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/attacker_name.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/edit_commanders_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/edit_game_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/edit_playgroup_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/pick_counter_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/restart_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/select_attacker_hint.dart';
import 'package:counter_spell/widgets/components/builders/attacker_name_builder.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:counter_spell/widgets/components/project/child_switcher.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CollapsedPanelRightButton extends StatelessWidget {
  const CollapsedPanelRightButton({
    super.key,
    required this.hasIncrement,
    required this.arenaView,
  });

  final bool hasIncrement;
  final bool arenaView;

  @override
  Widget build(BuildContext context) {
    if (arenaView) return const EditGameButton();

    final delay = context.provide<DelayController>();
    final style = context.panelFrameStyle;
    final dimension = style.collapsedPanelHeight;
    final counterSpell = context.counterSpell;

    return AttackerNameBuilder(
      builder: (context, attackerName, _) =>
          counterSpell.pagesLogic.bodyPage.build(
            (context, page) => ChildSwitcher(
              opacityOverlap: 0.4,
              duration: Motion.beginAndEndOnScreenEmphasized.duration,
              curve: Motion.beginAndEndOnScreenEmphasized.curve,
              constraints: BoxConstraints(
                minWidth: dimension,
                maxHeight: dimension,
                minHeight: dimension,
              ),
              child: switch (hasIncrement) {
                true => SquareIconButton(
                  key: const ValueKey('conf'),
                  dimension: dimension,
                  onPressed: delay.forceConfirm,
                  icon: const Icon(Icons.check),
                ),
                false => switch (page) {
                  BodyPage.history => const RestartButton(key: ValueKey('h')),
                  BodyPage.counters => const PickCounterButton(
                    key: ValueKey('coun'),
                  ),
                  BodyPage.life => const EditPlaygroupButton(
                    key: ValueKey('l'),
                  ),
                  BodyPage.cast => const EditCommandersButton(
                    key: ValueKey('cast'),
                  ),
                  BodyPage.damage => switch (attackerName) {
                    null => const SelectAttackerHint(key: ValueKey('dn')),
                    _ => AttackerName(
                      name: attackerName,
                      key: const ValueKey('d'),
                    ),
                  },
                },
              },
            ),
          ),
    );
  }
}
