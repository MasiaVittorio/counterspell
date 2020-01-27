import 'package:counter_spell_new/core.dart';

class EditPlaygroupTile extends StatelessWidget {

  const EditPlaygroupTile();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return ListTile(
      title: const Text("Edit playgroup"),
      leading: const Icon(McIcons.account_multiple_outline),
      onTap: () => stage.showAlert(
        PlayGroupEditor(bloc), 
        size: PlayGroupEditor.sizeCalc(
          bloc.game.gameState.gameState.value.players.length,
        ),
      ),
    );
  }
}