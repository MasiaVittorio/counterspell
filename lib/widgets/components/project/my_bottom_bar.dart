import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class MyBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const MyBottomBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final pagesLogic = counterSpell.pagesLogic;
    final interactionLogic = counterSpell.interactionLogic;
    final delay = context.delay;
    final frame = context.panelFrame;

    return pagesLogic.bodyPage.build((context, value) {
      return HorizontalNavigationBar(
        extraTopPadding: context.safe.top,
        height: 64,
        value: value,
        onChanged: (value) {
          pagesLogic.bodyPage.update(value);
          frame.closeSnackBar();
          delay.cancel();
          interactionLogic.cancelAdvancedInteraction();
        },
        items: BodyPage.navigationItems,
      );
    });
  }
}
