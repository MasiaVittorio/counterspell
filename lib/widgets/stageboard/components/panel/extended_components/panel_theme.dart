import 'package:counter_spell_new/widgets/stageboard/components/panel/extended_components/theme_components/colors.dart';
import 'package:counter_spell_new/widgets/stageboard/components/panel/extended_components/theme_components/overall_theme.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          const OverallTheme(),
          const ThemeColors(),
        ],
      ),
    );
  }
}
