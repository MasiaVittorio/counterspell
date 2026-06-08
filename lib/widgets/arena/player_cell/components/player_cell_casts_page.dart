// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_cast_page.dart';
import 'package:counter_spell/widgets/components/builders/player_settings_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellCastsPage extends StatelessWidget {
  const PlayerCellCastsPage({super.key, required this.playerIndex});

  final int playerIndex;

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
              'Commander casts',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PlayerStateBuilder(
              index: playerIndex,
              builder: (context, state, _) => Row(
                children: [
                  Expanded(
                    child: PlayerCellCastPage(
                      playerIndex: playerIndex,
                      state: state,
                      partnerA: true,
                    ),
                  ),
                  if (settings.runsTwoPartners)
                    Expanded(
                      child: PlayerCellCastPage(
                        playerIndex: playerIndex,
                        state: state,
                        partnerA: false,
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
