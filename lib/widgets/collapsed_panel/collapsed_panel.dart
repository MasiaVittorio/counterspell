import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/collapsed_panel/center/collapsed_panel_center.dart';
import 'package:counter_spell/widgets/collapsed_panel/center/collapsed_panel_delay_indicator.dart';
import 'package:counter_spell/widgets/collapsed_panel/collapsed_panel_left_button.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/collapsed_panel_right_button.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:counter_spell/widgets/components/builders/has_increment_builder.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class CollapsedPanel extends StatelessWidget {
  const CollapsedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final interactionLogic = counterSpell.interactionLogic;
    final delay = context.delay;
    void onCancel() {
      delay.cancel();
      interactionLogic.cancelAdvancedInteraction();
    }

    return HasIncrementBuilder(
      child: const CollapsedPanelCenter(),
      builder: (context, hasIncrement, center) {
        return UsesArenaViewBuilder(
          child: center,
          builder: (context, arenaView, center) {
            return Column(
              children: [
                AnimatedListed(
                  listed: hasIncrement,
                  child: const CollapsedPanelDelayIndicator(),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CollapsedPanelLeftButton(
                        hasIncrement: hasIncrement,
                        onCancel: onCancel,
                      ),
                      Expanded(child: Center(child: center)),
                      CollapsedPanelRightButton(
                        hasIncrement: hasIncrement,
                        arenaView: arenaView,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
