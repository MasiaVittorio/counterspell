import 'package:counter_spell_new/core.dart';


class PanelGameExtras extends StatelessWidget {

  const PanelGameExtras(this.arenaOpener, {required this.compact});

  final VoidCallback arenaOpener;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context)!;

    void launchHelpers() => stage.showAlert(
      const CrazySpecificStuff(),
      size: CrazySpecificStuff.size, 
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        SubSection(<Widget>[
          const SectionTitle("Extras"),
          ButtonTilesRow(children: <Widget>[
            ButtonTile.transparent(
              icon: McIcons.dice_multiple,
              text: "Random",
              onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
            ),
            bloc.payments.unlocked.build((_, unlocked) => ButtonTile.transparent(
              icon: McIcons.license,
              text: "Leaderboards",
              onTap: () {
                if(unlocked){
                  stage.showAlert(const Leaderboards(), size: Leaderboards.height);
                } else {
                  stage.showAlert(const SupportAlert(), size: SupportAlert.height);
                }
              },
            ),),
            ButtonTile.transparent(
              icon: CSIcons.counterSpell,
              // iconSize: CSIcons.ideal_counterspell_size,
              // iconPadding: CSIcons.ideal_counterspell_padding,
              text: "Arena",
              onTap: arenaOpener,
            ),
          ],),

          const Space.vertical(4),
        ],),

        const Space.vertical(10),

        ButtonTilesRow(
          margin: EdgeInsets.zero,
          children: <Widget>[
            ButtonTile(
              icon: McIcons.restart,
              text: "Start new game",
              onTap: () => stage.showAlert(const RestarterAlert(GameRestartedFrom.menu), size: ConfirmAlert.height),
            ),
            ButtonTile(
              icon: McIcons.account_multiple_outline,
              text: "Edit playgroup",
              onTap: () => stage.showAlert(
                PlayGroupEditor(bloc, fromClosedPanel: false,), 
                size: PlayGroupEditor.sizeCalc(
                  bloc.game.gameState.gameState.value.players.length,
                ),
              ),
            ),
            if(compact)
              ButtonTile(
                icon: ManaIcons.instant, 
                text: "Helpers", 
                onTap: launchHelpers,
              ),
          ],
        ),

        if(!compact)...[
          const Space.vertical(10),
          SubSection([
            ListTile(
              title: const Text("Helpers"),
              leading: const Icon(ManaIcons.instant),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: launchHelpers,
            ),
          ]),
        ],



      ],
    );
  }
}


