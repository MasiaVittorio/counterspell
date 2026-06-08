import 'package:counter_spell/models/game/commander_damage_settings.dart';

typedef CommanderDamage = ({int fromPartnerA, int fromPartnerB});

extension CommanderDamageExtension on CommanderDamage {
  int from(bool a) => a ? fromPartnerA : fromPartnerB;

  static CommanderDamage fromMap(Map<String, dynamic> map) {
    return (
      fromPartnerA: map['fromPartnerA'] ?? 0,
      fromPartnerB: map['fromPartnerB'] ?? 0,
    );
  }

  Map<String, int> toMap() {
    return {'fromPartnerA': fromPartnerA, 'fromPartnerB': fromPartnerB};
  }

  CommanderDamage copyWith({int? fromPartnerA, int? fromPartnerB}) {
    return (
      fromPartnerA: fromPartnerA ?? this.fromPartnerA,
      fromPartnerB: fromPartnerB ?? this.fromPartnerB,
    );
  }

  CommanderDamage updateWith({required int cast, required bool a}) {
    return copyWith(
      fromPartnerA: a ? cast : null,
      fromPartnerB: !a ? cast : null,
    );
  }

  CommanderDamage clamped() => (
    fromPartnerA: fromPartnerA < 0 ? 0 : fromPartnerA,
    fromPartnerB: fromPartnerB < 0 ? 0 : fromPartnerB,
  );

  CommanderDamage operator +(CommanderDamage? other) {
    return copyWith(
      fromPartnerA: fromPartnerA + (other?.fromPartnerA ?? 0),
      fromPartnerB: fromPartnerB + (other?.fromPartnerB ?? 0),
    );
  }

  CommanderDamage operator -(CommanderDamage? other) {
    return copyWith(
      fromPartnerA: fromPartnerA - (other?.fromPartnerA ?? 0),
      fromPartnerB: fromPartnerB - (other?.fromPartnerB ?? 0),
    );
  }
}

typedef CommanderCasts = ({int partnerA, int partnerB});

extension CommanderCastsExtension on CommanderCasts {
  static CommanderCasts fromMap(Map<String, dynamic> map) {
    return (partnerA: map['partnerA'] ?? 0, partnerB: map['partnerB'] ?? 0);
  }

  Map<String, int> toMap() {
    return {'partnerA': partnerA, 'partnerB': partnerB};
  }

  int of(bool a) => a ? partnerA : partnerB;

  CommanderCasts copyWith({int? partnerA, int? partnerB}) {
    return (
      partnerA: partnerA ?? this.partnerA,
      partnerB: partnerB ?? this.partnerB,
    );
  }

  CommanderCasts updateWith({required int cast, required bool a}) {
    return copyWith(partnerA: a ? cast : null, partnerB: !a ? cast : null);
  }

  CommanderCasts operator +(CommanderCasts other) {
    return copyWith(
      partnerA: partnerA + other.partnerA,
      partnerB: partnerB + other.partnerB,
    );
  }

  CommanderCasts operator -(CommanderCasts other) {
    return copyWith(
      partnerA: partnerA - other.partnerA,
      partnerB: partnerB - other.partnerB,
    );
  }

  CommanderCasts clamped() => (
    partnerA: partnerA < 0 ? 0 : partnerA,
    partnerB: partnerB < 0 ? 0 : partnerB,
  );
}

/// scryfall ids
typedef Commanders = ({String? partnerA, String? partnerB});

extension CommandersExtension on Commanders {
  String? partner(bool a) => a ? partnerA : partnerB;

  static Commanders fromMap(Map<String, dynamic> map) {
    return (partnerA: map['partnerA'], partnerB: map['partnerB']);
  }

  Map<String, String?> toMap() {
    return {'partnerA': partnerA, 'partnerB': partnerB};
  }

  Commanders copyWith({String? partnerA, String? partnerB}) {
    return (
      partnerA: partnerA ?? this.partnerA,
      partnerB: partnerB ?? this.partnerB,
    );
  }

  Commanders updateWith({required String? partner, required bool a}) {
    return copyWith(
      partnerA: a ? partner : null,
      partnerB: !a ? partner : null,
    );
  }

  Commanders get swapped => copyWith(partnerA: partnerB, partnerB: partnerA);
}

typedef PairSettings = ({
  CommanderDamageSettings? partnerA,
  CommanderDamageSettings? partnerB,
});

extension PairSettingsExtension on PairSettings {
  CommanderDamageSettings? partner(bool a) => a
      ? partnerA == const CommanderDamageSettings()
            ? null
            : partnerA
      : partnerB == const CommanderDamageSettings()
      ? null
      : partnerB;

  Map<String, dynamic> toMap() {
    return {'partnerA': partnerA?.toMap(), 'partnerB': partnerB?.toMap()};
  }

  PairSettings updateWith({
    required CommanderDamageSettings? settings,
    required bool a,
  }) {
    return copyWith(
      partnerA: a ? settings : null,
      partnerB: !a ? settings : null,
    );
  }

  static PairSettings fromMap(Map<String, dynamic> map) {
    return (
      partnerA: map['partnerA'] != null
          ? CommanderDamageSettings.fromMap(
              map['partnerA'] as Map<String, dynamic>,
            )
          : null,
      partnerB: map['partnerB'] != null
          ? CommanderDamageSettings.fromMap(
              map['partnerB'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  PairSettings copyWith({
    CommanderDamageSettings? partnerA,
    CommanderDamageSettings? partnerB,
  }) => (
    partnerA: partnerA ?? this.partnerA,
    partnerB: partnerB ?? this.partnerB,
  );

  PairSettings restart() =>
      (partnerA: partnerA?.restart(), partnerB: partnerB?.restart());

  PairSettings get swapped => (partnerA: partnerB, partnerB: partnerA);
}
