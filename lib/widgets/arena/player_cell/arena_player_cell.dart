import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/models/interaction/interaction_mode.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_body.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_decoration.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_padding.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class ArenaPlayerCell extends StatelessWidget {
  const ArenaPlayerCell({
    super.key,
    required this.playerIndex,
    required this.flat,
    required this.avoidMenuButton,
  });

  final int playerIndex;
  final bool flat;
  final bool avoidMenuButton;

  @override
  Widget build(BuildContext context) {
    return _ArenaPlayerCell(
      playerIndex: playerIndex,
      counterSpell: context.counterSpell,
      flat: flat,
      avoidMenuButton: avoidMenuButton,
    );
  }
}

class _ArenaPlayerCell extends StatefulWidget {
  const _ArenaPlayerCell({
    required this.playerIndex,
    required this.counterSpell,
    required this.flat,
    required this.avoidMenuButton,
  });

  final int playerIndex;
  final CounterSpell counterSpell;
  final bool flat;
  final bool avoidMenuButton;

  @override
  State<_ArenaPlayerCell> createState() => _ArenaPlayerCellState();
}

class _ArenaPlayerCellState extends State<_ArenaPlayerCell>
    implements ArenaPlayerController {
  /// increment for life editing and commander damage taken editing (if attacking index is not null)
  @override
  Reactive<int> increment = Reactive(0);

  /// whether the advanced options are shown (commander casts, counters)
  @override
  Reactive<bool> advanced = Reactive(false);

  @override
  Reactive<int?> cachedAttackerIndex = Reactive(null);

  @override
  void dispose() {
    increment.dispose();
    advanced.dispose();
    cachedAttackerIndex.dispose();
    super.dispose();
  }

  // only after delay in life or damage mode
  void onApply() {
    if (advanced.value) return;
    final interactionLogic = widget.counterSpell.interactionLogic;
    widget.counterSpell.gameLogic.editGame(
      (game) => game.applySinglePlayerInteraction(
        playerIndex: widget.playerIndex,
        mode: switch ((cachedAttackerIndex.value ??
            interactionLogic.attackingPlayerIndex.value)) {
          null || -1 => InteractionMode.life,
          _ => InteractionMode.damage,
        },
        // other interaction modes are applied directly on their own pages
        increment: increment.value,
        attackingPlayerIndex: cachedAttackerIndex.value,
        selectedCounter: Counter.poison, // unused
        usingPartnerA: interactionLogic.usingPartnerA.value,
      ),
    );
    increment.update(0);
    cachedAttackerIndex.update(null);
    widget.counterSpell.interactionLogic.attackingPlayerIndex.update(null);
  }

  // when increasing the value, the attacking player index is cached to be used in the onApply, so that it doesn't change if the user changes the attacking player before the delay is over
  @override
  void increase() {
    increment.update(increment.value + 1);
    cachedAttackerIndex.update(
      cachedAttackerIndex.value ??
          widget.counterSpell.interactionLogic.attackingPlayerIndex.value ??
          -1,
    );
  }

  @override
  void decrease() {
    increment.update(increment.value - 1);
    cachedAttackerIndex.update(
      cachedAttackerIndex.value ??
          widget.counterSpell.interactionLogic.attackingPlayerIndex.value ??
          -1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final interactionLogic = widget.counterSpell.interactionLogic;
    return interactionLogic.confirmationDelay.build((context, delay) {
      return DelayProvider(
        delay: delay,
        animationDuration: Motion.enterScreenEmphasized.duration,
        onApply: onApply,
        child: CleanProvider<ArenaPlayerController>(
          data: this as ArenaPlayerController,
          child: PlayerCell(
            playerIndex: widget.playerIndex,
            flat: widget.flat,
            avoidMenuButton: widget.avoidMenuButton,
          ),
        ),
      );
    });
  }
}

mixin ArenaPlayerController {
  Reactive<int> get increment;

  Reactive<bool> get advanced;

  Reactive<int?> get cachedAttackerIndex;

  void increase();

  void decrease();
}

extension BuildContextArenaPlayer on BuildContext {
  ArenaPlayerController get arenaPlayerController =>
      provide<ArenaPlayerController>();
}

class PlayerCell extends StatelessWidget {
  const PlayerCell({
    super.key,
    required this.playerIndex,
    required this.flat,
    required this.avoidMenuButton,
  });

  final int playerIndex;
  final bool flat;
  final bool avoidMenuButton;

  @override
  Widget build(BuildContext context) {
    return PlayerCellPadding(
      playerIndex: playerIndex,
      child: PlayerCellDecoration(
        playerIndex: playerIndex,
        flat: flat,
        child: PlayerCellBody(
          playerIndex: playerIndex,
          avoidMenuButton: avoidMenuButton,
        ),
      ),
    );
  }
}
