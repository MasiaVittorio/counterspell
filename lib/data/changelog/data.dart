import 'package:counter_spell_new/models/changelog/model.dart';


class ChangeLogData {
  static const List<Version> list = <Version>[
    Version("3.1.3", <Change>[
      Change(
        ChangeType.newFeature,
        "Keep commander settings between games",
        null,
      ),
    ]),

    Version("3.1.2", <Change>[
      Change(
        ChangeType.newFeature,
        "Tap gestures on Arena Mode",
        "You can enable them in the Arena Settings, they'll override the scroll gestures and will still allow for commander damage!",
      ),
    ]),

    Version("3.1.0", <Change>[
      Change(
        ChangeType.newFeature,
        "In-depth Tutorial",
        'You find it in the "Info" tab of the menu! It contains lots of useful tips on how to learn using CounterSpell',
      ),
      Change(
        ChangeType.change,
        'You can change dice type in the "Random" section',
        null,
      ),
    ]),

    Version("3.0.8", <Change>[
      Change(
        ChangeType.newFeature, 
        "Past games notes", 
        "You can now note some text along with each past game to record interesting stuff about that game. Just open a game from the list of past games in the leaderboards screen and you'll find a dedicated field to fill with your annotations.",
      ),
      Change(
        ChangeType.change,
        "Simple view renamed to Arena Mode",
        null,
      ),
      Change(
        ChangeType.newFeature, 
        "Arena Mode advanced settings", 
        null,
      ),
      Change(
        ChangeType.newFeature, 
        "Arena Mode up to 6 players, plus a new menu", 
        null,
      ),
      Change(
        ChangeType.newFeature, 
        "Arena Mode now handles commander damage too!", 
        "Long press on one player to declare it as the attacker, scroll on the defender to deal damage. Any single tap will return to life mode",
      ),
      Change(
        ChangeType.newFeature,
        "History life chart",
        "On the bottom left on the screen, when you're on the history screen, you'll now find a button to bring up a chart with the life of each player plotted over time.",
      ),
      Change(
        ChangeType.change, 
        "Adaptive system nav bar color", 
        null,
      ),
      Change(
        ChangeType.newFeature, 
        "Cache manager", 
        'Go into the "info" section of the menu and find a way to delete cached images or saved card search suggestions!',
      ),
    ]),
  ];
}

