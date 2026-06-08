import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class OpenPanelMenuButton extends StatelessWidget {
  const OpenPanelMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.panelFrameStyle;
    final panelFrame = context.panelFrame;

    return SquareIconButton(
      dimension: style.collapsedPanelHeight,
      onPressed: panelFrame.openPanel,
      icon: const Icon(Icons.menu),
    );
  }
}
