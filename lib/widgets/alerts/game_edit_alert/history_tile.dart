import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/alerts/history_alert.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final panelFrame = context.panelFrame;
    final counterSpell = context.counterSpell;
    return UsesArenaViewBuilder(
      builder: (context, usesArenaView, child) => ColoredTile(
        title: const Text('History page'),
        subtitle: const Text('Check recent actions'),
        onTap: () {
          if (usesArenaView) {
            panelFrame.showAlert(const HistoryAlert());
          } else {
            panelFrame.closePanel();
            counterSpell.pagesLogic.bodyPage.update(BodyPage.history);
          }
        },
        leading: Icon(BodyPage.history.outlinedIcon),
      ),
    );
  }
}
