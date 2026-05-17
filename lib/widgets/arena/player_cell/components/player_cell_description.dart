// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/widgets/arena/player_cell/builders/cell_mode_builder.dart';
import 'package:counter_spell/widgets/components/builders/player_settings_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellDescription extends StatelessWidget {
  const PlayerCellDescription({super.key, required this.playerIndex});

  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final style = context.theme.textTheme.titleSmall;
    return IgnorePointer(
      ignoring: true,
      child: PlayerSettingsBuilder(
        playerIndex: playerIndex,
        builder: (context, settings, _) {
          return ArenaCellModeBuilder(
            playerIndex: playerIndex,
            builder: (context, mode, _) {
              return AnimatedText(
                switch (mode) {
                  CellMode.attacking => 'Attacking',
                  CellMode.defending => 'Defending',
                  CellMode.life => settings.name,
                },
                textAlign: TextAlign.center,
                style: style,
              );
            },
          );
        },
      ),
    );
  }
}
