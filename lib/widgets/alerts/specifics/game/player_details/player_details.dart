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

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final groupBloc = bloc.game.gameGroup;

    return groupBloc.names.build((_, names) 
      => RadioHeaderedAlert<PlayerDetailsPage>(
        initialValue: bloc.stageBloc.playerDetailsPage ?? PlayerDetailsPage.info,
        onPageChanged: (p) => bloc.stageBloc.playerDetailsPage = p,
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
            icon: CSIcons.attackIconOne,
          ),
          PlayerDetailsPage.commanderSettings: RadioHeaderedItem(
            longTitle: "${names[index]}'s commander settings",
            child: PlayerDetailsCommanderSettings(index, aspectRatio: aspectRatio,),
            title: "Settings",
            icon: CSIcons.damageIconFilled,
            unselectedIcon: CSIcons.damageIconOutlined,
          ),
        },
      ),
    );
  }

}
