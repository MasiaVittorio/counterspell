import 'package:counter_spell_new/core.dart';


class ArenaMenu extends StatelessWidget {

  const ArenaMenu({
    @required this.gameState,
    @required this.squadLayout,
    @required this.reorderPlayers,
    @required this.exit,
    @required this.close,
  });

  final GameState gameState;
  final bool squadLayout;
  final VoidCallback reorderPlayers;
  final VoidCallback exit;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: SidereusScrollPhysics(
        topBounce: true,
        topBounceCallback: close,
        alwaysScrollable: true,
        neverScrollable: false,
      ),
      children: <Widget>[
        if(gameState.players.length != 2)
          Section(<Widget>[
            const AlertTitle("Actions"),
            ArenaActions(reorderPlayers, exit),
          ]),
        Section(<Widget>[
          const SectionTitle("Layout"),
          ArenaLayoutSelector(squadLayout),
        ],),
        const Section(<Widget>[
          SectionTitle("Settings"),
          ArenaFullScreenToggle(true),
          ArenaVerticalScrollToggle(),
          ArenaHideNamesWithImageToggle(),
        ],),
        const SectionTitle("Info"),
        const ArenaInfo(),
      ],
    );
  }
}

class ArenaInfo extends StatelessWidget {
  const ArenaInfo();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 14.0),
      child: Text(_info),
    );
  }

  static const String _info = "Long press on a player to enter commander damage mode. That player will be the attacker. Scroll on another player to deal commander damage. Once you tap on another player you will exit commander damage mode.";
}

class ArenaActions extends StatelessWidget {

  ArenaActions(this.reorderPlayers, this.exit);
  final VoidCallback reorderPlayers;
  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 10.0),
      child: Row(children: <Widget>[
        Expanded(child: ExtraButton(
          text: "Reorder players",
          icon: McIcons.account_group_outline,
          onTap: reorderPlayers,
        )),
        Expanded(child: ExtraButton(
          text: "Exit Arena mode",
          icon: Icons.close,
          onTap: exit,
        )),
      ].separateWith(CSWidgets.extraButtonsDivider)),
    );
  }
}

class ArenaLayoutSelector extends StatelessWidget {

  ArenaLayoutSelector(this.squadLayout);
  final bool squadLayout;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    return RadioSlider(
      selectedIndex: squadLayout ? 0 : 1,
      onTap: (i) => settings.arenaSquadLayout.set(i==0),
      items: [
        RadioSliderItem(
          icon: Icon(McIcons.account_multiple_outline),
          title: Text("Squad"),
        ),
        RadioSliderItem(
          icon: Icon(McIcons.account_outline),
          title: Text("Free for all"),
        ),
      ],
    );
  }
}