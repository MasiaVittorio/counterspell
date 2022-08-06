import 'package:counter_spell_new/core.dart';

class Developer extends StatefulWidget {

  const Developer();

  static const double height = 400;

  @override
  State<Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  bool am = true;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return HeaderedAlert(
      am ? "Who I am" : "Who I want to be",
      bottom: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          Expanded(child: RadioNavBar<bool>(
            tileSize: RadioNavBar.defaultTileSize + 16.0,
            selectedValue: am,
            orderedValues: const [true,false],
            onSelect: (b)=>setState((){
              am = b;
            }),
            items: const {
              true: RadioNavBarItem(
                title: "Present",
                icon: Icons.access_time,
              ),
              false: RadioNavBarItem(
                title: "Future",
                icon: Icons.timelapse,
              ),
            },
          )),
          FloatingActionButton(
            backgroundColor: theme.primaryColor,
            child: Icon(Icons.mail_outline, color: theme.primaryIconTheme.color),
            onPressed: () => Stage.of(context)!.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
          ),
        ],),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.school),
            title: Text( am 
              ? "A Student attending a master's degree in physics"
              : "A teacher capable of making maths and physics look awesome",  
            ),
          ),
          ListTile(
            leading: const Icon(McIcons.microsoft_visual_studio_code),
            title: Text( am
              ? "A guy who learned mobile development to make his own life counter"
              : "A freelance Flutter developer making tons of cross-platform apps",
            ),
          ),
          ListTile(
            leading: const Icon(McIcons.microsoft_xbox_controller),
            title: Text( am
              ? "A gamer with little time for his beloved Halo"
              : "A gamer with plenty of time for his split-screen sessions with the boys",  
            ),
          ),
          ListTile(
            leading: const Icon(McIcons.cards_outline),
            title: Text( am
              ? "A Magic player since time spiral, with little budget and too many commander decks"
              : "A Magic player with a reasonable amount of decks"  
            ),
          ),
          AnimatedListed(
            duration: CSAnimations.fast,
            listed: !am,
            child: const SubSection([
              Text("(Ok that's not going to happen)", style: TextStyle(
                fontStyle: FontStyle.italic
              ),),
            ]),
          ),
        ],
      ),
    );
  }
}