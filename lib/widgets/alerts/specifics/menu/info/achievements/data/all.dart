import 'package:counter_spell_new/core.dart';
import 'counters.dart';
import 'roller.dart';
import 'ui.dart';

const Map<String,Widget> achieveHints = <String,Widget>{
  Achievement.countersShortTitle : const CountersMaster(),
  Achievement.rollerShortTitle : const TheRoller(),
  Achievement.uiExpertShortTitle : const UIExpert(),
};