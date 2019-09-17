import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class CSBottomBarCollapsed extends StatelessWidget {
  const CSBottomBarCollapsed({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final scaffold = bloc.scaffold;
    final settings = bloc.settings;

    return BlocVar.build4(
      scaffold.mainIndex,
      settings.enabledPages,
      bloc.themer.themeSet.variable,
      bloc.game.gameAction.isCasting,
      builder: (BuildContext context, int index, _pages, CSTheme theme, bool casting){
        final pageMap = scaffold.indexToPage;
        final int commanderIndex = scaffold.pageToIndex[CSPage.commander]; 
        final textColor = theme.data.colorScheme.onPrimary;
        return ShiftingFabNavBar(
          backgroundColor: theme.data.canvasColor,
          duration: MyDurations.fast,
          currentIndex: index,
          onTap: scaffold.goToIndex,
          elevation: 8,
          hasNotch: true,
          items: [
            for(int i=0; i<scaffold.howManyPages; ++i) 
              ShiftingBarItem(
                icon: Icon(
                  CSTypesUI.pageIconsOutlined[pageMap[i]],
                  color: textColor.withOpacity(0.5),
                ),
                activeIcon: Icon(
                  CSTypesUI.pageIconsFilled[pageMap[i]],
                  color: textColor,
                ),
                title: Text(
                  CSPAGE_TITLES_SHORT[pageMap[i]],
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                backgroundColor: i == commanderIndex && !casting
                  ? theme.commanderAttack
                  : theme.pageColors[pageMap[i]],
              ),
          ],
        );
      });

  }
}