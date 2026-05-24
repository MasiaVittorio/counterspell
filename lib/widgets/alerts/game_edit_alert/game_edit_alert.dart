import 'package:counter_spell/widgets/alerts/game_edit_alert/arena_layout_edit_tile.dart';
import 'package:counter_spell/widgets/alerts/game_edit_alert/history_tile.dart';
import 'package:counter_spell/widgets/arena/components/arena_direction_slider.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/game_page.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class GameEditAlert extends StatelessWidget {
  const GameEditAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return PanelList.shrink(
      title: const Text('Game options'),
      children: [
        ...[
          const EditPlaygroupTile(),
          const EditComandersTile(),
          const HistoryTile(),
        ].groupedCards(),
        const NewGameCta(replaceAlert: true),
        const SectionTitle(
          title: Text('User interface'),
          leading: Icon(Icons.layers_outlined),
        ),
        ...[
          const ArenaDirectionToggle(),
          const ArenaLayoutEditTile(),
        ].groupedCards(),
      ],
    );
  }
}
