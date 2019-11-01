import 'package:counter_spell_new/core.dart';

class PlayerDetails extends StatelessWidget {
  final int index;
  const PlayerDetails(this.index);

  @override
  Widget build(BuildContext context) {
    // final bloc = CSBloc.of(context);
    // final stage = bloc.stage;

    return Container(
      
    );
  }
}

class _Info extends StatelessWidget {
  final int index;
  const _Info(this.index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = CSBloc.of(context);
    final stage = bloc.stage;
    final counters = bloc.game.gameAction.counterSet.list;

    return BlocVar.build2(
      stage.themeController.primaryColorsMap,
      bloc.game.gameGroup.havingPartnerB,
      builder: (_, colors, partners)
        => _PlayerBuilder(index, (player){
          final state = player.states.last;
          final partner = partners[player.name];
          return Column(
            children: <Widget>[
              Section([
                AlertTitle(player.name),
                for(final couple in partition(<Widget>[
                  ListTile(
                    dense: true,
                    title: Text(CSPages.shortTitleOf(CSPage.life)),
                    trailing: Text("${state.life}", style: theme.textTheme.body2,),
                    leading: Icon(
                      CSTypesUI.lifeIconFilled, 
                      color: colors[CSPage.life],
                    ),
                    onTap: () => stage.showAlert(InsertAlert(
                      inputType: TextInputType.number,
                      onConfirm: (string){
                        final int val = int.tryParse(string);
                        if(val != null){

                        }
                      },
                    ), alertSize: InsertAlert.height),
                  ),
                  ListTile(
                    dense: true,
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)}${partner?" (A)":""}"),
                    trailing: Text("${state.cast.a}", style: theme.textTheme.body2,),
                    leading: Icon(
                      CSTypesUI.castIconFilled, 
                      color: colors[CSPage.commanderCast],
                    ),
                  ),
                  if(partner)
                  ListTile(
                    dense: true,
                    title: Text("${CSPages.shortTitleOf(CSPage.commanderCast)} (B)"),
                    trailing: Text("${state.cast.b}", style: theme.textTheme.body2,),
                    leading: Icon(
                      CSTypesUI.castIconFilled, 
                      color: colors[CSPage.commanderCast],
                    ),
                  ),
                  for(final counter in counters)
                    ...(){
                      final value = state.counters[counter.longName];
                      if(value == 0) return []; 
                      return [
                        ListTile(
                          dense: true,
                          title: Text(counter.shortName),
                          leading: Icon(counter.icon, color: colors[CSPage.counters],),
                          trailing: Text("$value", style: theme.textTheme.body2,),
                        ),
                      ];
                    }(),
                ], 2))
                  Row(children: <Widget>[
                    for(final element in couple)
                      Expanded(child: element,)
                  ],)
              ]),
            ],
          );
        },),
    );
  }
}


class _PlayerBuilder extends StatelessWidget {
  final int index;
  final Widget Function(Player) builder;
  const _PlayerBuilder(this.index, this.builder);

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = bloc.stage;
    final gameBloc = bloc.game;
    final groupBloc = gameBloc.gameGroup;
    final stateBloc = gameBloc.gameState;
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: stage.panelScrollPhysics(),
        child: groupBloc.names.build((_, names){
          final name = names[index];
          return stateBloc.gameState.build((_, state){
            final player = state.players[name];
            return this.builder(player);
          },);
        },),
      ),
    );

  }
}