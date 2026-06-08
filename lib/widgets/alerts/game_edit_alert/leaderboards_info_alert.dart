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
    final gameRecords = counterSpell.leaderboardsLogic.gameRecords;
    final panelFrame = context.panelFrame;

    return AlternativesPanelAlert(
      content: const Text(
        "CounterSpell tracks your games as you play them to compile a leaderboard. When it can't automatically detect a winner, it will ask you to input the result of the game. You can also manually edit any past game to fix any mistake or add missing information.",
      ),
      alternatives: [
        PanelAlternative(
          value: 0,
          danger: false,
          label: const Text('Import past games'),
          icon: Icon(MdiIcons.trayArrowDown),
        ),
        const PanelAlternative(
          value: 1,
          danger: true,
          label: Text('Delete all past games'),
          icon: Icon(Icons.delete_forever_outlined),
        ),
      ],
      autoCloseOnSubmit: false,
      onSubmit: (value) async {
        switch (value) {
          case 0:
            RestoreCallToAction.action(panelFrame, counterSpell);
            return;
          case 1:
            final result = await context.panelFrame.showAlert(
              const ConfirmPanelAlert.delete(
                title: Text('Delete all past game records?'),
                content: Text('This action cannot be undone.'),
              ),
            );
            if (result == true) {
              gameRecords.value.clear();
              gameRecords.refresh();
              panelFrame.previousAlert();
            }
            return;
          default:
        }
      },
    );
  }
}
