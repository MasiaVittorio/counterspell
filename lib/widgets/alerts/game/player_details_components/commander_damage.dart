import 'package:counter_spell_new/core.dart';
import 'utils.dart';


class PlayerDetailsDamage extends StatelessWidget {
  final int index;
  const PlayerDetailsDamage(this.index);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final CSBloc bloc = CSBloc.of(context);
    final StageData<CSPage,SettingsPage> stage = bloc.stage;
    final CSGame gameBloc = bloc.game;
    final CSGameGroup groupBloc = gameBloc.gameGroup;
    final CSGameState stateBloc = gameBloc.gameState;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: BlocVar.build5(
        bloc.themer.defenceColor,
        stage.themeController.primaryColorsMap,
        bloc.game.gameGroup.havingPartnerB,
        groupBloc.names,
        stateBloc.gameState,
        builder: (_, Color defenceColor, Map<CSPage,Color> colors, Map<String,bool> partners, List<String> names, GameState gameState){
          final String name = names[index];
          final Color attackColor = colors[CSPage.commanderDamage];
          final Player player = gameState.players[name];
          final PlayerState playerState = player.states.last;

          return Column(mainAxisSize: MainAxisSize.min, children:<Widget>[
            for(final otherName in names)
              Section([
                SectionTitle(otherName == name ? "$otherName (yourself)": otherName),
                if(partners[name] ?? false)
                  ListTile(
                    title: Text("Dealt to ${otherName == name ? "yourself" : otherName}"),
                    subtitle: const Text("Partners"),
                    leading: Icon(CSIcons.attackIconTwo, color: attackColor,),
                    trailing: Text(
                      "A: ${gameState.players[otherName].states.last.damages[name].a} // B: ${gameState.players[otherName].states.last.damages[name].b}", 
                      style: textTheme.body2.copyWith(color: attackColor),
                    ),
                    onTap:() => DetailsUtils.partnerDamage(stage, name, otherName, bloc, gameState),
                  )
                else 
                  ListTile(
                    title: Text("Dealt to ${otherName == name ? "yourself" : otherName}"),
                    leading: Icon(CSIcons.attackIconOne, color: attackColor,),
                    trailing: Text(
                      "${gameState.players[otherName].states.last.damages[name].a}", 
                      style: textTheme.body2.copyWith(color: attackColor),
                    ),
                    onTap:() => DetailsUtils.insertDamage(false, false, stage, name, otherName, bloc, gameState),
                  ),

                if(otherName != name)...[

                  if(partners[otherName] ?? false)
                      ListTile(
                        title: Text("Taken from ${otherName == name ? "yourself" : otherName}"),
                        subtitle: const Text("partners"),
                        leading: Icon(CSIcons.defenceIconFilled, color: defenceColor,),
                        trailing: Text(
                          "A: ${playerState.damages[otherName].a} // B: ${playerState.damages[otherName].b}", 
                          style: textTheme.body2.copyWith(color: defenceColor),
                        ),
                        onTap:() => DetailsUtils.partnerDamage(stage, otherName, name, bloc, gameState),
                      )
                  else 
                    ListTile(
                      title: Text("Taken from ${otherName == name ? "yourself" : otherName}"),
                      leading: Icon(CSIcons.defenceIconFilled, color: defenceColor,),
                      trailing: Text(
                        "${playerState.damages[otherName].a}", 
                        style: textTheme.body2.copyWith(color: defenceColor),
                      ),
                      onTap:() => DetailsUtils.insertDamage(false, false, stage, otherName, name, bloc, gameState),
                    ),
                ]
              ]),
          ]);
        },
      ),
    );
  }
}
