import 'package:counter_spell_new/structure/pages.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage_board/stage_board.dart';

const Set<CSPage> disablablePages = const {
  CSPage.commanderDamage, 
  CSPage.commanderCast, 
  CSPage.counters,
};

class PanelGame extends StatelessWidget {
  const PanelGame();

  @override
  Widget build(BuildContext context) {
    final stageBoard = StageBoard.of(context);
    final pagesController = stageBoard.pagesController;
    final pageThemes = pagesController.pagesData;
    final enabledPages = pagesController.enabledPages;
    return ListView(
      physics: stageBoard.scrollPhysics,
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        Section([
          SectionTitle("Enabled Screens"),
          for(final page in disablablePages)
            SwitchListTile(
              title: Text(pageThemes[page].longName),
              value: enabledPages[page],
              onChanged: (_) => pagesController.togglePage(page),
              secondary: Icon(pageThemes[page].icon),
            ),
        ]),
      ],
    );
  }
}