import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/layouts_picker/arena_layouts_view.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class ArenaLayoutEditTile extends StatelessWidget {
  const ArenaLayoutEditTile({super.key, this.beforeAction});

  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final panelFrame = context.panelFrame;
    return ColoredTile(
      title: const Text('Edit layout'),
      subtitle: const Text('Change seat positions and swap players'),
      leading: const Icon(Icons.view_quilt_outlined),
      onTap: () {
        beforeAction?.call();
        final n = counterSpell
            .gameLogic
            .gameReactive
            .value
            .currentState
            .playerStates
            .length;
        panelFrame.showAlert(
          ArenaLayoutsView(
            filterForPlayerCount: counterSpell
                .gameLogic
                .gameReactive
                .value
                .currentState
                .playerStates
                .length,
            initialMode:
                counterSpell.arenaLogic.preferredLayouts.value[n] ??
                ArenaLayoutMode.defaultMode(n),
          ),
        );
      },
    );
  }
}
