import 'package:counter_spell_new/widgets/constants.dart';
import 'package:flutter/material.dart';

import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/my_durations.dart';

import 'components/components.dart';


class CSBody extends StatelessWidget {
  
  const CSBody({
    Key key,
  }): super(key: key);

  static const double _coreTileSize = CSConstants.minTileSize;

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final group = bloc.game.gameGroup;
    final scaffold = bloc.scaffold;
    final themer = bloc.themer;

    return LayoutBuilder(builder: (context, constraints)
      => group.names.build((context, names){

        final int count = names.length;

        final double tileSize = CSConstants.computeTileSize(
          constraints, 
          _coreTileSize, 
          count,
        );

        final double totalSize = tileSize * count;

        return ConstrainedBox(
          constraints: constraints,
          child: SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              height: totalSize,
              child: themer.themeSet.build((_, theme) 
                => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[

                    Positioned.fill(
                      right: CSConstants.minTileSize,
                      child: BodyHistory(
                        theme: theme,
                        count: count,
                        tileSize: tileSize,
                        group: group,
                        names: names,
                        coreTileSize: _coreTileSize,
                      ),
                    ),

                    scaffold.mainIndex.build((_, i) => AnimatedPositioned(
                      duration: MyDurations.fast,
                      top: 0.0,
                      bottom: 0.0,
                      width: constraints.maxWidth,

                      //scaffold.currentPage is updated when mainIndex changes
                      left: scaffold.currentPage == CSPage.history 
                        ? constraints.maxWidth - CSConstants.minTileSize
                        : 0.0,

                      child: BodyGroup(
                        names,
                        count: count,
                        tileSize: tileSize,
                        coreTileSize: _coreTileSize,
                        theme: theme,
                        group: group,
                      ),
                    )),

                  ],
                )
              ),
            ),
          ),
        );
      }),
    );
  }
}
