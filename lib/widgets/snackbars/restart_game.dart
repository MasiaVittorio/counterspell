import 'package:counter_spell_new/core.dart';

class SnackRestart extends StatelessWidget {

  const SnackRestart();

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);

    return StageSnackBar(
      alignment: 0,
      scrollable: true,
      title: const Text("Restart game?"),
      secondary: StageSnackBarButton(
        onTap: () => bloc.game.gameState.restart(true),
        icon: const Icon(Icons.check),
        autoClose: true,
      ),
    );
  }
}