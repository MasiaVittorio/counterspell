import 'package:counter_spell_new/core.dart';
import 'game_components/all.dart';


class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return SingleChildScrollView(
      physics: stage.panelController.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          const Section([
            PanelTitle("Enabled Screens", centered: false),
            PagePie(),
          ]),
          StartingLifeTile(),
          const Section([
            SectionTitle("Extras"),
            PanelGameExtras(),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(children: <Widget>[
              Expanded(child: ExtraButton(
                icon: McIcons.restart,
                text: "New Game",
                onTap: () => stage.showAlert(const RestarterAlert(false), size: ConfirmAlert.height),
                filled: true,
              ),),
              CSWidgets.extraButtonsDivider,
              Expanded(child: ExtraButton(
                icon: McIcons.account_multiple_outline,
                text: "Edit playgroup",
                onTap: () => stage.showAlert(
                  PlayGroupEditor(bloc, fromClosedPanel: false,), 
                  size: PlayGroupEditor.sizeCalc(
                    bloc.game.gameState.gameState.value.players.length,
                  ),
                ),
                filled: true,
              ),),
            ],),
          ),
          // const RestartTile(),
          // const EditPlaygroupTile(),
        ],
      )
    );
  }
}