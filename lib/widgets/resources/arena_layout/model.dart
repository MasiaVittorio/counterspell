
enum ArenaCenterAlignment {
  screen,
  intersection,
}

enum ArenaLayoutType {
  squad,
  ffa,
}

extension ArenaLayoutTypeNames on ArenaLayoutType {
  static const Map<ArenaLayoutType,String> names = <ArenaLayoutType,String>{
    ArenaLayoutType.ffa: "Free for all",
    ArenaLayoutType.squad: "Squad",
  };

  String get name => names[this];

  ArenaLayoutType get other => this == ArenaLayoutType.ffa 
    ? ArenaLayoutType.squad
    : ArenaLayoutType.ffa;
}

class ArenaLayoutTypes {
  static const Map<String,ArenaLayoutType> map = <String,ArenaLayoutType>{
    "Free for all": ArenaLayoutType.ffa,
    "Squad": ArenaLayoutType.squad,
  };
  static ArenaLayoutType fromName(String name) => map[name];
}
