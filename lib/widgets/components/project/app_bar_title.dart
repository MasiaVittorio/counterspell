import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final pageVar = counterSpell.pagesLogic.bodyPage;
    final counterVar = counterSpell.interactionLogic.selectedCounter;
    final panelFrame = context.panelFrame;
    return panelFrame.buildWithIsTopBarExpanded(
      builder: (context, expanded) => (counterVar, pageVar).build(
        (context, counter, page) => AnimatedText(switch ((expanded, page)) {
          (true, _) => 'CounterSpell',
          (_, BodyPage.counters) => counter.longName,
          (_, final page) => page.longLabel,
        }),
      ),
    );
  }
}
