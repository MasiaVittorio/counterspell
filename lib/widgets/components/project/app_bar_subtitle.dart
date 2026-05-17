import 'package:counter_spell/logic/pages_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class AppBarSubtitle extends StatelessWidget {
  const AppBarSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return context.pagesLogic.panelPage.build((context, panelPage) {
      return AnimatedText(panelPage.longLabel);
    });
  }
}
