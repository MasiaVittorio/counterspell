import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/alerts/new_game_alert/new_game_alert.dart';
import 'package:counter_spell/widgets/alerts/winner_picker/winner_picker.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class RestartButton extends StatelessWidget {
  const RestartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final counterSpell = context.counterSpell;

    return SquareIconButton(
      dimension: context.panelFrameStyle.collapsedPanelHeight,
      onPressed: () =>
          frame.promptRestart(context: context, counterSpell: counterSpell),
      icon: const Icon(Icons.restart_alt_outlined),
    );
  }
}

extension RestartFrame on PanelFrameState {
  void promptRestart({
    required BuildContext context,
    required CounterSpell counterSpell,
  }) async {
    final game = counterSpell.gameLogic.readGame().deepCopy();
    final names = [for (final s in game.settings.playerSettings) s.name];

    final selectedWinner = game.gameStates.length <= 1
        ? -2
        : await showAlert(
            WinnerPicker(
              names: names,
              includeDontSaveOption: true,
              initialIndex: game.autoWinner,
            ),
          );

    switch (selectedWinner) {
      case -2: // don't save
        counterSpell.gameLogic.newGame(
          names: names,
          playgroupLogic: counterSpell.playgroupLogic,
        );
        showAlert(const NewGameAlert());
        return;
      case int winner:
        counterSpell.leaderboardsLogic.recordGame(
          game,
          selectedWinner: winner >= 0 && winner < names.length ? winner : null,
        );
        counterSpell.gameLogic.newGame(
          names: names,
          playgroupLogic: counterSpell.playgroupLogic,
        );
        showAlert(const NewGameAlert());
        return;
      default:
    }
  }
}
