import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/alerts/history_alert.dart';
import 'package:counter_spell/widgets/components/builders/has_history_builder.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class ShowHistoryAlertButton extends StatelessWidget {
  const ShowHistoryAlertButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.panelFrameStyle;
    final panelFrame = context.panelFrame;
    void openHistory() => panelFrame.showAlert(const HistoryAlert());

    return HasHistoryBuilder(
      child: Icon(BodyPage.history.outlinedIcon),
      builder: (context, hasHistory, icon) => SquareIconButton(
        dimension: style.collapsedPanelHeight,
        onPressed: hasHistory ? openHistory : null,
        icon: icon!,
      ),
    );
  }
}
