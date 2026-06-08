import 'dart:async';

import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellSideTaps extends StatelessWidget {
  const PlayerCellSideTaps({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.arenaPlayerController;
    final delay = context.delay;
    final counterSpell = context.counterSpell;

    void holdUp() {
      controller.nextMultipleOf(1);
      counterSpell.settingsLogic.vibrate();
      delay.open();
    }

    void holdDown() {
      controller.previousMultipleOf(1);
      counterSpell.settingsLogic.vibrate();
      delay.open();
    }

    void nextMultipleOf(int n) {
      controller.nextMultipleOf(n);
      counterSpell.settingsLogic.vibrate();
      delay.tap();
    }

    void previousMultipleOf(int n) {
      controller.previousMultipleOf(n);
      counterSpell.settingsLogic.vibrate();
      delay.tap();
    }

    void onLongPress(Duration duration, Axis direction) {
      if (duration < 650.milliseconds) return;
      int n = switch (duration.inMilliseconds) {
        < 3000 => 5,
        < 6000 => 10,
        < 10000 => 20,
        < 13000 => 50,
        < 16000 => 100,
        < 18000 => 200,
        < 20000 => 500,
        < 22500 => 1000,
        < 25000 => 2000,
        < 27500 => 5000,
        < 30000 => 10000,
        < 32000 => 20000,
        < 34000 => 50000,
        < 36000 => 100000,
        _ => 200000,
      };
      if (direction == Axis.horizontal) {
        previousMultipleOf(n);
      } else {
        nextMultipleOf(n);
      }
    }

    return context.counterSpell.settingsLogic.arenaDirection.build((
      context,
      direction,
    ) {
      return Stack(
        children: [
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: Flex(
                direction: direction,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ContinuedLongPress(
                      onContinuedLongPress: (duration) =>
                          onLongPress(duration, direction),
                      onTapDown: direction == Axis.horizontal
                          ? holdDown
                          : holdUp,
                      onTapUp: delay.tap,
                    ),
                  ),
                  Expanded(
                    child: ContinuedLongPress(
                      onContinuedLongPress: (duration) =>
                          onLongPress(duration, direction.opposite),
                      onTapDown: direction == Axis.horizontal
                          ? holdUp
                          : holdDown,
                      onTapUp: delay.tap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child,
        ],
      );
    });
  }
}

extension on Axis {
  Axis get opposite => switch (this) {
    Axis.horizontal => Axis.vertical,
    Axis.vertical => Axis.horizontal,
  };
}

class ContinuedLongPress extends StatefulWidget {
  const ContinuedLongPress({
    super.key,
    required this.onContinuedLongPress,
    required this.onTapDown,
    required this.onTapUp,
    this.child,
  });

  final Widget? child;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final void Function(Duration duration) onContinuedLongPress;

  @override
  State<ContinuedLongPress> createState() => _ContinuedLongPressState();
}

class _ContinuedLongPressState extends State<ContinuedLongPress> {
  late DateTime tapStart;
  bool tapped = false;

  Timer? timer;

  @override
  void initState() {
    tapStart = DateTime.now();
    super.initState();
  }

  void startTimer() {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer.periodic(350.milliseconds, callback);
  }

  void callback(Timer timer) {
    if (!mounted || !tapped) {
      timer.cancel();
      this.timer = null;
    }
    widget.onContinuedLongPress(DateTime.now().difference(tapStart));
  }

  void onTapDown() {
    tapStart = DateTime.now();
    tapped = true;
    startTimer();
  }

  void onTapUp() {
    tapped = false;
    timer?.cancel();
    timer = null;
    widget.onTapUp();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) {
        widget.onTapDown();
        onTapDown();
      },
      onTapUp: (details) => onTapUp(),
      onTapCancel: () => onTapUp(),
      child: widget.child,
    );
  }
}
