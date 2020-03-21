import 'package:counter_spell_new/core.dart';
import 'counters.dart';
import 'roller.dart';
import 'ui.dart';

const Map<String,Widget> achieveHints = <String,Widget>{
  Achievements.countersShortTitle : const CountersMaster(),
  Achievements.rollerShortTitle : const TheRoller(),
  Achievements.uiExpertShortTitle : const UIExpert(),
};