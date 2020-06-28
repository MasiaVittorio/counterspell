import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';


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
        topBounceCallback: () => SchedulerBinding.instance.addPostFrameCallback((_) {
          close();
        }),
        alwaysScrollable: true,
        neverScrollable: false,
      ),
      children: <Widget>[
        Section(<Widget>[
          const AlertDrag(),
          // const PanelTitle("Actions"),
          ArenaActions(reorderPlayers, exit),
          CSWidgets.divider,
          _Restarter(close),
        ]),
        if(gameState.players.length > 2) // for two players there is only one layout
          Section(<Widget>[
            const SectionTitle("Layout"),
            ArenaLayoutSelector(squadLayout),
          ],),

        const Section(<Widget>[
          SectionTitle("Gestures"),
          Gestures(),
        ],),

        const Section(<Widget>[
          SectionTitle("Appearance"),
          ArenaFullScreenToggle(true),
          ArenaHideNamesWithImageToggle(),
          ArenaOpacity(),
        ],),

      ],
    );
  }
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

class _Restarter extends StatelessWidget {

  const _Restarter(this.closeMenu);
  final VoidCallback closeMenu;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final state = bloc.game.gameState;

    return ConfirmableTile(
      onConfirm: (){
        state.restart(false, avoidPrompt: true);
        closeMenu?.call();
      },
      leading: Icon(McIcons.restart),
      titleBuilder: (_,__) => Text("New game"),
      subTitleBuilder: (_, pressed) => AnimatedText(pressed ? "Confirm?" : "Start fresh"),
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
      onTap: (i) => settings.arenaSettings.squadLayout.set(i==0),
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

class ArenaOpacity extends StatelessWidget {
  const ArenaOpacity();
  @override
  Widget build(BuildContext context) {
    final opacity = CSBloc.of(context).settings.imagesSettings.arenaImageOpacity;
    return opacity.build((_,value) => FullSlider(
      value: value,
      divisions: 20,
      leading: Icon(Icons.opacity),
      onChanged: opacity.set,
      defaultValue: CSSettingsImages.defaultSimpleImageOpacity,
      titleBuilder: (val) => Text("Opacity: ${val.toStringAsFixed(2)}"),
    ));
  }
}