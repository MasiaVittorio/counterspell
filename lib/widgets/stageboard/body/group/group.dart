import 'package:counter_spell_new/core.dart';

import 'player_tile.dart';

class BodyGroup extends StatelessWidget {
  final List<String> names;
  final int count;
  final double tileSize;
  final double coreTileSize;
  final CSGameGroup group;
  final Color defenceColor;
  final bool landScape;
  final double maxWidth;
  final double bottom;
  
  const BodyGroup(this.names,{
    @required this.bottom,
    @required this.maxWidth,
    @required this.defenceColor,
    @required this.count,
    @required this.group,
    @required this.tileSize,
    @required this.coreTileSize,
    @required this.landScape,
  });
  
  @override
  Widget build(BuildContext context) {

    final bloc = group.parent.parent;
    final actionBloc = bloc.game.gameAction;
    final settings = bloc.settings;
    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);

    return BlocVar.build2(
      stage.themeController.primaryColorsMap, 
      stage.pagesController.page,
      builder: (_, pageColors, page)
        =>BlocVar.build9(
          stage.themeController.primaryColorsMap, 
          stage.pagesController.page,
          bloc.scroller.isScrolling,
          bloc.scroller.intValue,
          actionBloc.selected,
          actionBloc.attackingPlayer,
          actionBloc.defendingPlayer,
          actionBloc.counterSet.variable,
          bloc.game.gameState.gameState,
          builder: (
            BuildContext context, 
            Map<CSPage,Color> pageColors, 
            CSPage page,
            bool isScrolling, 
            int increment,
            Map<String,bool> selected, 
            String attackingPlayer, 
            String defendingPlayer,
            Counter counter,
            GameState gameState,
          ) {

            final normalizedPlayerActions = CSGameAction.normalizedAction(
              pageValue: page,
              selectedValue: selected,
              gameState: gameState,
              scrollerValue: increment,
              attacker: attackingPlayer,
              defender: defendingPlayer,
              //these three values are so rarely updated that all the actual
              //reactive variables make this rebuild so often that min and max
              //will basically always be correct. no need to add 2 streambuilders
              minValue: settings.minValue.value,
              maxValue: settings.maxValue.value,
              counter: counter,
            ).actions(gameState.names);

            final children = <Widget>[
              for(final name in names)
                PlayerTile(
                  name, 
                  pageColor: pageColors[page],
                  maxWidth: maxWidth,
                  increment: increment,
                  defenceColor: defenceColor,
                  tileSize: tileSize,
                  bottom: ([
                    names.last,
                    if(landScape) names[names.length-2],
                  ].contains(name)) ? bottom : 0.0,
                  coreTileSize: coreTileSize,
                  page: page,
                  usingPartnerB: gameState.players[name].usePartnerB,
                  isAttackerUsingPartnerB: gameState.players[attackingPlayer]?.usePartnerB??false,
                  havingPartnerB: gameState.players[name].havePartnerB,
                  isAttackerHavingPartnerB: gameState.players[attackingPlayer]?.havePartnerB??false,
                  selected: selected[name],
                  whoIsAttacking: attackingPlayer,
                  whoIsDefending: defendingPlayer,
                  isScrollingSomewhere: isScrolling,
                  counter: counter,
                  playerState: gameState.players[name].states.last,
                  normalizedPlayerAction: normalizedPlayerActions[name],
                ),
            ];

            return Material(
              elevation: 8,
              child: Column(children: landScape 
                ? [
                  for(final couple in partition(children,2))
                    Row(children: <Widget>[
                      Expanded(child: couple[0]),
                      if(couple.length == 2)
                        Expanded(child: couple[1],)
                    ],),
                ] : children,
              ),
            );

          },
        ),
    );
  }

}