import 'package:counter_spell_new/core.dart';


class PanelGameExtras extends StatelessWidget {

  const PanelGameExtras(this.arenaOpener);

  final VoidCallback arenaOpener;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);

    return RowOfExtraButtons(
      children: <Widget>[
        ExtraButton(
          icon: McIcons.dice_multiple,
          text: "Random",
          onTap: () => stage.showAlert(DiceThrower(), size: DiceThrower.height),
          forceExternalSize: true,
        ),
        bloc.payments.unlocked.build((_, unlocked) => ExtraButton(
          icon: McIcons.license,
          text: "Leaderboards",
          onTap: () {
            if(unlocked){
              stage.showAlert(const Leaderboards(), size: Leaderboards.height);
            } else {
              stage.showAlert(const SupportAlert(), size: SupportAlert.height);
            }
          },
          forceExternalSize: true,
        ),),
        ExtraButton(
          icon: CSIcons.simpleViewIcon,
          iconSize: CSIcons.ideal_counterspell_size,
          iconPadding: CSIcons.ideal_counterspell_padding,
          text: "Arena Mode",
          onTap: arenaOpener,
          forceExternalSize: true,
        ),
      ]
    );


  }
}


