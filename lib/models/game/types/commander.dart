

import 'package:counter_spell_new/models/game/model.dart';

class CommanderDamage{
  //different partners
  final int a;
  final int b;

  int fromPartner(bool partnerA) => partnerA ? a:b;
  
  const CommanderDamage(this.a, [this.b = 0])
      : assert(a!=null && b!=null), 
        assert(a>=0 && b>=0);
 
  dynamic get json => <int>[this.a, this.b];
  static CommanderDamage fromJson(dynamic json) => CommanderDamage(
    (json as List)[0] as int,
    (json as List)[1] as int,
  ); 
  int get total => a+b;
  int getTotal({bool alsoB = true}) => a +  (alsoB==true ? b : 0);

  CommanderDamage withDamage(int damage, {
      bool partnerA = true, 
      int maxValue = PlayerState.kMaxValue
  }) => CommanderDamage(
    (partnerA ? damage : a).clamp(0, maxValue ?? PlayerState.kMaxValue),
    (!partnerA ? damage : b).clamp(0, maxValue ?? PlayerState.kMaxValue),
  );
}
class CommanderCast extends CommanderDamage{
  const CommanderCast(int a, [int b = 0]): super(a,b);
  static CommanderCast fromDamage(CommanderDamage damage)=> CommanderCast(damage.a ?? 0, damage.b ?? 0);
  static CommanderCast fromJson(dynamic json) => fromDamage(CommanderDamage.fromJson(json));
  CommanderCast withCast(int cast, {
      bool partnerA = true,
      int maxValue = PlayerState.kMaxValue,
  }) => CommanderCast(
    (partnerA ? cast : a).clamp(0, maxValue ?? PlayerState.kMaxValue),
    (!partnerA ? cast : b).clamp(0, maxValue ?? PlayerState.kMaxValue),
  );
}
