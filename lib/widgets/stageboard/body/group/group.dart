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
  final CSPage currentPage;
  final Map<CSPage,Color> pageColors;
  
  const BodyGroup(this.names,{
    @required this.bottom,
    @required this.currentPage,
    @required this.maxWidth,
    @required this.pageColors,
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
    print("build group");

    return bloc.scroller.isScrolling.build((_, isScrolling) 
      => bloc.scroller.intValue.build((_, increment) 
      => actionBloc.selected.build((_, selected) 
      => actionBloc.attackingPlayer.build((_, attackingPlayer) 
      => actionBloc.defendingPlayer.build((_, defendingPlayer) 
      => actionBloc.counterSet.build((_, counter) 
      => bloc.game.gameState.gameState.build((_, gameState) {
        print("build group 7 bloc vars");

        final normalizedPlayerActions = CSGameAction.normalizedAction(
          pageValue: currentPage,
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
              pageColor: pageColors[currentPage],
              maxWidth: maxWidth,
              increment: increment,
              defenceColor: defenceColor,
              tileSize: tileSize,
              bottom: ([
                names.last,
                if(landScape && names.length.isEven) names[names.length-2],
              ].contains(name)) ? bottom : 0.0,
              coreTileSize: coreTileSize,
              page: currentPage,
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

      },),),),),),),
    );
  }

}