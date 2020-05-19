import 'package:counter_spell_new/core.dart';

class SnackRestart extends StatelessWidget {

  const SnackRestart();

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);

    return ConfirmSnackbar(
      label:"Restart game?",
      action: () => bloc.game.gameState.restart(true),
    );
  }
}