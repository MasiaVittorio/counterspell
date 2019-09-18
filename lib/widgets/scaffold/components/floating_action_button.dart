import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/counter_icons.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

final myDur = MyDurations.medium;

class CSFab extends StatelessWidget {

  const CSFab ({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final controller = bloc.scaffold.controller;

    return bloc.scaffold.reactiveBuild((context, theme, page, open, casting, counter)
      => bloc.scroller.isScrolling.build((context, scrolling){

        final themeData = theme.data;

        Color color;
        VoidCallback callback;
        IconData icon;
        Color iconColor;

        if(open){

          color = themeData.primaryColor;
          callback = (){
            controller.close();
            //bloc.themer.pickTheme();
          };
          icon = Icons.palette;
          iconColor = themeData.colorScheme.onPrimary;

        } else if(scrolling){

          color = themeData.canvasColor;
          callback = bloc.scroller.forceComplete;
          icon = Icons.check;
          iconColor = themeData.colorScheme.onSurface;

        } else if(page == CSPage.commander){

          callback = bloc.game.gameAction.toggleCasting;
          iconColor = themeData.colorScheme.onPrimary;

          color = casting 
            ? theme.commanderAttack 
            : theme.pageColors[CSPage.commander];
          icon = casting 
            ? ATTACK_ICON_ALT
            : CounterIcons.command_cast_outlined;

        } else {

          color = theme.pageColors[page];
          iconColor = themeData.colorScheme.onPrimary;

          switch (page) {
            case CSPage.counters:
              icon = counter.icon;
              callback = (){};
              // callback = bloc.game.gameAction.pickCounter;
              break;
            case CSPage.history:
              icon = McIcons.restart;
              // callback = (){};
              callback = bloc.game.gameState.restart;
              break;
            case CSPage.life:
              icon = McIcons.account_group_outline;
              callback = (){};
              // callback = bloc.game.gameGroup.editGroup;
              break;
            default:
          }

        }
  
        return  FloatingActionButton(
          backgroundColor: color,
          onPressed: (){},
          child: AnimatedContainer(
            duration: MyDurations.medium,
            //56 is the default size of the FAB,
            height: 56, 
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(56),
              color: color,
            ),
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(56),
              child: InkWell(
                borderRadius: BorderRadius.circular(56),
                onTap: callback,
                child: Container(
                  alignment: Alignment.center,
                  width: 56,
                  height: 56,
                  child: AnimatedIconNew(
                    icon: icon,
                    color: iconColor,
                    opacity: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
