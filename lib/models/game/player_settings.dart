import 'dart:convert';

import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:counter_spell/models/game/old_app/old_game_record.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/scryfall/card.dart';

class PlayerSettings {
  final String name;
  final Commanders commanders;
  final PairSettings commanderDamageSettings;
  final bool runsTwoPartners;

  PlayerSettings({
    required this.name,
    this.commanders = (partnerA: null, partnerB: null),
    this.commanderDamageSettings = (partnerA: null, partnerB: null),
    this.runsTwoPartners = false,
  });

  CommanderDamageSettings damageSettingsOf(bool partnerA) =>
      commanderDamageSettings.partner(partnerA) ??
      const CommanderDamageSettings();

  PlayerSettings restart() =>
      copyWith(commanderDamageSettings: commanderDamageSettings.restart());

  PlayerSettings swapCommanders() {
    return copyWith(
      commanders: commanders.swapped,
      commanderDamageSettings: commanderDamageSettings.swapped,
      runsTwoPartners: true,
    );
  }

  PlayerSettings updatePartnerSettings({
    required bool partnerA,
    required CommanderDamageSettings? damageSettings,
  }) {
    if (damageSettings == null ||
        damageSettings == const CommanderDamageSettings()) {
      return removePartnerSettings(partnerA: partnerA);
    }
    return copyWith(
      commanderDamageSettings: commanderDamageSettings.updateWith(
        settings: damageSettings,
        a: partnerA,
      ),
      runsTwoPartners: !partnerA ? true : null,
    );
  }

  PlayerSettings removePartnerSettings({required bool partnerA}) {
    return copyWith(
      commanderDamageSettings: (
        partnerA: partnerA ? null : commanderDamageSettings.partnerA,
        partnerB: !partnerA ? null : commanderDamageSettings.partnerB,
      ),
    );
  }

  PlayerSettings updateCommander({
    required bool partnerA,
    required MtgCard? card,
  }) {
    if (card == null) {
      return removeCommander(partnerA: partnerA);
    }
    return copyWith(
      commanders: commanders.updateWith(partner: card.id, a: partnerA),
      commanderDamageSettings: commanderDamageSettings.updateWith(
        settings: card.autoCommanderDamageSettings,
        a: partnerA,
      ),
      runsTwoPartners: !partnerA ? true : null,
    );
  }

  PlayerSettings removeCommander({required bool partnerA}) {
    return copyWith(
      commanders: (
        partnerA: partnerA ? null : commanders.partnerA,
        partnerB: !partnerA ? null : commanders.partnerB,
      ),
      commanderDamageSettings: (
        partnerA: partnerA ? null : commanderDamageSettings.partnerA,
        partnerB: !partnerA ? null : commanderDamageSettings.partnerB,
      ),
    );
  }

  static PlayerSettings fromOldGameRecord(
    OldGameRecord oldRecord, {
    required List<String> orderedPlayerNames,
    required String playerName,
  }) {
    final cardA = oldRecord.commandersA[playerName];
    final cardB = oldRecord.commandersB[playerName];
    final state = oldRecord.state.players[playerName];
    return PlayerSettings(
      name: playerName,
      commanders: (partnerA: cardA?.id, partnerB: cardB?.id),
      runsTwoPartners: state?.havePartnerB ?? false,
      commanderDamageSettings: (
        partnerA: CommanderDamageSettings.fromOldSettings(
          state?.commanderSettingsA,
        ),
        partnerB: CommanderDamageSettings.fromOldSettings(
          state?.commanderSettingsB,
        ),
      ),
    );
  }

  PlayerSettings copyWith({
    String? name,
    Commanders? commanders,
    PairSettings? commanderDamageSettings,
    bool? runsTwoPartners,
  }) {
    return PlayerSettings(
      name: name ?? this.name,
      commanders: commanders ?? this.commanders,
      commanderDamageSettings:
          commanderDamageSettings ?? this.commanderDamageSettings,
      runsTwoPartners: runsTwoPartners ?? this.runsTwoPartners,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'commanders': commanders.toMap(),
      'commanderDamageSettings': commanderDamageSettings.toMap(),
      'runsTwoPartners': runsTwoPartners,
    };
  }

  factory PlayerSettings.fromMap(Map<String, dynamic> map) {
    return PlayerSettings(
      name: map['name'] as String,
      commanders: CommandersExtension.fromMap(
        map['commanders'] as Map<String, dynamic>,
      ),
      commanderDamageSettings: PairSettingsExtension.fromMap(
        map['commanderDamageSettings'],
      ),
      runsTwoPartners: map['runsTwoPartners'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerSettings.fromJson(String source) =>
      PlayerSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerSettings(name: $name, commanders: $commanders, commanderDamageSettings: $commanderDamageSettings, runsTwoPartners: $runsTwoPartners)';
  }

  @override
  bool operator ==(covariant PlayerSettings other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.commanders == commanders &&
        other.commanderDamageSettings == commanderDamageSettings &&
        other.runsTwoPartners == runsTwoPartners;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        commanders.hashCode ^
        commanderDamageSettings.hashCode ^
        runsTwoPartners.hashCode;
  }
}
