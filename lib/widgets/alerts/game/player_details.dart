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

  _DetailsPage page;
  @override
  void initState() {
    super.initState();
    this.page = _DetailsPage.info;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final groupBloc = bloc.game.gameGroup;

    return groupBloc.names.build((_, names) 
      => HeaderedAlert(
        <_DetailsPage,String>{
          _DetailsPage.info: "${names[widget.index]}'s details",
          _DetailsPage.commanderDamage: "Damage taken & dealt by ${names[widget.index]}",
          _DetailsPage.commanderSettings: "${names[widget.index]}'s commander settings",
        }[page],
        child: body,
        bottom: bottom,
        alreadyScrollableChild: true,
      ),
    );
  }

  Widget get body => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      for(final p in _DetailsPage.values)
        Positioned.fill(child:AnimatedPresented(
          duration: const Duration(milliseconds: 215),
          presented: p == page,
          curve: Curves.fastOutSlowIn.flipped,
          presentMode: PresentMode.slide,
          child: SingleChildScrollView(
            physics: Stage.of(context).panelScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: AlertTitle.height),
              child: <_DetailsPage,Widget>{
                _DetailsPage.info: PlayerDetailsInfo(widget.index),
                _DetailsPage.commanderDamage: PlayerDetailsDamage(widget.index),
                _DetailsPage.commanderSettings: PlayerDetailsCommanderSettings(widget.index, aspectRatio: widget.aspectRatio,),
              }[p],
            ),
          ),
        ),),
    ],
  );

  Widget get bottom => RadioNavBar(
    selectedValue: page,
    orderedValues: _DetailsPage.values,
    onSelect: (p)=>this.setState((){
      this.page = p;
    }),
    items: {
      _DetailsPage.info : RadioNavBarItem(
        title: "Info",
        icon: Icons.info,
        unselectedIcon: Icons.info_outline,
      ),
      _DetailsPage.commanderDamage : RadioNavBarItem(
        title: "Damage",
        icon: CSIcons.attackIconOne,
      ),
      _DetailsPage.commanderSettings : RadioNavBarItem(
        title: "Settings",
        icon: CSIcons.damageIconFilled,
        unselectedIcon: CSIcons.damageIconOutlined,
      ),
    },
  );
}
