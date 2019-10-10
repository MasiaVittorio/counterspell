import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/widgets/resources/playgroup/current_player.dart';
import 'package:counter_spell_new/widgets/resources/playgroup/new_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class PlayGroupAlert extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Material(
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Material(
            child: Container(
              height: 32,
              alignment: Alignment.center,
              child: Text("Edit PlayGroup"),
            ),
          ),
          Expanded(
            child: bloc.game.gameGroup.names.build((context, names) 
              => Material(
                elevation: 2,
                child: ReorderableList(
                  onReorder: (from,to){
                    final String name = group.names.value
                      .firstWhere((name)=> ValueKey(name) == from);
                    final int newIndex = group.names.value
                      .indexWhere((name)=> ValueKey(name) == to);
                    group.moveName(name, newIndex);
                    return true;
                  },
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: <Widget>[
                      for(final name in names)
                        ReorderableItem(
                          key: ValueKey(name),
                          childBuilder:(context,state) => Material(
                            child: Opacity(
                              opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                              child: IgnorePointer(
                                ignoring: state == ReorderableItemState.placeholder,
                                child: CurrentPlayer(name, bloc),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          NewPlayer(bloc),
        ],
      ),
    );
  }
}

