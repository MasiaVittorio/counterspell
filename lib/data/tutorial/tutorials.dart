import 'package:counter_spell/core.dart';
import 'package:counter_spell/data/tutorial/app.dart';
import 'package:counter_spell/data/tutorial/arena.dart';
import 'package:counter_spell/data/tutorial/commander.dart';
import 'package:counter_spell/data/tutorial/counters.dart';
import 'package:counter_spell/data/tutorial/history.dart';
import 'package:counter_spell/data/tutorial/playgroup.dart';

import 'gestures.dart';

class Tutorials {
  static const gestures = GesturesTutorial.tutorial;

  static const commanders = CommanderTutorial.tutorial;

  static const history = HistoryTutorial.tutorial;

  static const counters = CountersTutorial.tutorial;

  static const playgroup = PlaygroupTutorial.tutorial;

  static const arena = ArenaTutorial.tutorial;

  static const app = AppTutorial.tutorial;

  static const List<TutorialData> base = <TutorialData>[
    app,
    gestures,
    commanders,
    history,
    counters,
    playgroup,
    arena,
  ];
}
