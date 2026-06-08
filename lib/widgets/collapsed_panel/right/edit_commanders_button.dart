import 'package:counter_spell/widgets/alerts/commanders_edit/edit_commanders_alert.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class EditCommandersButton extends StatelessWidget {
  const EditCommandersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return SquareIconButton(
      dimension: context.panelFrameStyle.collapsedPanelHeight,
      onPressed: () => frame.showAlert(const EditCommandersAlert()),
      icon: const Center(child: Icon(Icons.edit_outlined)),
    );
  }
}
