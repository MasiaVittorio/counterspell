import 'package:counter_spell_new/core.dart';

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