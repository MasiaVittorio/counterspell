import 'package:counter_spell_new/core.dart';
import 'counters.dart';
import 'roller.dart';
import 'ui.dart';
import 'vampire.dart';

const Map<String,Widget> achieveHints = <String,Widget>{
  Achievements.countersShortTitle : CountersMaster(),
  Achievements.rollerShortTitle : TheRoller(),
  Achievements.uiExpertShortTitle : UIExpert(),
  Achievements.vampireShortTitle: Vampire(),
};