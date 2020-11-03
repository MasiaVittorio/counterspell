import 'package:counter_spell_new/core.dart';

class CurrentStateTile extends StatelessWidget {
  final List<String> names;
  final double tileSize;
  final Map<String, Counter> counters;
  final int stateIndex;
  final GameState gameState;
  final Color defenceColor;
  final Map<CSPage,Color> pagesColor;

  const CurrentStateTile(this.gameState, this.stateIndex,{
    @required this.names,
    @required this.tileSize,
    @required this.defenceColor,
    @required this.counters,
    @required this.pagesColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Material(
        elevation: 4,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CSBloc.of(context).themer.flatDesign.build((context, flat) 
          => Column(children: CSSizes.separateColumn(flat, <Widget>[
            for(final name in names)
              CurrentStatePlayerTile(
                gameState, 
                stateIndex,
                name: name,
                pagesColor: pagesColor,
                tileSize: tileSize,  
                counters: counters,
                defenceColor: defenceColor,
              ),
          ],),),
        ),
      ),
    );

  }
}

class CurrentStatePlayerTile extends StatelessWidget {
  final String name;
  final int stateIndex;
  final GameState gameState;
  final double tileSize;
  final Color defenceColor;
  final Map<String, Counter> counters;
  final Map<CSPage,Color> pagesColor;

  const CurrentStatePlayerTile(this.gameState, this.stateIndex, {
    @required this.name,
    @required this.tileSize,
    @required this.defenceColor,
    @required this.pagesColor,
    @required this.counters,
  });

  @override
  Widget build(BuildContext context) {
    final PlayerState playerState = gameState.players[name].states[stateIndex];
    final double width = CSSizes.minTileSize;

    return Container(
      height: tileSize,
      width: width,
      alignment: Alignment.center,
      child: SizedBox(
        height: CSSizes.minTileSize,
        width: width,
        child: Stack(children: <Widget>[
          //for now there is just the life here in the center
          //we'll need an adaptive layout given the enabled pages (commander / counters)
          //and the enabled counters themselves
          Center(
            child: PieceOfInformation(
              damageType: DamageType.life,
              value: playerState.life,
              pagesColor: pagesColor,
              defenceColor: defenceColor,
            ),
          ),
          // for other counters, just sum up to the counters that are present in the map,
          // this way you won't count disabled counters 
        ]),
      ),
    );
  }
}

class PieceOfInformation extends StatelessWidget {
  final DamageType damageType;
  final bool attacking;
  final int value;
  final Color defenceColor;
  final Map<CSPage,Color> pagesColor;

  PieceOfInformation({
    @required this.pagesColor,
    @required this.damageType,
    @required this.value,
    @required this.defenceColor,
    this.attacking,
  }): assert(!(
    damageType == DamageType.commanderDamage 
    && attacking == null
  ));

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    Color color;
    IconData icon;

    if(damageType == DamageType.commanderDamage){
      color = attacking ? pagesColor[CSPage.commanderDamage]: defenceColor;
      icon = attacking ? CSIcons.attackIconOne : CSIcons.defenceIconFilled;
    } else {
      color = pagesColor[CSPages.fromDamage(damageType)];
      icon = CSIcons.typeIconsFilled[damageType];
    }

    final littleDarker = themeData.colorScheme.onSurface.withOpacity(0.1); 
    color = Color.alphaBlend(littleDarker, color);

    return Container(
      decoration: BoxDecoration(
        color: littleDarker,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon, 
            color: color,
            size: 15,
          ),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}