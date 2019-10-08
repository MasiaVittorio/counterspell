import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

//position, size, dragUpdate, dragEnd, menuButton
class CSTopBarTitle extends StatelessWidget {
  const CSTopBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = CSBloc.of(context);
    final stageBoard = StageBoard.of<CSPage,dynamic>(context);
    final CSPage page = stageBoard.pagesController.page;
    final bool open = stageBoard.panelController.isMostlyOpened;

    return BlocVar.build2(
      bloc.game.gameAction.isCasting,
      bloc.game.gameAction.counterSet.variable,
      builder:(context,casting, counter){
     
        String text = "";
        if(open){
          text = "CounterSpell";
        }
        if(page == CSPage.counters){
          text = counter.longName;
        }
        else if(page == CSPage.commander){
          text = casting ? "Commander Cast" : "Commander Damage";
        }
        else text = CSPAGE_TITLES_LONG[page];

        return AnimatedText(
          duration: MyDurations.fast,
          text: text,
          style: Theme.of(context).primaryTextTheme.title.copyWith(
            fontWeight: FontWeight.w600
          ),
        );

      }
    );
  }

}


