import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/components/can_undo_redo_builder.dart';
import 'package:counter_spell/widgets/body/history_view/history_view.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/players_list_layout.dart';
import 'package:counter_spell/widgets/components/builders/players_count_builder.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class HistoryAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const HistoryAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return SafeArea(
      top: false,
      child: PlayersCountBuilder(
        builder: (context, playerCount, _) {
          return Column(
            children: [
              const PanelHeader(title: Text('Game history')),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: PlayerListLayoutBuilder(
                    playerCount: playerCount,
                    builder: (context, totalHeight, scrollable) {
                      final child = SizedBox(
                        height: totalHeight,
                        child: HistoryView(rightMargin: layout.margin.medium),
                      );
                      return scrollable
                          ? SingleChildScrollView(child: child)
                          : child;
                    },
                  ),
                ),
              ),
              const UndoRedoCallToActions(),
            ],
          );
        },
      ),
    );
  }
}

class UndoRedoCallToActions extends StatelessWidget {
  const UndoRedoCallToActions({super.key});

  @override
  Widget build(BuildContext context) {
    final gameLogic = context.counterSpell.gameLogic;

    final theme = context.theme;
    final layout = theme.layout;
    return CanUndoRedoBuilder(
      builder: (context, canUndo, canRedo, child) {
        return Pad(
          horizontal: layout.margin.medium,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: CallToAction(
                  horizontalMargin: 0,
                  action: canUndo ? gameLogic.back : null,
                  label: const Text('Undo'),
                  icon: const Icon(Icons.undo),
                  iconOnTheRight: false,
                ),
              ),
              Expanded(
                child: CallToAction(
                  horizontalMargin: 0,
                  action: canRedo ? gameLogic.forward : null,
                  label: const Text('Redo'),
                  icon: const Icon(Icons.redo),
                ),
              ),
            ].separateWith(Space.horizontal(layout.spacing.medium)),
          ),
        );
      },
    );
  }
}
