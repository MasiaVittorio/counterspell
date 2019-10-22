import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/blocs/sub_blocs/stageboard_bloc.dart';
import 'package:counter_spell_new/structure/counterspell_widget_keys.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/widgets/stageboard/stageboard_components.dart';
import 'package:flutter/material.dart';
import 'package:stage_board/stage_board.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return StageBoard<CSPage,SettingsPage>(
      accentSelectedPage: false,
      centeredClosedAppBar: true,
      centeredOpenedAppBar: true,
      openedPanelOverNavBar: true,

      controller: CSBloc.of(context).stageBoard.controller,
      collapsedPanelBuilder: (context, val, child) {
        return IgnorePointer(
          ignoring: val != 0.0,
          child: Opacity(
            opacity: 1-val,
            child: child,
          ),
        );
      },
      collapsedPanelChild: const CSPanelCollapsed(key: KEY_COLLAPSED,),

      extendedPanelChild: const CSPanelExtended(),

      body: const CSBody(),

      openedPanelSubtitle: (settingsPage)=>settingsThemes[settingsPage].longName,
      customAppBarTitle: const CSTopBarTitle(),

      backToClosePanel: true,
      backToDefaultPageClosed: true,
      backToDefaultPageOpened: true,
      backToPreviousPageClosed: false,
      backToPreviousPageOpened: false,

      pandaOpenedPanelBottomBar: true,
      // materialGradient: true,
    );

  }

}

