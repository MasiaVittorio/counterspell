import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/collapsed_panel/center/undo_redo_row.dart';
import 'package:flutter/material.dart';

class CollapsedPanelCenter extends StatelessWidget {
  const CollapsedPanelCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final generalIncrement2 = counterSpell.interactionLogic.generalIncrement;
    return generalIncrement2.build((context, increment) {
      if (increment == 0) return const UndoRedoRow();
      return counterSpell.pagesLogic.bodyPage.build(
        (context, page) => Text(switch ((page, increment >= 0)) {
          (BodyPage.counters, true) => 'Adding: $increment',
          (BodyPage.counters, false) => 'Removing: $increment',
          (BodyPage.life, true) => 'Gaining: $increment',
          (BodyPage.life, false) => 'Dealing: $increment',
          (BodyPage.damage, true) => 'Dealing: $increment',
          (BodyPage.damage, false) => 'Reducing: $increment',
          (BodyPage.cast, true) => 'Casting: $increment',
          (BodyPage.cast, false) => 'Un-casting: $increment',
          (BodyPage.history, _) => 'Dragging: $increment',
        }),
      );
    });
  }
}
