import 'package:counter_spell_new/core.dart';

class TutorialAlert extends StatefulWidget {
  const TutorialAlert();
  static const double height = 400.0;
  @override
  _TutorialAlertState createState() => _TutorialAlertState();
}

class _TutorialAlertState extends State<TutorialAlert> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      TutorialSection.sections[index].longTitle,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        for(final section in TutorialSection.sections)
          Positioned.fill(child: AnimatedPresented(
            duration: const Duration(milliseconds: 215),
            presented: section.longTitle == TutorialSection.sections[index].longTitle,
            curve: Curves.fastOutSlowIn.flipped,
            presentMode: PresentMode.slide,
            child: SingleChildScrollView(
              physics: Stage.of(context).panelScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: AlertTitle.height),
                child: DefaultTextStyle.merge(
                  style: const TextStyle(fontSize: 15),
                  child: Column(children: <Widget>[
                    for(final piece in section.pieces)
                      Section([
                        SectionTitle(piece.title),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: Text(piece.body, style: const TextStyle(fontSize: 15),),
                        ),
                      ])
                  ],),
                ),
              ),
            ),
          ),),
      ],),
      alreadyScrollableChild: true,
      bottom: RadioNavBar<int>(
        selectedValue: index,
        orderedValues: [for(int i=0; i<TutorialSection.sections.length; ++i) i],
        items: {for(int i=0; i<TutorialSection.sections.length; ++i) 
          i : RadioNavBarItem(
            title: TutorialSection.sections[i].title,
            icon: TutorialSection.sections[i].icon,
          ),
        },
        onSelect: (i)=>this.setState((){
          this.index = i;
        }),
        accentTextColor: Theme.of(context).accentColor,
      ),
    );
  }
}

class TutorialSection {
  final String title;
  final String longTitle;
  final List<TutorialPiece> pieces;
  final IconData icon;
  const TutorialSection({
    @required this.title,
    @required this.longTitle,
    @required this.pieces,
    @required this.icon,
  });

  static const List<TutorialSection> sections = <TutorialSection>[
    _general,
    _scroll,
    _history,
  ];

  static const TutorialSection _general = TutorialSection(
    title: "General",
    longTitle: "General Information",
    icon: Icons.info_outline,
    pieces: <TutorialPiece>[
      TutorialPiece(
        title: "Try stuff out",
        body: "There's not much you can do that cannot be undone, and when it can't there is always an alert that asks for your confirmation, so go ahead and mess with CounterSpell.",
      ),
      TutorialPiece(
        title: "CounterSpell's purpose",
        body: "This app is developed to be used by one person at a time, passing their phone around the table when needed.\nThis may not be your cup of tea, so there's a simplified screen you can use to leave the phone in the center of the table to be visible from all angles, that allows you to handle only life points.",
      ),
    ],
  );
  static const TutorialSection _scroll = TutorialSection(
    title: "Gestures",
    longTitle: "Main gestures",
    icon: McIcons.gesture_tap,
    pieces: <TutorialPiece>[
      TutorialPiece(
        title: "Scroll gestures",
        body: "You won't find any +1/-1 button in CounterSpell. Any value can be increased/decreased by scrolling on a player.\nThere is a (customizable) delay, so you can scroll multiple times before a gesture is confirmed.\nYou can see the previous value, the increment, and the result of your action before confirming.",
      ),
      TutorialPiece(
        title: "Multi selection",
        body: "You can tap on multiple players before scrolling, being able to deal damage to all the selected ones at once.\nPestilence players will love this feature.",
      ),
      TutorialPiece(
        title: "Anti-selection",
        body: "Lifelink damage? Oloro's activated ability?\nYou can tap and hold on the toggle box of any player to \"anti-select\" them: they will receive the opposite of any given damage you deal to the normally selected players!",
      ),
    ],
  );
  static const TutorialSection _history = TutorialSection(
    title: "History",
    longTitle: "History features",
    icon: CSIcons.historyIconFilled,
    pieces: <TutorialPiece>[
      TutorialPiece(
        title: "History screen",
        body: "In this screen you will find an horizontal list of columns, each one containing information about what changed from the previous gamestate.\nYou can long-press a column to undo that specific action.",
      ),
      TutorialPiece(
        title: "Undo and re-do",
        body: "You can undo the last action of the game at any time, and how many times you need. You can also re-do them if you didn't make any other change.",
      ),
    ],
  );

}

class TutorialPiece {
  final String title;
  final String body;
  const TutorialPiece({
    @required this.title,
    @required this.body,
  });
}

