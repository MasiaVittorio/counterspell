import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/extended_components/panel_game.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/extended_components/panel_settings.dart';
import 'package:counter_spell_new/widgets/stageboard/panel/extended_components/panel_theme.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage/stage.dart';

class CSPanelExtended extends StatelessWidget {
  const CSPanelExtended({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final panelPages = stage.panelPagesController;
    final currentPage = panelPages.page;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: currentPage.build((_, currentPage) => Stack(
        fit: StackFit.expand,
        alignment: Alignment.topCenter,
        children: <Widget>[
          for(final settingsPage in SettingsPage.values)
            Positioned.fill(child: AnimatedPresented(
              duration: const Duration(milliseconds: 215),
              presented: settingsPage == currentPage,
              curve: Curves.fastOutSlowIn.flipped,
              presentMode: PresentMode.slide,
              child: _panels[settingsPage],
            ),)
        ],
      ),
    ));
  }
}

const _panels = const {
  SettingsPage.game: const PanelGame(),
  SettingsPage.info: const SizedBox(),
  SettingsPage.settings: const PanelSettings(),
  SettingsPage.theme: const PanelTheme(),
};