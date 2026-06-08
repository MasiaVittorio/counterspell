import 'package:counter_spell/widgets/alerts/playgroup_edit_alert/playgroup_edit_alert.dart';
import 'package:counter_spell/widgets/components/common/square_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class EditPlaygroupButton extends StatelessWidget {
  const EditPlaygroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    return SquareIconButton(
      dimension: context.panelFrameStyle.collapsedPanelHeight,
      onPressed: () => frame.showAlert(const PlaygroupEditAlert()),
      icon: Icon(MdiIcons.accountMultipleOutline),
    );
  }
}
