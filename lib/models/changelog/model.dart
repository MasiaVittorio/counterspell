class Version {
  final String name;
  final List<Change> changes;

  const Version(this.name, this.changes);
}

class Change {
  final ChangeType changeType;
  final String title;
  final String? description;
  final bool important;

  const Change(this.changeType, this.title, this.description, {
    this.important = true,
  });
}

enum ChangeType {
  newFeature("NEW"),
  change("CHANGE"),
  removed("REMOVED");

  const ChangeType(this.name);

  final String name;

  static ChangeType fromName(String name) => values.firstWhere((e) => e.name == name);
}
