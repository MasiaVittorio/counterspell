import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

//position, size, dragUpdate, dragEnd, menuButton
class CSTopBarTitle extends StatelessWidget {
  const CSTopBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);
    final stage = Stage.of<CSPage,SettingsPage>(context);
    return BlocVar.build4(
      stage.panelController.isMostlyOpened,
      stage.pagesController.page,
      stage.themeController.primaryColor,
      stage.isShowingAlert,
      builder: (_, open, page, currentPrimaryColor, isShowingAlert,){
        final color = currentPrimaryColor ?? Theme.of(context).primaryColor;
        final textColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark 
          ? Colors.white
          : Colors.black;

        return bloc.game.gameAction.counterSet.build((context, counter){
          String text = "";
          if(open && !isShowingAlert){
            text = "CounterSpell";
          } else if(page == CSPage.counters){
            text = counter.longName;
          } else {
            text = CSPages.longTitleOf(page);
          }

          return AnimatedText(
            duration: MyDurations.fast,
            text: text,
            style: Theme.of(context).primaryTextTheme.title.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          );
        });
      },
    );
  }

}


