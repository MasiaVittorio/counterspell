import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';
import 'components/all.dart';

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

    return RadioHeaderedAlert<bool>(
      withoutHeader: true,
      initialValue: true, // true = game, false = settings
      customScrollPhysics: SidereusScrollPhysics(
        topBounce: true,
        topBounceCallback: () => SchedulerBinding.instance.addPostFrameCallback((_) {
          close();
        }),
        alwaysScrollable: true,
        neverScrollable: false,
      ),
      items: <bool,RadioHeaderedItem>{
        true: RadioHeaderedItem(
          longTitle: "Game options", 
          child: ArenaMenuActions(
            close: close,
            exit: exit,
            reorderPlayers: reorderPlayers,
            names: gameState.names,
          ), 
          icon: Icons.menu,
          title: "Game"
        ),

        false: RadioHeaderedItem(
          longTitle: "Arena settings", 
          child: ArenaMenuSettings(
            gameState: gameState,
            squadLayout: squadLayout,
          ), 
          icon: McIcons.settings,
          unselectedIcon: McIcons.settings_outline,
          title: "Settings"
        ),
     },
    );
  }
}






