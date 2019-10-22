import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:flutter/material.dart';
import 'package:stage_board/stage_board.dart';


class CounterSelector extends StatelessWidget {
  const CounterSelector();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final counterSet = bloc.game.gameAction.counterSet;
    final color = StageBoard.of(context).themeController.primaryColorsMap()[CSPage.counters];

    return SingleChildScrollView(
      physics: StageBoard.of(context).scrollPhysics(),
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
    );
  }
}