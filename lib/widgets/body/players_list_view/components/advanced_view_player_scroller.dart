import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:counter_spell/widgets/components/project/scroller/scroller_detector.dart';
import 'package:flutter/material.dart';

class AdvancedViewPlayerScroller extends StatelessWidget {
  const AdvancedViewPlayerScroller({
    super.key,
    required this.child,
    required this.ignoreDrag,
    required this.index,
    required this.screenWidth,
  });

  final Widget child;
  final bool ignoreDrag;
  final int index;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final delay = context.delay;
    final interactionLogic = context.counterSpell.interactionLogic;

    return ScrollerDetector(
      onDragEnd: ignoreDrag ? null : delay.consume,
      onDragStart: ignoreDrag
          ? null
          : (_) {
              delay.open();
              interactionLogic.advancedViewScrollStart(index);
            },
      onDragUpdate: ignoreDrag
          ? null
          : (details) {
              interactionLogic.advancedViewScrollUpdate(
                details: details,
                screenWidth: screenWidth,
              );
            },
      child: child,
    );
  }
}
