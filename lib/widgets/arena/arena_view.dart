// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/logic/arena_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/components/arena_invalid_view.dart';
import 'package:counter_spell/widgets/arena/components/arena_view_menu.dart';
import 'package:counter_spell/widgets/arena/components/arena_view_players.dart';
import 'package:counter_spell/widgets/components/builders/players_count_builder.dart';
import 'package:counter_spell/widgets/components/common/delayed_child.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ArenaView extends StatelessWidget {
  const ArenaView({super.key, this.withMenu = true});

  final bool withMenu;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final arenaLogic = counterSpell.arenaLogic;
    final playgroupLogic = counterSpell.playgroupLogic;

    return (
      arenaLogic.preferredLayouts,
      arenaLogic.flipHorizontal,
      arenaLogic.flipVertical,
      playgroupLogic.arenaSeatOrder,
    ).build((context, layouts, hFlip, vFlip, seats) {
      return PlayersCountBuilder(
        builder: (context, n, child) {
          final mode = layouts[n] ?? ArenaLayoutMode.defaultMode(n);

          if (mode == null) return const ArenaInvalidView();
          return _ArenaView(
            mode: mode,
            hFlip: hFlip,
            vFlip: vFlip,
            seats: seats,
            flat: false,
            arenaLogic: arenaLogic,
            withMenu: withMenu,
          );
        },
      );
    });
  }
}

class _ArenaView extends StatefulWidget {
  const _ArenaView({
    required this.mode,
    required this.hFlip,
    required this.vFlip,
    required this.seats,
    required this.flat,
    required this.arenaLogic,
    required this.withMenu,
  });

  final ArenaLogic arenaLogic;
  final ArenaLayoutMode mode;
  final bool hFlip;
  final bool vFlip;
  final List<int> seats;
  final bool flat;
  final bool withMenu;

  @override
  State<_ArenaView> createState() => _ArenaViewState();
}

class _ArenaViewState extends State<_ArenaView> {
  @override
  void initState() {
    super.initState();
    widget.arenaLogic.isArenaViewOpen = true;
  }

  @override
  void dispose() {
    final arenaLogic = widget.arenaLogic;
    arenaLogic.isArenaViewOpen = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      arenaLogic.isMenuOpen.update(false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    final hFlip = widget.hFlip;
    final vFlip = widget.vFlip;
    final flat = widget.flat;
    final seats = widget.seats;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (details) {},
      child: Stack(
        children: [
          if (widget.withMenu)
            Positioned.fill(
              child: Al.bottomCenter(
                child: widget.arenaLogic.isMenuOpen.buildWithStaticChild(
                  builder: (context, value, child) => NewAnimatedListed(
                    listed: value,
                    unlistedFraction: 0.8,
                    fadeFirstFraction: 1,
                    child: child,
                  ),
                  child: DelayedChild(
                    placeholder: const SizedBox.expand(),
                    child: ArenaViewMenu(
                      mode: mode,
                      open: widget.arenaLogic.isMenuOpen,
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: ArenaViewPlayers(
              mode: mode,
              hFlip: hFlip,
              vFlip: vFlip,
              seats: seats,
              flat: flat,
              open: widget.arenaLogic.isMenuOpen,
              withMenu: widget.withMenu,
            ),
          ),
        ],
      ),
    );
  }
}
