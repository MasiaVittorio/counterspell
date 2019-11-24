import 'package:counter_spell_new/core.dart';
import 'utils.dart';

class PlayerDetailsInfo extends StatelessWidget {
  final int index;
  const PlayerDetailsInfo(this.index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = CSBloc.of(context);
    final stage = bloc.stage;
    final counters = bloc.game.gameAction.counterSet.list;
    final body2 = theme.textTheme.body2;
    return BlocVar.build2(
      stage.themeController.primaryColorsMap,
      bloc.game.gameGroup.havingPartnerB,
      builder: (_, colors, partners)
        => PlayerBuilder(index, (gameState, names, name, playerState, player){

          final bool partner = partners[name] ?? false;
          return Column(
            children: <Widget>[
              Section([
                AlertTitle("$name's details", centered: false,),
                for(final couple in partition(<Widget>[

                  ListTile(
                    title: Text(CSPages.shortTitleOf(CSPage.life)),
                    trailing: Text("${playerState.life}", style: body2,),
                    leading: Icon(CSTypesUI.lifeIconFilled,color: colors[CSPage.life],),
                    onTap: () => DetailsUtils.insertLife(stage, name, bloc, playerState, names),
                  ),

                  ListTile(
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)}${partner?" (A)":""}"),
                    trailing: Text("${playerState.cast.a}", style: body2,),
                    leading: Icon(
                      CSTypesUI.castIconFilled, 
                      color: colors[CSPage.commanderCast],
                    ),
                    onTap: () => DetailsUtils.insertCast(partner, false, stage, name, bloc, playerState, names),
                  ),

                  if(partner)
                  ListTile(
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)} (B)"),
                    trailing: Text("${playerState.cast.b}", style: body2,),
                    leading: Icon(
                      CSTypesUI.castIconFilled, 
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
                    for(final element in couple)
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
              ], last: true,),

              ListTile(
                title: Text(partner ? "Two partners" : "One commander"),
                leading: Icon(partner ? McIcons.account_multiple_outline :McIcons.account_outline),
                trailing: FlatButton.icon(
                  label: Text(partner ? "Merge" : "Split"),
                  icon: Icon(Icons.exit_to_app),
                  onPressed: (){
                    bloc.game.gameGroup.havingPartnerB.value[name] = !partner;
                    bloc.game.gameGroup.havingPartnerB.refresh();
                  },
                ),
              ),

              Section([
                const SectionTitle("Edit"),
                if(partner)
                  ...[
                    _CommanderTile(this.index, a: true, havePartner: true,),
                    _CommanderTile(this.index, a: false,havePartner: true,),
                  ]
                else _CommanderTile(this.index, a: true,),
                ListTile(
                  title: Text("Rename $name"),
                  leading: const Icon(McIcons.pencil_outline),
                  onTap: () => DetailsUtils.renamePlayer(stage, name, bloc, names),
                ),
              ]),
              ListTile(
                title: Text("Delete $name", style: TextStyle(color: DELETE_COLOR),),
                leading: const Icon(McIcons.delete_forever, color: DELETE_COLOR,),
                onTap: () => DetailsUtils.deletePlayer(stage, name, bloc, names),
              ),
            ],
          );
        },),
    );
  }
}

class _CommanderTile extends StatelessWidget {
  final bool a;
  final bool havePartner;
  final int index;

  const _CommanderTile(this.index, {@required this.a, this.havePartner = false});  

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;


    return group.names.build((_, names){
      final name = names[index];
        
      final VoidCallback callback = () => Stage.of(context).showAlert(ImageSearch(
        (found){
          group.cards(a).value[name] = found;
          group.cards(a).refresh();
          group.savedCards.privateValue[name] = (group.savedCards.privateValue[name] ?? <MtgCard>{})..add(found);
          group.savedCards.forceWrite();
        }, 
        searchableCache: <MtgCard>{
          for(final single in group.savedCards.value.values)
            ...single,
        },
        readyCache: group.savedCards.value[name],
      ), size: ImageSearch.height);

      return group.cards(a).build((_,cards) {
        final card = cards[name];
        if(card == null) {
          return ListTile(
            title: Text(havePartner
              ? a ? "First partner image" : "Second Partner Image"
              : "Commander image"),
            leading: const Icon(McIcons.cards_outline),
            subtitle: const Text("None"),
            onTap: callback,
          );
        } else {
          return CardTile(
            card,
            autoClose: false,
            callback: (_) => callback(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.vertical_align_center),
                ),
                IconButton(
                  onPressed: () {
                    group.cards(a).value.remove(name);
                    group.cards(a).refresh();
                  },
                  icon: const Icon(Icons.delete_outline, color: DELETE_COLOR,),
                ),
              ],
            ),
          );
        }
      });
    });
  }
}