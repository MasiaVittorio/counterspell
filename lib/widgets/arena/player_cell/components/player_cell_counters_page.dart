import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_counter_page.dart';
import 'package:counter_spell/widgets/components/builders/player_settings_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellCountersPage extends StatelessWidget {
  const PlayerCellCountersPage({
    super.key,
    required this.playerIndex,
    required this.counters,
    required this.title,
  });

  final int playerIndex;

  final List<Counter> counters;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return PlayerSettingsBuilder(
      playerIndex: playerIndex,
      builder: (context, settings, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Pad(
            top: layout.margin.tiny,
            child: Text(
              title,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PlayerStateBuilder(
              index: playerIndex,
              builder: (context, state, _) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final column in counters.part(2))
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final counter in column)
                            Expanded(
                              child: PlayerCellCounterPage(
                                playerIndex: playerIndex,
                                state: state,
                                counter: counter,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Space.vertical(layout.margin.small),
        ],
      ),
    );
  }
}
