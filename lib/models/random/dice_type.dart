import 'package:counter_spell/core.dart';

enum DiceType {
  d6(
    6,
    McIcons.dice_d6,
  ),
  d20(
    20,
    McIcons.dice_d20,
  );

  const DiceType(
    this.max,
    this.icon,
  );

  final int max;
  final IconData icon;

  DiceType get other => this == DiceType.d6 ? DiceType.d20 : DiceType.d6;
}
