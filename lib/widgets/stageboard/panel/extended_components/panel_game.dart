import 'package:counter_spell_new/widgets/simple_view/simple_group_route.dart';
import 'package:counter_spell_new/core.dart';
import 'game_components/all.dart';


class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const AlertTitle("Enabled Screens", centered: false),
            const PagePie(),
          ]),
          Section([
            const SectionTitle("Game State"),
            const StartingLifeTile(),
            ListTile(
              onTap: () => stage.showAlert(
                PlayGroupEditor(bloc),
                size: PlayGroupEditor.sizeCalc(bloc.game.gameGroup.names.value.length),
              ),
              title: const Text("Manage playgroup"),
              leading: const Icon(McIcons.account_multiple_outline),
            ),
            ListTile(
              onTap: () => stage.showAlert(
                RestarterAlert(),
                size: ConfirmAlert.height,
              ),
              title: const Text("Restart the game"),
              leading: const Icon(McIcons.restart),
            ),
          ]),
          Section([
            const SectionTitle("Extras"),
            ListTile(
              onTap: () => showSimpleGroup(context: context, bloc: bloc),
              title: const Text("Simple view"),
              leading: const Icon(CSIcons.simpleViewIcon, size: 20,),
            ),
            ListTile(
              onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
              title: const Text("Dice & coins"),
              leading: Icon(McIcons.dice_multiple),
            ),
          ]),
        ],
      )
    );
  }
}