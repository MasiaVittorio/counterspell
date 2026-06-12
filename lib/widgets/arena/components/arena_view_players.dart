import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/components/arena_layout_.dart';
import 'package:counter_spell/widgets/arena/components/arena_menu_button.dart';
import 'package:counter_spell/widgets/arena/components/can_undo_redo_builder.dart';
import 'package:counter_spell/widgets/arena/components/offset_alignment.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaViewPlayers extends StatelessWidget {
  const ArenaViewPlayers({
    super.key,
    required this.mode,
    required this.hFlip,
    required this.vFlip,
    required this.seats,
    required this.flat,
    required this.open,
    required this.withMenu,
  });

  final ArenaLayoutMode mode;
  final bool hFlip;
  final bool vFlip;
  final List<int> seats;
  final bool flat;
  final bool withMenu;
  final Reactive<bool> open;

  @override
  Widget build(BuildContext context) {
    final safe = context.safe;
    final theme = context.theme;
    final layout = theme.layout;
    final gameLogic = context.counterSpell.gameLogic;

    return Pad(
      bottom:
          (flat
              ? safe.bottom
              : safe.bottom > 0
              ? safe.bottom
              : layout.padding.small) +
          (withMenu ? 0 : layout.padding.small),
      top: flat
          ? safe.top
          : safe.top > 0
          ? safe.top
          : layout.padding.small,
      horizontal: flat ? 0 : layout.padding.small,
      child: ArenaLayout(
        mode: mode,
        horizontalFlip: hFlip,
        verticalFlip: vFlip,
        spacing: flat ? 0 : layout.spacing.smaller,
        foregroundBuilder: withMenu
            ? (context, constraints, offset, axis) => OffsetAlignment(
                offset: offset,
                child: CanUndoRedoBuilder(
                  builder: (context, canUndo, canRedo, child) => open.build(
                    (context, value) => ArenaMenuButton(
                      direction: axis,
                      open: value,
                      onChanged: open.update,
                      onUndo: canUndo ? gameLogic.back : null,
                      onRedo: canRedo ? gameLogic.forward : null,
                    ),
                  ),
                ),
              )
            : null,
        players: [
          for (final seat in seats)
            Al.bottomCenter(
              child: open.buildWithStaticChild(
                builder: (context, value, child) => AnimatedListed(
                  listed: !value,
                  fadeFirstFraction: 1,
                  child: child,
                ),
                child: ArenaPlayerCell(
                  flat: flat,
                  playerIndex: seat,
                  avoidMenuButton: withMenu,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
