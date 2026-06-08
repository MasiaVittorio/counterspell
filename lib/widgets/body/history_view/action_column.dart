import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/widgets/body/history_view/player_delta_cell.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/players_column_layout.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ActionColumn extends StatelessWidget {
  const ActionColumn({
    super.key,
    required this.delta,
    required this.onDelete,
    required this.onMergeWithPrevious,
    required this.finalGameState,
    required this.gameSettings,
  });

  final GameSettings gameSettings;
  final GameState finalGameState;
  final GameStateDelta delta;
  final VoidCallback? onDelete;
  final VoidCallback? onMergeWithPrevious;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final panelFrame = context.panelFrame;
    final playgroupLogic = context.counterSpell.playgroupLogic;

    return InkWell(
      onTap: onMergeWithPrevious == null && onDelete == null
          ? null
          : () => panelFrame.showAlert(
              AlternativesPanelAlert<int>(
                title: Text(
                  'Action happened at ${delta.laterTimeStamp.format('HH:mm')}',
                ),
                alternatives: [
                  if (onMergeWithPrevious != null)
                    const PanelAlternative(
                      value: 1,
                      label: Text('Merge with previous action'),
                      icon: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(Icons.merge_type),
                      ),
                    ),
                  if (onDelete != null)
                    const PanelAlternative(
                      value: 2,
                      label: Text('Undo only this action'),
                      danger: true,
                      icon: Icon(Icons.undo),
                    ),
                ],
                onSubmit: (value) {
                  switch (value) {
                    case 1:
                      panelFrame.showAlert(
                        ConfirmPanelAlert(
                          title: const Text(
                            'Merge this action with the previous one?',
                          ),
                          onConfirmed: onMergeWithPrevious,
                        ),
                      );
                      return;
                    case 2:
                      panelFrame.showAlert(
                        ConfirmPanelAlert(
                          title: const Text(
                            'Undo the changes from this action?',
                          ),
                          danger: true,
                          overrideConfirmIcon: const Icon(Icons.undo),
                          confirmLabel: const Text('Undo'),
                          onConfirmed: onDelete,
                        ),
                      );
                      return;
                    default:
                  }
                },
              ),
            ),
      child: Pad(
        horizontal: layout.spacing.tiny,
        child: IntrinsicWidth(
          child: playgroupLogic.listSeatOrder.build((context, seatOrder) {
            return UsesArenaViewBuilder(
              builder: (context, arenaView, _) {
                return PlayersColumnLayout(
                  extraTopChild: arenaView
                      ? HistoryTimeStamp(
                          delta.laterTimeStamp,
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  children: [
                    for (final i in seatOrder)
                      PlayerDeltaCell(
                        playerStateDeltas: delta.playerStates,
                        timeStamp: delta.laterTimeStamp,
                        finalPlayerStates: finalGameState.playerStates,
                        playerSettings: gameSettings.playerSettings,
                        thisPlayerIndex: i,
                        arenaView: arenaView,
                      ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
