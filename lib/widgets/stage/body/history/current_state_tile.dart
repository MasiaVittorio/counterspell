import 'package:counter_spell/core.dart';

class CurrentStateTile extends StatelessWidget {
  final List<String> names;
  final double? tileSize;
  final Map<String?, Counter> counters;
  final int stateIndex;
  final GameState gameState;
  final Color defenseColor;
  final Map<CSPage, Color> pagesColor;

  const CurrentStateTile(
    this.gameState,
    this.stateIndex, {
    super.key,
    required this.names,
    required this.tileSize,
    required this.defenseColor,
    required this.counters,
    required this.pagesColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logic = CSBloc.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: logic.themer.flatDesign.build(
        (context, flat) => Material(
          elevation: flat ? 0 : 4,
          color: flat ? theme.canvasColor : theme.scaffoldBackgroundColor,
          child: Column(
            children: CSSizes.separateColumn(
              flat,
              <Widget>[
                for (final name in names)
                  if (gameState.names.contains(name))
                    CurrentStatePlayerTile(
                      gameState,
                      // stateIndex,
                      name: name,
                      pagesColor: pagesColor,
                      tileSize: tileSize,
                      counters: counters,
                      defenseColor: defenseColor,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentStatePlayerTile extends StatelessWidget {
  final String name;
  // final int stateIndex;
  final GameState gameState;
  final double? tileSize;
  final Color defenseColor;
  final Map<String?, Counter> counters;
  final Map<CSPage, Color> pagesColor;

  const CurrentStatePlayerTile(
    this.gameState,
    // this.stateIndex,
    {
    super.key,
    required this.name,
    required this.tileSize,
    required this.defenseColor,
    required this.pagesColor,
    required this.counters,
  });

  @override
  Widget build(BuildContext context) {
    final PlayerState playerState = gameState.players[name]!.states.last;
    const double width = CSSizes.minTileSize;

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
              defenseColor: defenseColor,
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
  final bool? attacking;
  final int? value;
  final Color defenseColor;
  final Map<CSPage, Color> pagesColor;

  const PieceOfInformation({
    super.key,
    required this.pagesColor,
    required this.damageType,
    required this.value,
    required this.defenseColor,
    this.attacking,
  }) : assert(!(damageType == DamageType.commanderDamage && attacking == null));

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    Color? color;
    IconData? icon;

    if (damageType == DamageType.commanderDamage) {
      color = attacking! ? pagesColor[CSPage.commanderDamage] : defenseColor;
      icon = attacking! ? CSIcons.attackOne : CSIcons.defenceFilled;
    } else {
      color = pagesColor[CSPages.fromDamage(damageType)];
      icon = CSIcons.typeIconsFilled[damageType];
    }

    final littleDarker = themeData.colorScheme.onSurface.withValues(alpha: 0.1);
    color = Color.alphaBlend(littleDarker, color!);

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
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
