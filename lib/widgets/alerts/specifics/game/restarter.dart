import 'package:counter_spell/core.dart';

class RestarterAlert extends StatelessWidget {
  const RestarterAlert(this.from, {super.key});
  final GameRestartedFrom from;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    return ConfirmAlert(
      action: () => bloc.game.gameState.restart(from),
      warningText: "This action cannot be undone.",
      confirmText: "Restart the game",
      confirmIcon: McIcons.restart,
      cancelColor: CSColors.delete,
      completelyCloseAfterConfirm: true,
    );
  }
}
