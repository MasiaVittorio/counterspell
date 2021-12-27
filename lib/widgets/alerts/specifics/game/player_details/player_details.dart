import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

enum PlayerDetailsPage {
  commanderSettings,
  info,
  commanderDamage,
}

class PlayerDetails extends StatelessWidget {
  final int index;
  final double aspectRatio;

  const PlayerDetails(this.index, this.aspectRatio);

  static const double height = 500.0;

  String get pageKey => "playerDetailsAlert$index";

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final stage = Stage.of(context);
    final groupBloc = bloc.game!.gameGroup;

    return groupBloc.names.build((_, names) 
      => RadioHeaderedAlert<PlayerDetailsPage>(
        initialValue: stage!.panelController.alertController.savedStates[pageKey] ?? PlayerDetailsPage.info,
        onPageChanged: (p) => stage.panelController.alertController.savedStates[pageKey] = p,
        orderedValues: PlayerDetailsPage.values,
        items: <PlayerDetailsPage,RadioHeaderedItem>{
          PlayerDetailsPage.info: RadioHeaderedItem(
            longTitle: "${names[index]}'s details",
            child: PlayerDetailsInfo(index),
            title: "Details",
            icon: Icons.person,
            unselectedIcon: Icons.person_outline,
          ),
          PlayerDetailsPage.commanderDamage: RadioHeaderedItem(
            longTitle: "Damage taken & dealt by ${names[index]}",
            child: PlayerDetailsDamage(index),
            title: "Damage",
            icon: CSIcons.attackOne,
          ),
          PlayerDetailsPage.commanderSettings: RadioHeaderedItem(
            longTitle: "${names[index]}'s commander settings",
            child: PlayerDetailsCommanderSettings(index, aspectRatio: aspectRatio,),
            title: "Settings",
            icon: CSIcons.damageFilled,
            unselectedIcon: CSIcons.damageOutlined,
          ),
        },
      ),
    );
  }

}
