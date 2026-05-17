import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/collapsed_panel/right/counter_pick_row.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class PickCounterButton extends StatelessWidget {
  const PickCounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final frameStyle = context.panelFrameStyle;
    void onPressed() => frame.showSnackBar(
      PanelSnackBar(
        child: CounterPickRow(frameStyle: frameStyle),
        fromLeft: false,
        scrollable: true,
        dismissible: true,
        duration: null,
      ),
    );

    return context.counterSpell.interactionLogic.selectedCounter.build(
      (context, value) => SquareIconButton(
        dimension: frameStyle.collapsedPanelHeight,
        onPressed: onPressed,
        icon: Icon(value.outlinedIcon),
      ),
    );
  }
}
