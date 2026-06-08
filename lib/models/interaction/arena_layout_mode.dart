enum ArenaLayoutMode {
  twoTall(2),
  twoWide(2),
  threeFFA(3),
  three2v1(3),
  fourFFA(4),
  four2v2(4),
  four1v2v1(4),
  five1v2v2(5),
  five1v2v1v1(5),
  five3v2(5),
  six3v3(6),
  sixFFA(6);

  const ArenaLayoutMode(this.playerCount);
  final int playerCount;

  static ArenaLayoutMode? defaultMode(int n) {
    return switch (n) {
      2 => ArenaLayoutMode.twoTall,
      3 => ArenaLayoutMode.three2v1,
      4 => ArenaLayoutMode.four2v2,
      5 => ArenaLayoutMode.five1v2v2,
      6 => ArenaLayoutMode.six3v3,
      _ => null,
    };
  }
}
