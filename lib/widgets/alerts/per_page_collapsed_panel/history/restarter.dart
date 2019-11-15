import 'package:counter_spell_new/core.dart';

class RestarterAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    return ConfirmAlert(
      action: bloc.game.gameState.restart,
      warningText: "This action cannot be undone.",
      confirmText: "Restart the game",
      confirmIcon: McIcons.restart,
      cancelColor: DELETE_COLOR,
      completelyCloseAfterConfirm: true,
    );
  }
}