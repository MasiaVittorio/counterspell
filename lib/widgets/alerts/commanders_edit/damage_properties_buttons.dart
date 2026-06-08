import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class DamagePropertiesButtons extends StatelessWidget {
  const DamagePropertiesButtons({
    super.key,
    required this.onChanged,
    required this.playerSettings,
    required this.partnerA,
  });

  final ValueChanged<PlayerSettings>? onChanged;
  final PlayerSettings playerSettings;
  final bool partnerA;

  @override
  Widget build(BuildContext context) {
    final damageSettings = playerSettings.damageSettingsOf(partnerA);
    final theme = context.theme;
    final onChanged = this.onChanged;

    return ConnectedButtonGroup<CommanderDamageProperty>(
      selectedValues: damageSettings.properties,
      emptySelectionAllowed: true,
      multiSelectionEnabled: true,
      onSelectionChanged: (s) {
        if (onChanged == null) return;
        final bool removeDamageToLifeTotal =
            s.contains(CommanderDamageProperty.infect) &&
            !damageSettings.infect;
        onChanged(
          playerSettings.updatePartnerSettings(
            partnerA: partnerA,
            damageSettings: damageSettings.copyWith(
              properties: removeDamageToLifeTotal
                  ? ({...s}
                      ..remove(CommanderDamageProperty.dealDamageToLifeTotal))
                  : s,
            ),
          ),
        );
      },
      overrideHorizontalMargin: 0,
      overrideUnselectedBackgroundColor: theme.colorScheme.surfaceContainerLow,
      connections: [
        for (final property in CommanderDamageProperty.values)
          ButtonConnection(
            value: property,
            label: Text(property.shortLabel),
            selectedIcon: Icon(property.iconFilled, size: 18),
            unselectedIcon: Icon(property.iconOutlined, size: 18),
          ),
      ],
    );
  }
}
