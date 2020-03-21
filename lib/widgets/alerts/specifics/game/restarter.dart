import 'package:counter_spell_new/core.dart';

class RestarterAlert extends StatelessWidget {
  const RestarterAlert(this.fromClosedPanel);
  final bool fromClosedPanel;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    return ConfirmAlert(
      action: () => bloc.game.gameState.restart(this.fromClosedPanel ?? false),
      warningText: "This action cannot be undone.",
      confirmText: "Restart the game",
      confirmIcon: McIcons.restart,
      cancelColor: CSColors.delete,
      completelyCloseAfterConfirm: true,
    );
  }
}