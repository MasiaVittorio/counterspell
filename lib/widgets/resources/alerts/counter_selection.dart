import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';


class CounterSelector extends StatelessWidget {
  const CounterSelector();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final counterSet = bloc.game.gameAction.counterSet;
    return Stage.of(context).themeController.primaryColorsMap.build((_,map){
      final color = map[CSPage.counters];
      return Material(
        child: SingleChildScrollView(
          physics: Stage.of(context).panelScrollPhysics(),
          child: counterSet.build((context, current)
            => IconTheme.merge(
              data: const IconThemeData(opacity: 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for(final counter in counterSet.list)
                    RadioListTile<String>(
                      activeColor: color,
                      groupValue: current.longName,
                      value: counter.longName,
                      onChanged: (name) => counterSet.choose(
                        counterSet.list.indexWhere((c) => c.longName == name),
                      ),
                      title: Text(counter.longName),
                      secondary: Icon(counter.icon, color: color,),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}