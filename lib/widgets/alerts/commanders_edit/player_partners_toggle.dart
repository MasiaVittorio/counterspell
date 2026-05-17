import 'package:counter_spell/models/game/player_settings.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerPartnersToggle extends StatelessWidget {
  const PlayerPartnersToggle({
    super.key,
    required this.playerSettings,
    required this.update,
  });

  final PlayerSettings playerSettings;
  final ValueChanged<PlayerSettings> update;

  @override
  Widget build(BuildContext context) {
    return ConnectedButtonGroup<bool>.singleNullable(
      expandHorizontally: false,
      overrideHorizontalMargin: 0,
      selectedValue: playerSettings.runsTwoPartners,
      onSelect: (bool? s) =>
          update(playerSettings.copyWith(runsTwoPartners: s ?? false)),
      connections: [
        const ButtonConnection(
          value: true,
          label: Text('Partners'),
          selectedIcon: Icon(Icons.people),
          unselectedIcon: Icon(Icons.people_outline),
        ),
      ],
    );
  }
}
