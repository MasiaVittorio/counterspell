import 'package:counter_spell/models/game/old_app/old_player_state.dart';

class OldCommanderDamage {
  //different partners
  final int a;
  final int b;

  int fromPartner(bool partnerA) => partnerA ? a : b;

  const OldCommanderDamage(this.a, [this.b = 0]) : assert(a >= 0 && b >= 0);

  dynamic get json => <int>[a, b];
  static OldCommanderDamage fromJson(dynamic json) =>
      OldCommanderDamage((json as List)[0] as int, (json)[1] as int);
  int get total => a + b;
  int getTotal({bool alsoB = true}) => a + (alsoB == true ? b : 0);

  OldCommanderDamage withDamage(
    int damage, {
    bool partnerA = true,
    int maxValue = OldPlayerState.kMaxValue,
  }) => OldCommanderDamage(
    (partnerA ? damage : a).clamp(0, maxValue),
    (!partnerA ? damage : b).clamp(0, maxValue),
  );

  OldCommanderDamage copy() => OldCommanderDamage(a + 0, b + 0);
}

class OldCommanderCast extends OldCommanderDamage {
  const OldCommanderCast(super.a, [super.b]);
  static OldCommanderCast fromDamage(OldCommanderDamage damage) =>
      OldCommanderCast(damage.a, damage.b);
  static OldCommanderCast fromJson(dynamic json) =>
      fromDamage(OldCommanderDamage.fromJson(json));
  OldCommanderCast withCast(
    int cast, {
    bool partnerA = true,
    int maxValue = OldPlayerState.kMaxValue,
  }) => OldCommanderCast(
    (partnerA ? cast : a).clamp(0, maxValue),
    (!partnerA ? cast : b).clamp(0, maxValue),
  );

  @override
  OldCommanderCast copy() => OldCommanderCast(a + 0, b + 0);
}
