import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/restore_cta.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class LeaderboardsInfoAlert extends StatelessWidget {
  const LeaderboardsInfoAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final panelFrame = context.panelFrame;

    return AlternativesPanelAlert(
      content: const Text(
        "CounterSpell tracks your games as you play them to compile a leaderboard. When it can't automatically detect a winner, it will ask you to input the result of the game. You can also manually edit any past game to fix any mistake or add missing information.",
      ),
      alternatives: [
        PanelAlternative(
          value: 0,
          label: const Text('Import past games'),
          icon: Icon(MdiIcons.trayArrowDown),
        ),
        const PanelAlternative(
          value: 1,
          label: Text('Go back'),
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ],
      autoCloseOnSubmit: false,
      onSubmit: (value) async {
        switch (value) {
          case 0:
            RestoreCallToAction.action(panelFrame, counterSpell);
            return;
          case 1:
            panelFrame.previousAlert();
            return;
          default:
        }
      },
    );
  }
}
