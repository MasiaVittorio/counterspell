import 'package:counter_spell/core.dart';

class SnackRestart extends StatelessWidget {
  const SnackRestart({super.key});

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);

    return ConfirmSnackbar(
      label: "Restart game?",
      action: () => bloc.game.gameState.restart(GameRestartedFrom.historyPage),
    );
  }
}
