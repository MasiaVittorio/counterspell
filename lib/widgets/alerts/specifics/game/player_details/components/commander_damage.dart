import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/core.dart';

import 'utils.dart';

class PlayerDetailsDamage extends StatelessWidget {
  final int index;
  const PlayerDetailsDamage(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final CSBloc bloc = CSBloc.of(context);
    final StageData<CSPage, SettingsPage> stage = bloc.stage;
    final CSGame gameBloc = bloc.game;
    final CSGameGroup groupBloc = gameBloc.gameGroup;
    final CSGameState stateBloc = gameBloc.gameState;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: bloc.themer.buildFromDefenceColor(
        (_, defenseColor) => BlocVar.build5<Map<CSPage, Color>?, List<String>,
            GameState, Map<String, MtgCard>, Map<String, MtgCard>>(
          stage.themeController.derived.mainPageToPrimaryColor,
          groupBloc.orderedNames,
          stateBloc.gameState,
          groupBloc.cardsA,
          groupBloc.cardsB,
          builder: (
            _,
            Map<CSPage, Color>? colors,
            List<String> names,
            GameState gameState,
            Map<String, MtgCard>? cardsA,
            Map<String, MtgCard>? cardsB,
          ) {
            final String name = names[index];
            final Color? attackColor = colors![CSPage.commanderDamage];
            final Player player = gameState.players[name]!;
            final PlayerState playerState = player.states.last;

            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              for (final otherName in names)
                Section([
                  Row(
                    children: <Widget>[
                      ...() {
                        final otherPlayer = gameState.players[otherName]!;
                        final card = otherPlayer.usePartnerB
                            ? cardsB![otherName]
                            : cardsA![otherName];
                        if (card == null) return [];
                        return [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(card.imageUrl()!),
                              radius: 12,
                            ),
                          )
                        ];
                      }(),
                      Expanded(
                          child: SectionTitle(otherName == name
                              ? "$otherName (yourself)"
                              : otherName)),
                    ],
                  ),
                  if (player.havePartnerB)
                    ListTile(
                      title: Text(
                          "Dealt to ${otherName == name ? "yourself" : otherName}"),
                      subtitle: const Text("Partners"),
                      leading: Icon(
                        CSIcons.attackTwo,
                        color: attackColor,
                      ),
                      trailing: Text(
                        "A: ${gameState.players[otherName]!.states.last.damages[name]!.a} // B: ${gameState.players[otherName]!.states.last.damages[name]!.b}",
                        style:
                            textTheme.bodyLarge!.copyWith(color: attackColor),
                      ),
                      onTap: () => DetailsUtils.partnerDamage(
                          stage, name, otherName, bloc, gameState),
                    )
                  else
                    ListTile(
                      title: Text(
                          "Dealt to ${otherName == name ? "yourself" : otherName}"),
                      leading: Icon(
                        CSIcons.attackOne,
                        color: attackColor,
                      ),
                      trailing: Text(
                        "${gameState.players[otherName]!.states.last.damages[name]!.a}",
                        style:
                            textTheme.bodyLarge!.copyWith(color: attackColor),
                      ),
                      onTap: () => DetailsUtils.insertDamage(false, false,
                          stage, name, otherName, bloc, gameState),
                    ),
                  if (otherName != name) ...[
                    if (gameState.players[otherName]!.havePartnerB)
                      ListTile(
                        title: Text(
                            "Taken from ${otherName == name ? "yourself" : otherName}"),
                        subtitle: const Text("partners"),
                        leading: Icon(
                          CSIcons.defenceFilled,
                          color: defenseColor,
                        ),
                        trailing: Text(
                          "A: ${playerState.damages[otherName]!.a} // B: ${playerState.damages[otherName]!.b}",
                          style: textTheme.bodyLarge!
                              .copyWith(color: defenseColor),
                        ),
                        onTap: () => DetailsUtils.partnerDamage(
                            stage, otherName, name, bloc, gameState),
                      )
                    else
                      ListTile(
                        title: Text(
                            "Taken from ${otherName == name ? "yourself" : otherName}"),
                        leading: Icon(
                          CSIcons.defenceFilled,
                          color: defenseColor,
                        ),
                        trailing: Text(
                          "${playerState.damages[otherName]!.a}",
                          style: textTheme.bodyLarge!
                              .copyWith(color: defenseColor),
                        ),
                        onTap: () => DetailsUtils.insertDamage(false, false,
                            stage, otherName, name, bloc, gameState),
                      ),
                  ]
                ]),
            ]);
          },
        ),
      ),
    );
  }
}
