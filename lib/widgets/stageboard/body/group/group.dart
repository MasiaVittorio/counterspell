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

    // Apparently, having BlocVar.build7() have the effect of the builder being called twice as many times.
    // Meh... Will have to look into StreamBuilder :/

    // Also, finishing a scroll on the panel makes some of these rebuild lol, wtf
    return bloc.scroller.isScrolling.build((_, isScrolling) 
      => bloc.scroller.intValue.build((_, increment) 
      => actionBloc.selected.build((_, selected) 
      => actionBloc.attackingPlayer.build((_, attackingPlayer) 
      => actionBloc.defendingPlayer.build((_, defendingPlayer) 
      => actionBloc.counterSet.build((_, counter) 
      => bloc.game.gameState.gameState.build((_, gameState) {

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
          minValue: settings.gameSettings.minValue.value,
          maxValue: settings.gameSettings.maxValue.value,
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
              first: ([
                names.first,
                if(landScape && names.length >= 2) names[1],
              ].contains(name)) ? true : false,
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

        return bloc.themer.flatDesign.build((context, flat){
          
          final List<Widget> realChildren = landScape 
            ? [
              for(final couple in partition(children,2))
                Row(children: (){
                  final cpl = <Widget>[
                    Expanded(child: couple[0]),
                    if(couple.length == 2)
                      Expanded(child: couple[1],)
                  ];
                  if(flat) return cpl.separateWith(PlayerTile.flatPaddingX);
                  else return cpl;
                }() ),
            ] : children; 

          
          return Padding(
            padding: flat
              ? const EdgeInsets.symmetric(horizontal: PlayerTile.flatPadding)
              : EdgeInsets.zero,
            child: Column(children: flat 
              ? realChildren.separateWith(
                PlayerTile.flatPaddingY, 
                alsoFirstAndLast: true,
              ) 
              : realChildren,
            ),
          );
        },);

      },),),),),),),
    );
  }

}