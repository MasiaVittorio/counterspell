import 'package:counter_spell_new/core.dart';


class PanelGameExtras extends StatelessWidget {

  const PanelGameExtras(this.arenaOpener);

  final VoidCallback arenaOpener;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final stage = Stage.of(context);

    return Section(<Widget>[
      const SectionTitle("Extras"),
      ExtraButtons(children: <Widget>[
        ExtraButton(
          icon: McIcons.dice_multiple,
          text: "Random",
          onTap: () => stage!.showAlert(DiceThrower(), size: DiceThrower.height),
          forceExternalSize: true,
        ),
        bloc.payments.unlocked.build((_, unlocked) => ExtraButton(
          icon: McIcons.license,
          text: "Leaderboards",
          onTap: () {
            if(unlocked){
              stage!.showAlert(const Leaderboards(), size: Leaderboards.height);
            } else {
              stage!.showAlert(const SupportAlert(), size: SupportAlert.height);
            }
          },
          forceExternalSize: true,
        ),),
        ExtraButton(
          icon: CSIcons.counterSpell,
          // iconSize: CSIcons.ideal_counterspell_size,
          // iconPadding: CSIcons.ideal_counterspell_padding,
          text: "Arena",
          onTap: arenaOpener,
          forceExternalSize: true,
        ),
      ],),

      SubSection(<Widget>[
        ExtraButtons(
          children: <Widget>[
            ExtraButton(
              icon: McIcons.restart,
              text: "New Game",
              onTap: () => stage!.showAlert(const RestarterAlert(GameRestartedFrom.menu), size: ConfirmAlert.height),
              customCircleColor: Colors.transparent,
            ),
            ExtraButton(
              icon: McIcons.account_multiple_outline,
              text: "Playgroup",
              onTap: () => stage!.showAlert(
                PlayGroupEditor(bloc, fromClosedPanel: false,), 
                size: PlayGroupEditor.sizeCalc(
                  bloc.game!.gameState!.gameState.value.players.length,
                ),
              ),
              customCircleColor: Colors.transparent,
            ),
          ],
          margin: EdgeInsets.zero,
        ),
      ],margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),),

      ListTile(
        title: const Text("Crazy specific stuff"),
        subtitle: const Text("Combo helpers and more"),
        leading: const Icon(ManaIcons.instant),
        onTap: () => stage!.showAlert(
          const CrazySpecificStuff(),
          size: CrazySpecificStuff.size, 
        )
      ),
    ],);

  }
}


