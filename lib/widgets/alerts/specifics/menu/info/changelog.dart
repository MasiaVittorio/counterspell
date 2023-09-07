// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell_new/core.dart';

class Changelog extends StatelessWidget {

  const Changelog({Key? key}) : super(key: key);
  static const double height = 500.0;

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Changelog", 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Space.vertical(20),
          ...(<Widget>[
            for(final version in ChangeLogData.list)
              VersionCard(version),
          ].separateWith(const ChangeSeparator(12, left: 40))),
          const Space.vertical(20),
        ],
      ),
      customBackground: (theme) => theme.canvasColor,
    );
  }
}

class VersionCard extends StatelessWidget {

  const VersionCard(this.version, {Key? key}) : super(key: key);

  final Version version;

  @override
  Widget build(BuildContext context) {
    return SubSection([
      SectionTitle(version.name),
      const Space.vertical(12),
      if(version.changes.isNotEmpty)
        if(version.changes.length == 1)
          ChangeTile(version.changes.first, ListRole.only)
        else ...(<Widget>[
            ChangeTile(version.changes.first, ListRole.first),
            for(int i=1; i<version.changes.length - 1; ++i)
              ChangeTile(version.changes[i], ListRole.middle),
            ChangeTile(version.changes.last, ListRole.last),
          ].separateWith(const ChangeSeparator(8))),
      const Space.vertical(12),
    ]);
  }
}

class ChangeSeparator extends StatelessWidget {

  const ChangeSeparator(this.height, {
    this.left = 30,
    Key? key,
  }) : super(key: key);

  final double height;
  final double left;

  @override
  Widget build(BuildContext context) {
    return ChangeBorder(
      SizedBox(height: height, width: double.infinity,),
      left: left,
    );
  }
}

class ChangeBorder extends StatelessWidget {

  const ChangeBorder(this.child, {
    Key? key,
    this.top = 0,
    this.bottom = 0,
    this.left = 30,
  }): height = null,
      super(key: key);

  const ChangeBorder.first(this.child, {
    Key? key,
    this.top = 12,
    this.bottom = 0,
    this.left = 30,
  }): height = null,
      super(key: key);

  const ChangeBorder.last(this.child, {
    Key? key,
    this.top = 0,
    this.height = 12,
    this.left = 30,
  }): bottom = null,
      super(key: key);

  final Widget child;

  final double? top;
  final double? bottom;
  final double? height;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Positioned(
          top: top, bottom: bottom, height: height,
          left: left, width: 1, 
          child: Container(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child,
      ],
    );
  }
}

enum ListRole {
  first,
  last,
  only,
  middle,
}

class ChangeTile extends StatelessWidget {
  
  const ChangeTile(this.change, this.role, {Key? key}) : super(key: key);

  final Change change;
  final ListRole role;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    switch (role) {
      case ListRole.first:
        return ChangeBorder.first(content(theme));
      case ListRole.last:
        return ChangeBorder.last(content(theme));
      case ListRole.middle:
        return ChangeBorder(content(theme));
      case ListRole.only:
        return content(theme);
    }
  }

  Column content(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: typeAndTitle(theme),
        ),
        if(change.description != null)
          description(theme),
      ],
    );
  }

  Widget typeAndTitle(ThemeData theme) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      type(theme),
      Expanded(child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Text(change.title),
      )),
    ],
  );

  Widget type(ThemeData theme) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outline.withOpacity(0.15),
        width: 1,
      ),
      color: theme.canvasColor
    ),
    child: Text(change.changeType.name),
  );

  Widget description(ThemeData theme) => Padding(
    padding: EdgeInsets.only(
      left: (<ListRole,double>{
        ListRole.first: 30.0 + 12,
        ListRole.middle: 30.0 + 12,
        ListRole.last: 24,
        ListRole.only: 24,
      })[role] ?? 0.0, 
      right: 12, 
      top: 6, 
      bottom: 6,
    ),
    child: Text(
      change.description ?? "", 
      textAlign: TextAlign.start,
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
      ),
    ),
  );

}

