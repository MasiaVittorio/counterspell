import 'dart:convert';

import 'package:counter_spell/data/icon/all.dart';
import 'package:counter_spell/data/icon/counter_spell_icons.dart';
import 'package:counter_spell/models/game/old_app/old_commander_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum CommanderDamageProperty {
  lifelink(
    'Lifelink',
    'Lifelink',
    'Dealing commander damage makes the controller of that commander gain that much life (defaults to false)',
  ),

  infect(
    'Infect',
    'Infect',
    'Dealing commander damage with infect gives the opponent that much poison counters (defaults to false)',
  ),

  dealDamageToLifeTotal(
    'Damage',
    'Lower life total',
    "Dealing commander damage lowers the opponent's life total (defaults to true)",
  );

  const CommanderDamageProperty(
    this.shortLabel,
    this.longLabel,
    this.description,
  );

  final String longLabel;
  final String shortLabel;
  final String description;

  IconData get iconFilled {
    return switch (this) {
      CommanderDamageProperty.infect => CounterSpellIcons.poison_filled,
      CommanderDamageProperty.lifelink => ManaIcons.ability_lifelink_2,
      CommanderDamageProperty.dealDamageToLifeTotal => ManaIcons.counter_damage,
    };
  }

  IconData get iconOutlined {
    return switch (this) {
      CommanderDamageProperty.infect => CounterSpellIcons.poison_outlined,
      CommanderDamageProperty.lifelink => ManaIcons.ability_lifelink_2,
      CommanderDamageProperty.dealDamageToLifeTotal => ManaIcons.counter_damage,
    };
  }
}

/// can detect keywords from scryfall data!
class CommanderDamageSettings {
  final Set<CommanderDamageProperty> properties;

  /// marks these settings to persist between games (a method will go over the stored settings and wipe the non-perpetual ones when starting a new game) (defaults to false)
  final bool perpetual;

  const CommanderDamageSettings({
    this.properties = const {CommanderDamageProperty.dealDamageToLifeTotal},
    this.perpetual = false,
  });

  bool get dealDamageToLifeTotal =>
      properties.contains(CommanderDamageProperty.dealDamageToLifeTotal);
  bool get lifelink => properties.contains(CommanderDamageProperty.lifelink);
  bool get infect => properties.contains(CommanderDamageProperty.infect);

  CommanderDamageSettings? restart() => perpetual ? deepCopy() : null;

  CommanderDamageSettings deepCopy() =>
      CommanderDamageSettings.fromJson(toJson());

  static CommanderDamageSettings fromOldSettings(
    OldCommanderSettings? oldSettings,
  ) => CommanderDamageSettings(
    properties: {
      if (oldSettings?.damageDefendersLife ?? true)
        CommanderDamageProperty.dealDamageToLifeTotal,
      if (oldSettings?.infect ?? false) CommanderDamageProperty.infect,
      if (oldSettings?.lifelink ?? false) CommanderDamageProperty.lifelink,
    },
  );

  CommanderDamageSettings copyWith({
    Set<CommanderDamageProperty>? properties,
    bool? perpetual,
  }) {
    return CommanderDamageSettings(
      properties: properties ?? this.properties,
      perpetual: perpetual ?? this.perpetual,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'properties': properties.map((x) => x.name).toList(),
      'perpetual': perpetual,
    };
  }

  factory CommanderDamageSettings.fromMap(Map<String, dynamic> map) {
    return CommanderDamageSettings(
      properties: {
        if (map['properties'] case List list)
          for (final p in list)
            if (p case String s) CommanderDamageProperty.values.byName(s),
      },
      perpetual: map['perpetual'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommanderDamageSettings.fromJson(String source) =>
      CommanderDamageSettings.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'CommanderDamageSettings(properties: $properties, perpetual: $perpetual)';

  @override
  bool operator ==(covariant CommanderDamageSettings other) {
    if (identical(this, other)) return true;

    return setEquals(other.properties, properties) &&
        other.perpetual == perpetual;
  }

  @override
  int get hashCode => properties.hashCode ^ perpetual.hashCode;
}
