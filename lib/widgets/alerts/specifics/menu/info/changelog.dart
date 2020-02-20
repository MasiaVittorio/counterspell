import 'package:counter_spell_new/core.dart';


//==========================================
// Model
class Version {
  final String name;
  final List<Change> changes;

  const Version(this.name, this.changes);
}

class Change {
  final ChangeType changeType;
  final String title;
  final String description;
  final bool important;

  const Change(this.changeType, this.title, this.description, {
    this.important = true,
  });
}

enum ChangeType {
  newFeature,
  change,
  removed,
}

class ChangeTypes{
  static const Map<ChangeType,String> names = {
    ChangeType.newFeature: "NEW",
    ChangeType.change: "CHANGE",
    ChangeType.removed: "REMOVED",
  };
  static const Map<String,ChangeType> inverse = {
    "NEW": ChangeType.newFeature,
    "CHANGE": ChangeType.change,
    "REMOVED": ChangeType.removed,
  };

  static String nameOf(ChangeType type) => names[type];
  static ChangeType fromName(String name) => inverse[name];
}

//==========================================
// Widget
class Changelog extends StatefulWidget {

  const Changelog();

  static const double height = 450.0;

  @override
  _ChangelogState createState() => _ChangelogState();
}

class _ChangelogState extends State<Changelog> {

  Change change;
  bool showing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final stage = Stage.of(context);

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        HeaderedAlert("What's new",
          child: Column(children: <Widget>[
            for(final Version version in ChangeLogData.list)
              _VersionWidget(version, (chg) => this.setState((){
                this.change = chg;
                this.showing = true;
              })),
          ],),
        ),
        IgnorePointer(
          ignoring: !showing,
          child: GestureDetector(
            onTapDown: (_) => this.setState((){
              this.showing = false;
            }),
            child: AnimatedContainer(
              duration: CSAnimations.fast,
              color: theme.scaffoldBackgroundColor.withOpacity(
                showing ? 0.5 : 0.0
              ),
            ),
          ),
        ),
        if(change != null) Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: IgnorePointer(
            ignoring: !showing,
            child: AnimatedListed(
              duration: CSAnimations.fast,
              listed: showing,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _Description(change),
              ),
              overlapSizeAndOpacity: 1.0,
            ),
          ),
        ),
      ],
    );
  }

}

class _Description extends StatelessWidget {

  final Change change;

  const _Description(this.change);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        boxShadow: [CSShadows.shadow],
      ),
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(change.title),
        subtitle: Text(change.description),
      ),
    );
  }
}

class _VersionWidget extends StatelessWidget {
  final Version version;
  final void Function(Change) showChange;

  const _VersionWidget(this.version, this.showChange);

  @override
  Widget build(BuildContext context) {
    return Section([
      SectionTitle(version.name),
      for(final change in version.changes)
        if(change.important)
          ListTile(
            dense: true,
            title: Text("${ChangeTypes.nameOf(change.changeType)}: ${change.title}"),
            trailing: change.description != null ? Icon(Icons.keyboard_arrow_right) : null,
            onTap: change.description != null ? () => showChange(change) : null,
          ),
    ]);
  }
}

//==========================================
// Data

class ChangeLogData {
  static const List<Version> list = <Version>[
    Version("3.0.8", <Change>[
      Change(
        ChangeType.newFeature, 
        "Past games notes", 
        "You can now note some text along with each past game to record interesting stuff about that game. Just open a game from the list of past games in the leaderboards screen and you'll find a dedicated field to fill with your annotations.",
      ),
      Change(
        ChangeType.newFeature, 
        "Changelog", 
        "Well apparently you found it! I'll try to register here any kind of change made to the app during its development to guide you (the user) to discover every new feature :D",
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
        "Arena Mode 5 and 6 players layout, + new menu", 
        null,
      ),
      Change(
        ChangeType.change, 
        "Adaptive System Nav Bar color", 
        null,
      ),
      Change(
        ChangeType.newFeature, 
        "Cache Manager", 
        'Go into the "info" section of the menu and find a way to delete cached images or saved card search suggestions!',
      ),
    ]),
  ];
}

