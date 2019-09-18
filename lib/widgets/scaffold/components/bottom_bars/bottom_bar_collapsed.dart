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
      scaffold.page,
      settings.enabledPages,
      bloc.themer.themeSet.variable,
      bloc.game.gameAction.isCasting,
      builder: (BuildContext context, CSPage currentPage, Map<CSPage,bool> enabledPages, CSTheme theme, bool casting){

        List<CSPage> pages = <CSPage>[];
        Map<int,CSPage> indexToPage = <int,CSPage>{}; 
        Map<CSPage,int> pageToIndex = <CSPage,int>{};
        int n = 0;
        for(final pValue in CSPage.values){
          if(enabledPages[pValue]){
            pages.add(pValue);
            indexToPage[n] = pValue;
            pageToIndex[pValue] = n;
            ++n;
          }
        }  
        final currentIndex = pageToIndex[currentPage];      

        final textColor = theme.data.colorScheme.onPrimary;

        return ShiftingFabNavBar(
          backgroundColor: theme.data.canvasColor,
          duration: MyDurations.fast,
          currentIndex: currentIndex,
          onTap: (i) => scaffold.page.set(indexToPage[i]),
          elevation: 8,
          hasNotch: true,
          items: [
            for(final page in pages) 
              ShiftingBarItem(
                icon: Icon(
                  CSTypesUI.pageIconsOutlined[page],
                  color: textColor.withOpacity(0.5),
                ),
                activeIcon: Icon(
                  CSTypesUI.pageIconsFilled[page],
                  color: textColor,
                ),
                title: Text(
                  CSPAGE_TITLES_SHORT[page],
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                backgroundColor: page == CSPage.commander && !casting
                  ? theme.commanderAttack
                  : theme.pageColors[page],
              ),
          ],
        );
      });

  }
}