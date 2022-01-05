import 'package:counter_spell_new/core.dart';
import 'utils.dart';

class PlayerDetailsInfo extends StatelessWidget {
  final int index;
  const PlayerDetailsInfo(this.index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = CSBloc.of(context)!;
    final stage = bloc.stage;
    final counters = bloc.game.gameAction.counterSet.list;
    final body2 = theme.textTheme.bodyText1;
    return stage.themeController.derived.mainPageToPrimaryColor.build((_, colors)
        => PlayerBuilder(index, (gameState, names, name, playerState, player){

          final bool partner = player.havePartnerB!;

          return Column(
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[
              Section([
                const SectionTitle("Values"),
                for(final couple in partition(<Widget>[

                  ListTile(
                    title: Text(CSPages.shortTitleOf(CSPage.life)!),
                    trailing: Text("${playerState.life}", style: body2,),
                    leading: Icon(CSIcons.lifeFilled,color: colors![CSPage.life],),
                    onTap: () => DetailsUtils.insertLife(stage, name, bloc, playerState, names),
                  ),

                  ListTile(
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)}${partner?" (A)":""}"),
                    trailing: Text("${playerState.cast.a}", style: body2,),
                    leading: Icon(
                      CSIcons.castFilled, 
                      color: colors[CSPage.commanderCast],
                    ),
                    onTap: () => DetailsUtils.insertCast(partner, false, stage, name, bloc, playerState, names),
                  ),

                  if(partner)
                  ListTile(
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)} (B)"),
                    trailing: Text("${playerState.cast.b}", style: body2,),
                    leading: Icon(
                      CSIcons.castFilled, 
                      color: colors[CSPage.commanderCast],
                    ),
                    onTap: () => DetailsUtils.insertCast(partner, true, stage, name, bloc, playerState, names),
                  ),
                  for(final counter in counters)
                    ...(){
                      final value = playerState.counters[counter.longName];
                      if(value == 0) return []; 
                      return [
                        ListTile(
                          title: Text(counter.shortName),
                          leading: Icon(counter.icon, color: colors[CSPage.counters],),
                          trailing: Text("$value", style: body2,),
                          onTap: () => DetailsUtils.insertCounter(counter, stage, name, bloc, playerState, names),
                        ),
                      ];
                    }(),


                ], 2))
                  Row(children: <Widget>[
                    for(final element in couple!)
                      Expanded(child: element,)
                  ],)
              ]),

              Section([
                const SectionTitle("Total life"),
                Row(children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text("Gained"),
                      trailing: Text("${player.totalLifeGained}", style: body2,),
                      leading: Icon(Icons.favorite, color: colors[CSPage.life],),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Lost"),
                      trailing: Text("${player.totalLifeLost}", style: body2,),
                      leading: Icon(Icons.favorite_border, color: colors[CSPage.commanderDamage],),
                    ),
                  ),
                ],),
              ], last: true),

              ListTile(
                title: Text("Rename $name"),
                leading: const Icon(McIcons.pencil_outline),
                onTap: () => DetailsUtils.renamePlayer(stage, name, bloc, names),
              ),
              ListTile(
                title: Text("Delete $name", style: TextStyle(color: CSColors.delete),),
                leading: const Icon(McIcons.delete_forever, color: CSColors.delete,),
                onTap: () => DetailsUtils.deletePlayer(stage, name, bloc, names),
              ),
            ],
          );
        },),
    );
  }
}

