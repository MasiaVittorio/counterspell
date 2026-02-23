import '../all.dart';

class CommanderDamage{
  //different partners
  final int a;
  final int b;

  int fromPartner(bool partnerA) => partnerA ? a:b;
  
  const CommanderDamage(this.a, [this.b = 0])
      : assert(a>=0 && b>=0);
 
  dynamic get json => <int>[a, b];
  static CommanderDamage fromJson(dynamic json) => CommanderDamage(
    (json as List)[0] as int,
    (json)[1] as int,
  ); 
  int get total => a+b;
  int getTotal({bool alsoB = true}) => a +  (alsoB==true ? b : 0);

  CommanderDamage withDamage(int damage, {
      bool partnerA = true, 
      int maxValue = PlayerState.kMaxValue
  }) => CommanderDamage(
    (partnerA ? damage : a).clamp(0, maxValue),
    (!partnerA ? damage : b).clamp(0, maxValue),
  );

  CommanderDamage copy() => CommanderDamage(a + 0, b + 0);
}


class CommanderCast extends CommanderDamage{
  const CommanderCast(super.a, [super.b]);
  static CommanderCast fromDamage(CommanderDamage damage)=> CommanderCast(damage.a, damage.b);
  static CommanderCast fromJson(dynamic json) => fromDamage(CommanderDamage.fromJson(json));
  CommanderCast withCast(int cast, {
      bool partnerA = true,
      int maxValue = PlayerState.kMaxValue,
  }) => CommanderCast(
    (partnerA ? cast : a).clamp(0, maxValue),
    (!partnerA ? cast : b).clamp(0, maxValue),
  );

  @override
  CommanderCast copy() => CommanderCast(a + 0, b + 0);
}
