import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/widgets/alerts/game_edit_alert/game_edit_alert.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class EditGameButton extends StatelessWidget {
  const EditGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.panelFrameStyle;
    final panelFrame = context.panelFrame;

    return SquareIconButton(
      icon: const Icon(CounterSpellIcons.counterspell),
      dimension: style.collapsedPanelHeight,
      onPressed: () => panelFrame.showAlert(const GameEditAlert()),
    );
  }
}
