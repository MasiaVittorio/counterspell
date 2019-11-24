import 'package:counter_spell_new/core.dart';
import 'player_details_components/all.dart';

enum _DetailsPage {
  info,
  commander,
}

class PlayerDetails extends StatefulWidget {
  final int index;
  final double aspectRatio;
  const PlayerDetails(this.index, this.aspectRatio);

  static const double height = 360.0 +56/2 +56.0;

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

    final Map<_DetailsPage, Widget> pages = {
      _DetailsPage.info: PlayerDetailsInfo(widget.index, aspectRatio: widget.aspectRatio),
      _DetailsPage.commander: PlayerDetailsDamage(widget.index),
    };

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          bottom: CSConstants.barSize,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              for(final p in _DetailsPage.values)
                Positioned.fill(child:AnimatedPresented(
                  duration: const Duration(milliseconds: 215),
                  presented: p == page,
                  curve: Curves.fastOutSlowIn.flipped,
                  presentMode: PresentMode.slide,
                  child: pages[p] ?? Container(),
                )),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          height: CSConstants.barSize,
          child: UpShadower(
            child: RadioNavBar(
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
                _DetailsPage.commander : RadioNavBarItem(
                  title: "Commander",
                  icon: CSTypesUI.damageIconFilled,
                  unselectedIcon: CSTypesUI.damageIconOutlined,
                ),
                // _DetailsPage.attack : RadioNavBarItem(
                //   title: "Attack",
                //   icon: CSTypesUI.attackIconTwo,
                //   unselectedIcon: CSTypesUI.attackIconOne,
                // ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
