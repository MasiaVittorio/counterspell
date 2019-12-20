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
            const SectionTitle("Game Settings"),
            const StartingLifeTile(),
          ]),
          Section([
            const SectionTitle("Extras"),
            ListTile(
              onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
              title: const Text("Dice / coins & random names"),
              leading: Icon(McIcons.dice_multiple),
            ),
            bloc.payments.unlocked.build((_, unlocked) => ListTile(
              onTap: () {
                if(unlocked){
                  stage.showAlert(const Leaderboards(), size: Leaderboards.height);
                } else {
                  stage.showAlert(const Support(), size: Support.height);
                }
              },
              title: const Text("Leaderboards"),
              leading: const Icon(McIcons.trophy),
              trailing: unlocked ? null : const Icon(McIcons.alert_decagram_outline),
            )),
            ListTile(
              onTap: () => showSimpleGroup(context: context, bloc: bloc),
              title: const Text("Simple view"),
              leading: const Icon(CSIcons.simpleViewIcon, size: 20,),
            ),
          ]),
          ListTile(
            title: const Text("New game"),
            leading: const Icon(McIcons.restart),
            onTap: () => stage.showAlert(const RestarterAlert(), size: ConfirmAlert.height),
          ),
          ListTile(
            title: const Text("Edit playgroup"),
            leading: const Icon(McIcons.account_multiple_outline),
            onTap: () => stage.showAlert(
              PlayGroupEditor(bloc), 
              size: PlayGroupEditor.sizeCalc(
                bloc.game.gameState.gameState.value.players.length,
              ),
            ),
          ),
        ],
      )
    );
  }
}