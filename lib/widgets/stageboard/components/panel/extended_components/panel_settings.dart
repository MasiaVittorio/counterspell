import 'package:counter_spell_new/widgets/stageboard/components/panel/extended_components/panel_game.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage_board/stage_board.dart';
//TODO: apply damage to life non cambia mai
class PanelSettings extends StatelessWidget {
  const PanelSettings();
  @override
  Widget build(BuildContext context) {
    // final bloc = CSBloc.of(context);
    final stageBoard = StageBoard.of(context);
    final pagesController = stageBoard.pagesController;
    final pageThemes = pagesController.pagesData;
    final enabledPages = pagesController.enabledPages;
    return SingleChildScrollView(
      physics: stageBoard.scrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const SectionTitle("Enabled Screens"),
            for(final page in disablablePages)
              SwitchListTile(
                title: Text(pageThemes[page].longName),
                value: enabledPages[page],
                onChanged: (_) => pagesController.togglePage(page),
                secondary: Icon(pageThemes[page].icon),
              ),
          ]),
        ],
      ),
    );
  }
}