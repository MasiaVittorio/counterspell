import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class CollapsedPanelDelayIndicator extends StatelessWidget {
  const CollapsedPanelDelayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final delay = context.provide<DelayController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: delay.buildWithValue(
        builder: (context, value, child) =>
            LinearProgressIndicator(value: value),
      ),
    );
  }
}
