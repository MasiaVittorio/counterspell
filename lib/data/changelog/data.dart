import 'package:counter_spell_new/models/changelog/model.dart';

class ChangeLogData {
  static const int lastBigChange = 91;

  static const List<Version> list = <Version>[
    // Version("3.2.12", <Change>[
    //   Change(
    //     ChangeType.newFeature,
    //     "",
    //     //TODO: document the update
    //     // (always leave this todo here to remind you to edit the changelog)
    //     null,
    //   ),
    // ],),
    Version("3.2.11", <Change>[
      Change(
        ChangeType.change,
        "Android 13 compatibility fix.",
        null,
      ),
    ],),
    Version("3.2.10", <Change>[
      Change(
        ChangeType.change,
        "Changed arena long press with tap gestures",
        "If you hold down a tap gesture while in arena mode, the increments will gradually increase from a +1/-1 to a +5/-5 and eventually a +10/-10 per-tick.",
      ),
    ],),
    Version("3.2.9", <Change>[
      Change(
        ChangeType.change,
        "New backups system",
        "The app doesn't automatically save the backups anywhere, you have to save them externally yourself and provide the backup files later for restoring purposes. This prevents accidental loss of data when uninstalling the app without giving the app permission to write to any folder by itself.",
      ),
      Change(
        ChangeType.change,
        "New dedicated Krarkulator app",
        "The small version of the krark & sakashima helper inside CounterSpell is gone, a link is provided to download the dedicated Krarkulator app (much better and completely free, of course).",
      ),
      Change(
        ChangeType.newFeature,
        "Merge history elements",
        "You can now merge an action with the previous one to clean up the history screen. Sleek!",
      ),
      Change(
        ChangeType.newFeature,
        "New interactive tutorial",
        'Check it out in the menu panel, you\'ll find it in the "info" tab!',
      ),
    ],),
    Version(
      "3.2.8",
      <Change>[
        Change(
          ChangeType.change,
          "Changed internal storage directory for the backups",
          null,
        ),
      ],
    ),
    Version(
      "3.2.7",
      <Change>[
        Change(
          ChangeType.change,
          "Cleaned up the Krarkulator a bit",
          null,
        ),
        Change(
          ChangeType.change,
          "Moved the Crazy specific stuff to the Game tab",
          null,
        ),
        Change(
          ChangeType.newFeature,
          "Mana Pool + Zndrsplt helper",
          "The Crazy specific stuff section now features 2 more handy helpers! CRAZY, RIGTH?",
        ),
      ],
    ),
    Version(
      "3.2.6",
      <Change>[
        Change(
          ChangeType.newFeature,
          "Krarkulator: the 1st crazy specific combo helper",
          "Open the menu panel, go to the Info tab and you'll find the \"Crazy specific stuff\" section!",
        ),
      ],
    ),
    Version(
      "3.2.5",
      <Change>[
        Change(
          ChangeType.change,
          "Re-designed commander icons for the bottom bar",
          null,
        ),
      ],
    ),
    Version(
      "3.2.4",
      <Change>[
        Change(
          ChangeType.newFeature,
          "New and improved interactive tutorial",
          null,
        ),
      ],
    ),
    Version(
      "3.2.3",
      <Change>[
        Change(
          ChangeType.newFeature,
          "Flat style theming option",
          null,
        ),
      ],
    ),
    Version(
      "3.2.2",
      <Change>[
        Change(
          ChangeType.newFeature,
          "Custom statistics",
          "Track the winrate of the good old Turn 1 Sol Ring and who play it more frequently!",
        ),
      ],
    ),
    Version(
      "3.2.1",
      <Change>[
        Change(
          ChangeType.change,
          "Split partner images",
          null,
        ),
      ],
    ),
    Version("3.2.0", <Change>[
      Change(
        ChangeType.newFeature,
        "Achievements system",
        'Every achievement has a mini-tutorial that explains how to use a little known feature of CounterSpell',
      ),
      Change(
        ChangeType.newFeature,
        "Font size slider for numbers",
        'Want a bigger life number? Go ahead on menu > settings and slide all you need!',
      ),
      Change(
        ChangeType.change,
        "Several small UI improvements",
        "Most UI components are more coherent in design and colors, and the Leaderboards page is particularly improved.",
      ),
      Change(
        ChangeType.change,
        "Better support for partners in the commander damage / cast page",
        "Now you can multi-select on the Cast page, and use only the icons on the right to handle partners splitting / selecting",
      ),
      Change(
        ChangeType.change,
        "Arena mode settings and layout improvements",
        null,
      ),
    ]),

    Version("3.1.5", <Change>[
      Change(
        ChangeType.change,
        "Minor bug fixing",
        'Arena mode "reorder players" interface did not show the current name to be positioned properly',
      ),
    ]),

    Version("3.1.4", <Change>[
      Change(
        ChangeType.change,
        "Arena mode overall redesign",
        null,
      ),
      Change(
        ChangeType.newFeature,
        "Enhanced arena mode capabilities",
        "More useful shortcuts on the quick menu, and easy to reach undo / re-do buttons",
      ),
    ]),

    Version("3.1.3", <Change>[
      Change(
        ChangeType.change,
        "Keep commander settings between games",
        null,
      ),
      Change(
        ChangeType.newFeature,
        "Start new game from Arena quick menu",
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
