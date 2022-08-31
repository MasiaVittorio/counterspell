import 'dart:math';

import 'throw_type.dart';
import 'dice_type.dart';

class Throw {
  final ThrowType type;
  final int value;
  final DiceType diceType;
  Throw(this.type, Random generator, int max, this.diceType,):
    value = generator.nextInt(max) + 1;
}