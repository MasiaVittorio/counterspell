import 'package:counter_spell_new/core.dart';


class Changelog extends StatefulWidget {

  const Changelog();

  static const double height = 450.0;

  @override
  _ChangelogState createState() => _ChangelogState();
}

class _ChangelogState extends State<Changelog> {

  Change? change;
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

  final Change? change;

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
        title: Text(change!.title),
        subtitle: Text(change!.description!),
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

