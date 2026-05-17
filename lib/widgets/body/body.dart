import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/body/history_view/history_view.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/players_list_layout.dart';
import 'package:counter_spell/widgets/body/players_list_view/players_list_view.dart';
import 'package:counter_spell/widgets/components/builders/animated_number_circle.dart';
import 'package:counter_spell/widgets/components/builders/players_count_builder.dart';
import 'package:counter_spell/widgets/components/builders/selector.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  static double historyMargin(Layout layout) =>
      layout.margin.medium +
      layout.padding.medium +
      AnimatedNumberCircle.numberSize +
      layout.padding.medium;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final theme = context.theme;
    final layout = theme.layout;

    final counterSpell = context.counterSpell;

    return PlayersCountBuilder(
      builder: (context, playerCount, child) {
        return Selector(
          target: BodyPage.history,
          reactive: counterSpell.pagesLogic.bodyPage,
          keys: [],
          child: child,
          builder: (context, showHistory, child) {
            return PlayerListLayoutBuilder(
              playerCount: playerCount,
              builder: (context, totalHeight, scrollable) {
                final child = SizedBox(
                  height: totalHeight,
                  child: Stack(
                    children: [
                      const Positioned.fill(child: HistoryView()),
                      Positioned.fill(
                        child: GenericAnimatedBuilder(
                          duration: context.panelFrameStyle.duration,
                          curve: Easings.emphasized,
                          value: showHistory ? 1 : 0,
                          child: const PlayersListView(),
                          builder: (context, value, child) =>
                              Transform.translate(
                                offset: Offset(
                                  value.rangeMap(
                                    to: (
                                      0,
                                      screenSize.width -
                                          layout.margin.medium -
                                          layout.padding.medium -
                                          AnimatedNumberCircle.numberSize -
                                          layout.padding.medium,
                                    ),
                                  ),
                                  0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.surface.withValues(
                                          alpha: 1,
                                        ),
                                        theme.colorScheme.surface.withValues(
                                          alpha: 1,
                                        ),
                                        theme.colorScheme.surface.withValues(
                                          alpha: value.rangeMap(to: (1, 0.8)),
                                        ),
                                        theme.colorScheme.surface.withValues(
                                          alpha: value.rangeMap(to: (1, 0.7)),
                                        ),
                                      ],
                                      stops: [0, 0.8, 0.9, 1],
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                    ),
                                  ),
                                  child: child,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                );

                return scrollable ? SingleChildScrollView(child: child) : child;
              },
            );
          },
        );
      },
    );
  }
}
