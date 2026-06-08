import 'dart:math';

import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class RandomAlert extends StatelessWidget implements PreferredSizeWidget {
  const RandomAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return context.counterSpell.gameLogic.buildWithGame((context, value) {
      return _RandomAlert(
        names: value.settings.playerSettings.map((e) => e.name).toList(),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(600);
}

class _RandomAlert extends StatefulWidget {
  const _RandomAlert({required this.names});

  final List<String> names;

  @override
  State<_RandomAlert> createState() => _RandomAlertState();
}

class _RandomAlertState extends State<_RandomAlert> {
  GlobalKey<AnimatedListState> listKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  List<String> get names => widget.names;

  static Random? _random;
  Random get random => _random ??= Random();
  int nextInt(int max) => random.nextInt(max);
  bool nextBool() => random.nextBool();
  String nextPlayer() => names[nextInt(names.length)];
  int nextDiceRoll() => nextInt(maxDiceRoll) + 1;
  int nextD20() => nextInt(20) + 1;

  int maxDiceRoll = 6;

  List<Roll> rolls = [];

  _Mode mode = _Mode.player;

  void roll() {
    setState(() {
      rolls.insert(0, switch (mode) {
        _Mode.coin => CoinFlip(nextBool()),
        _Mode.dice => DiceRoll(nextDiceRoll(), maxDiceRoll),
        _Mode.player => PlayerRoll(nextPlayer()),
      });
      listKey.currentState?.insertItem(1);
    });
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Easings.emphasizedDecelerate,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final layout = context.theme.layout;

    return PanelList.custom(
      height: 600,
      padTrailing: false,
      trailing: AnimatedOpacity(
        opacity: mode == _Mode.dice ? 1 : 0,
        duration: Motion.beginAndEndOnScreenStandard.duration,
        child: InkResponse(
          onTap: toggleDice,
          child: Pad(
            horizontal: layout.margin.small,
            child: Column(
              children: [
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: toggleDice,
                  icon: Icon(
                    maxDiceRoll == 6 ? MdiIcons.diceMultiple : MdiIcons.diceD20,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedSlider<_Mode>(
            segments: [
              SliderSegment(
                value: _Mode.player,
                label: const Text('Player'),
                unselectedIcon: Icon(MdiIcons.accountMultipleOutline),
                selectedIcon: Icon(MdiIcons.accountMultiple),
              ),
              SliderSegment(
                value: _Mode.dice,
                label: const Text('Dice'),
                selectedIcon: Icon(switch (maxDiceRoll) {
                  6 => MdiIcons.diceMultiple,
                  _ => MdiIcons.diceD20,
                }),
                unselectedIcon: Icon(switch (maxDiceRoll) {
                  6 => MdiIcons.diceMultipleOutline,
                  _ => MdiIcons.diceD20Outline,
                }),
              ),
              SliderSegment(
                value: _Mode.coin,
                label: const Text('Coin'),
                selectedIcon: Icon(MdiIcons.circleMultiple),
                unselectedIcon: Icon(MdiIcons.circleMultipleOutline),
              ),
            ],
            value: mode,
            allowDeselectOnTap: false,
            onSelect: (value) => setState(() {
              mode = value!;
            }),
          ),
          Space.vertical(layout.spacing.medium),
          CallToAction(
            action: roll,
            label: Text(switch (mode) {
              _Mode.coin => 'Flip coin',
              _Mode.dice => 'Roll d$maxDiceRoll',
              _Mode.player => 'Pick random player',
            }),
            icon: switch (mode) {
              _Mode.coin => Icon(MdiIcons.circleMultiple),
              _Mode.dice => Icon(switch (maxDiceRoll) {
                6 => MdiIcons.diceMultiple,
                20 => MdiIcons.diceD20,
                _ => MdiIcons.diceMultipleOutline,
              }),
              _Mode.player => Icon(MdiIcons.accountMultiple),
            },
          ),
        ],
      ),
      title: const Text('Random'),
      customBuilder: (context, invisibleHeader, invisibleBottom) {
        return AnimatedList(
          controller: scrollController,
          padding: EdgeInsets.zero,
          physics: CallbackScrollPhysics(
            topBounce: false,
            bottomBounce: true,
            bottomBounceCallback: frame.closePanel,
          ),
          key: listKey,
          reverse: true,
          itemBuilder: (context, index, animation) {
            if (index == 0) return invisibleBottom!;
            if (index == rolls.length + 1) return invisibleHeader;
            return AnimatedBuilder(
              animation: animation,
              child: RollTile(roll: rolls[index - 1]),
              builder: (context, child) {
                return Align(
                  heightFactor: animation.value,
                  alignment: Alignment.topCenter,
                  child: child!,
                );
              },
            );
          },
          initialItemCount: rolls.length + 2,
        );
      },
    );
  }

  void toggleDice() {
    setState(() {
      maxDiceRoll = maxDiceRoll == 6 ? 20 : 6;
    });
  }
}

sealed class Roll {}

final class PlayerRoll extends Roll {
  PlayerRoll(this.player);

  final String player;
}

final class DiceRoll extends Roll {
  DiceRoll(this.value, this.max);

  final int value;
  final int max;
}

final class CoinFlip extends Roll {
  CoinFlip(this.isHeads);

  final bool isHeads;
}

enum _Mode {
  player,
  dice,
  coin;

  const _Mode();
}

class RollTile extends StatelessWidget {
  const RollTile({super.key, required this.roll});

  final Roll roll;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Pad(
      horizontal: layout.margin.medium,
      vertical: layout.spacing.small / 2,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(
              flex: roll is PlayerRoll ? 15 : 10,
              child: switch (roll) {
                PlayerRoll roll => _Roll(child: Text(roll.player)),
                _ => const SizedBox(),
              },
            ),
            Expanded(
              flex: roll is DiceRoll ? 15 : 10,
              child: switch (roll) {
                DiceRoll roll => _Roll(
                  child: switch (roll.max) {
                    6 => switch (roll.value) {
                      1 => Icon(MdiIcons.dice1),
                      2 => Icon(MdiIcons.dice2),
                      3 => Icon(MdiIcons.dice3),
                      4 => Icon(MdiIcons.dice4),
                      5 => Icon(MdiIcons.dice5),
                      6 => Icon(MdiIcons.dice6),
                      _ => Icon(MdiIcons.diceMultiple),
                    },
                    _ => Text('${roll.value} / d${roll.max}'),
                  },
                ),
                _ => const SizedBox(),
              },
            ),
            Expanded(
              flex: roll is CoinFlip ? 15 : 10,
              child: switch (roll) {
                CoinFlip roll => _Roll(
                  child: Text(roll.isHeads ? 'Heads' : 'Tails'),
                ),
                _ => const SizedBox(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Roll extends StatelessWidget {
  const _Roll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(layout.radius.medium),
      child: Center(child: child),
    );
  }
}
