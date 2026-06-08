import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/components/common/colored_tile.dart';
import 'package:counter_spell/widgets/components/project/icons/layout_edit_icon.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PreferListViewTile extends StatelessWidget {
  const PreferListViewTile({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final settingsLogic = counterSpell.settingsLogic;

    return settingsLogic.preferListView.build((context, prefer) {
      return ColoredTile(
        title: const Text('Prefer list view'),
        leading: Icon(switch (prefer) {
          true => Icons.list,
          false => LayoutEditIcon.outlinedIcon,
        }),
        subtitle: AnimatedText(
          prefer
              ? 'Use the scrollable list even with a low player count'
              : "Don't use the scrollable list with a low player count",
        ),
        lowLeading: !prefer,
        containTrailing: false,
        onTap: () {
          settingsLogic.preferListView.update(!prefer);
        },
        trailing: Switch(
          value: prefer,
          onChanged: settingsLogic.preferListView.update,
        ),
      );
    });
  }
}
