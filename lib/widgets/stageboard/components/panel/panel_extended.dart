import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/widgets/stageboard/components/panel/extended_components/panel_game.dart';
import 'package:counter_spell_new/widgets/stageboard/components/panel/extended_components/panel_theme.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';

class CSPanelExtended extends StatelessWidget {
  const CSPanelExtended({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final stageBoard = StageBoard.of(context);
    final panelPages = stageBoard.panelPagesController;
    final currentPage = panelPages.page;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: <Widget>[
          for(final settingsPage in SettingsPage.values)
            Positioned.fill(child: AnimatedPresented(
              duration: const Duration(milliseconds: 215),
              presented: settingsPage == currentPage,
              curve: Curves.fastOutSlowIn.flipped,
              presentMode: PresentMode.slide,
              child: const {
                SettingsPage.game: const PanelGame(),
                SettingsPage.info: const SizedBox(),
                SettingsPage.settings: const SizedBox(),
                SettingsPage.theme: const PanelTheme(),
              }[settingsPage],
            ),)
        ],
      ),
    ); //LOW PRIORITY: fai il pannello esteso
  }
}