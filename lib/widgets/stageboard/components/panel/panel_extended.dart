import 'package:counter_spell_new/structure/pages.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:sidereus/reusable_widgets/section.dart';

class CSPanelExtended extends StatelessWidget {
  const CSPanelExtended({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final stageBoard = StageBoard.of(context);
    final pagesController = stageBoard.pagesController;
    final pageThemes = pagesController.pageThemes;
    final enabledPages = pagesController.enabledPages;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: <Widget>[
          Section([
            SectionTitle("Screens"),
            for(final page in [CSPage.commander, CSPage.counters])
              SwitchListTile(
                title: Text(pageThemes[page].name),
                value: enabledPages[page],
                onChanged: (_) => pagesController.togglePage(page),
                secondary: Icon(pageThemes[page].icon),
              ),
          ]),
        ],
      ),
    ); //LOW PRIORITY: fai il pannello esteso
  }
}