import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:sid_base/sid_base.dart';

class ArenaLogic extends LogicBase {
  bool isArenaViewOpen = false;

  final Reactive<bool> isMenuOpen = Reactive(false);

  final PersistentReactive<bool> flipHorizontal = PersistentReactive<bool>(
    false,
    key: 'arenaFlipHorizontal',
  );
  final PersistentReactive<bool> flipVertical = PersistentReactive<bool>(
    false,
    key: 'arenaFlipVertical',
  );
  final PersistentReactive<Map<int, ArenaLayoutMode>> preferredLayouts =
      PersistentReactive<Map<int, ArenaLayoutMode>>(
        {
          2: ArenaLayoutMode.twoTall,
          3: ArenaLayoutMode.three2v1,
          4: ArenaLayoutMode.four2v2,
          5: ArenaLayoutMode.five3v2,
          6: ArenaLayoutMode.six3v3,
        },
        key: 'preferredArenaLayouts',
        toJsonEncodable: (value) => {
          for (final entry in value.entries)
            entry.key.toString(): entry.value.name,
        },
        fromJsonDecoded: (jsonDecoded) => {
          for (final entry in (jsonDecoded as Map<String, dynamic>).entries)
            int.parse(entry.key): ArenaLayoutMode.values.byName(entry.value),
        },
      );

  ArenaLogic();

  @override
  void dispose() {
    preferredLayouts.dispose();
    flipHorizontal.dispose();
    flipVertical.dispose();
    isMenuOpen.dispose();
    super.dispose();
  }
}
