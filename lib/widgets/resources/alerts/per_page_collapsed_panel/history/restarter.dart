import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/ui_model/all.dart';
import 'package:counter_spell_new/widgets/resources/alerts/templates/templates.dart';
import 'package:flutter/material.dart';

class RestarterAlert extends StatelessWidget {
  static const double height = 56*2+32.0;
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    return ConfirmStageAlert(
      action: bloc.game.gameState.restart,
      warningText: "This action cannot be undone.",
      confirmText: "Restart the game",
      confirmIcon: McIcons.restart,
      cancelColor: DELETE_COLOR,
    );
  }
}