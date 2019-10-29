import 'package:counter_spell_new/widgets/stageboard/panel/extended_components/panel_game.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';
class PanelSettings extends StatelessWidget {
  const PanelSettings();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final pagesController = stage.pagesController;
    final pageThemes = pagesController.pagesData;
    final enabledPages = pagesController.enabledPages;
    
    return enabledPages.build((_, enabledPages)=> SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const SectionTitle("Enabled Screens"),
            for(final page in disablablePages)
              SwitchListTile(
                title: Text(pageThemes[page].longName),
                value: enabledPages[page],
                onChanged: (_) => pagesController.togglePage(page),
                secondary: Icon(pageThemes[page].icon),
              ),
          ]),
        ],
      ),
    ));
  }
}