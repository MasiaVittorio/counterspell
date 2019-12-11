import 'package:counter_spell_new/core.dart';
import 'player_details_components/all.dart';

enum _DetailsPage {
  commanderSettings,
  info,
  commanderDamage,
}

class PlayerDetails extends StatefulWidget {
  final int index;
  final double aspectRatio;

  const PlayerDetails(this.index, this.aspectRatio);

  static const double height = 500.0;

  @override
  _PlayerDetailsState createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {

  _DetailsPage page = _DetailsPage.info;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final groupBloc = bloc.game.gameGroup;

    return groupBloc.names.build((_, names) 
      => RadioHeaderedAlert<_DetailsPage>(
        selectedValue: page,
        orderedValues: _DetailsPage.values,
        onSelect: (p) => this.setState((){
          this.page = p;
        }),
        items: <_DetailsPage,RadioHeaderedItem>{
          _DetailsPage.info: RadioHeaderedItem(
            longTitle: "${names[widget.index]}'s details",
            child: PlayerDetailsInfo(widget.index),
            title: "Details",
            icon: Icons.person,
            unselectedIcon: Icons.person_outline,
          ),
          _DetailsPage.commanderDamage: RadioHeaderedItem(
            longTitle: "Damage taken & dealt by ${names[widget.index]}",
            child: PlayerDetailsDamage(widget.index),
            title: "Damage",
            icon: CSIcons.attackIconOne,
          ),
          _DetailsPage.commanderSettings: RadioHeaderedItem(
            longTitle: "${names[widget.index]}'s commander settings",
            child: PlayerDetailsCommanderSettings(widget.index, aspectRatio: widget.aspectRatio,),
            title: "Settings",
            icon: CSIcons.damageIconFilled,
            unselectedIcon: CSIcons.damageIconOutlined,
          ),
        },
      ),
    );
  }

}
