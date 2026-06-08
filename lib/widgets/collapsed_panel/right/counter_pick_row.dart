import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/counter.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CounterPickRow extends StatelessWidget {
  const CounterPickRow({super.key, required this.frameStyle});

  final PanelFrameStyleData frameStyle;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final interactionLogic = counterSpell.interactionLogic;

    return interactionLogic.selectedCounter.build(
      (context, value) => Row(
        children: [
          for (final counter in Counter.values)
            CounterToggle(counter: counter, value: value),
        ],
      ),
    );
  }
}

class CounterToggle extends StatelessWidget {
  const CounterToggle({super.key, required this.value, required this.counter});

  final Counter counter;
  final Counter value;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final frameStyle = context.panelFrameStyle;
    final interactionLogic = counterSpell.interactionLogic;
    final theme = context.theme;
    final layout = theme.layout;

    final isSelected = counter == value;

    return SizedBox.square(
      dimension: frameStyle.collapsedPanelHeight,
      child: InkResponse(
        onTap: isSelected
            ? null
            : () => interactionLogic.selectCounter(counter),
        containedInkWell: false,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          margin: isSelected
              ? EdgeInsets.all(layout.margin.small)
              : EdgeInsets.zero,
          duration: Motion.beginAndEndOnScreenEmphasized.duration,
          curve: Motion.beginAndEndOnScreenEmphasized.curve,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: isSelected ? 1 : 0,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Icon(
              isSelected ? counter.filledIcon : counter.outlinedIcon,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
