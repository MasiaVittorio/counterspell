import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';
import 'components/all.dart';

enum ArenaMenuPage{
  game,
  layout,
  settings,
}

class ArenaMenu extends StatelessWidget {

  const ArenaMenu({
    @required this.names,
    @required this.reorderPlayers,
    @required this.exit,
    @required this.close,
    @required this.height,
    @required this.layoutType,
    @required this.flipped,
    @required this.positions,
  });

  final List<String> names;
  final double height;
  final VoidCallback reorderPlayers;
  final VoidCallback exit;
  final VoidCallback close;
  final ArenaLayoutType layoutType;
  final Map<ArenaLayoutType,bool> flipped;
  final Map<int,String> positions;

  @override
  Widget build(BuildContext context) {
 
    return RadioHeaderedAlert<ArenaMenuPage>(
      withoutHeader: true,
      initialValue: ArenaMenuPage.game,
      customScrollPhysics: SidereusScrollPhysics(
        topBounce: true,
        topBounceCallback: () => SchedulerBinding.instance.addPostFrameCallback((_) {
          close();
        }),
        alwaysScrollable: true,
        neverScrollable: false,
      ),
      orderedValues: [
        ArenaMenuPage.game,
        ArenaMenuPage.layout,
        ArenaMenuPage.settings,
      ],
      items: <ArenaMenuPage,RadioHeaderedItem>{
        ArenaMenuPage.game: RadioHeaderedItem(
          longTitle: "Game options", 
          child: ArenaMenuActions(
            close: close,
            exit: exit,
            reorderPlayers: reorderPlayers,
            names: names,
          ), 
          icon: Icons.menu,
          title: "Game"
        ),
        ArenaMenuPage.layout: RadioHeaderedItem(
          longTitle: "Layout Picker", 
          child: ArenaMenuLayout(
            height: height,
            names: names,
            layoutType: layoutType,
            positions: positions,
            flipped: flipped,
          ), 
          icon: McIcons.view_compact,
          unselectedIcon: McIcons.view_compact_outline,
          // icon: McIcons.view_dashboard,
          // unselectedIcon: McIcons.view_dashboard_outline,
          title: "Layout"
        ),

        ArenaMenuPage.settings: RadioHeaderedItem(
          longTitle: "Arena settings", 
          child: ArenaMenuSettings(
            players: names.length,
          ), 
          icon: McIcons.cog,
          unselectedIcon: McIcons.cog_outline,
          title: "Settings"
        ),
      },
    );
  }
}






