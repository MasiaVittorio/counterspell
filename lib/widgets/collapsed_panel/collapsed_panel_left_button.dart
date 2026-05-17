import 'package:counter_spell/widgets/collapsed_panel/left/open_menu_button.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';

class CollapsedPanelLeftButton extends StatelessWidget {
  const CollapsedPanelLeftButton({
    super.key,
    required this.hasIncrement,
    required this.onCancel,
  });

  final bool hasIncrement;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return switch (hasIncrement) {
      false => const OpenPanelMenuButton(),
      true => SquareIconButton(
        dimension: context.panelFrameStyle.collapsedPanelHeight,
        onPressed: onCancel,
        icon: const Icon(Icons.close),
      ),
    };
  }
}
