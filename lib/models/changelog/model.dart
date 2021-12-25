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

  static String? nameOf(ChangeType type) => names[type];
  static ChangeType? fromName(String name) => inverse[name];
}
