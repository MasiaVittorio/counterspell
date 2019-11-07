import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/simple_view/simple_group_route.dart';
import 'game_components/starting_life.dart';

class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);
    // final pagesController = stage.pagesController;
    // final pageThemes = pagesController.pagesData;
    // final enabledPages = pagesController.enabledPages;

    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const AlertTitle("Game Settings", centered: false),
            bloc.settings.applyDamageToLife.build((_,apply) => SwitchListTile(
              value: apply,
              onChanged: (value) => bloc.settings.applyDamageToLife.set(value),
              secondary: const Icon(CSTypesUI.attackIconOne),
              title: const Text("Commander damage to life"),
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Divider(height: 8.0,),
            ),
            const StartingLifeTile(),
          ]),
          Section([
            const SectionTitle("Extras"),
            ListTile(
              onTap: () => showSimpleGroup(context: context, bloc: bloc),
              title: const Text("Simple view"),
              leading: const Icon(CSTypesUI.simpleViewIcon, size: 20,),
            ),
            ListTile(
              onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
              title: const Text("Dice & coins"),
              leading: Icon(McIcons.dice_multiple),
            ),
          ]),
          Section([
            const SectionTitle("Game State"),
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
                size: ConfirmStageAlert.height,
              ),
              title: const Text("Restart the game"),
              leading: const Icon(McIcons.restart),
            ),
          ]),
        ],
      )
    );
  }
}