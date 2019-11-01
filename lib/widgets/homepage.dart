import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/stageboard_bloc.dart';
import 'package:counter_spell_new/app_structure/counterspell_widget_keys.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/widgets/stageboard/stageboard_components.dart';
import 'package:flutter/material.dart';
import 'package:stage/stage.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Stage<CSPage,SettingsPage>(
      accentSelectedPage: false,
      forceOpenedPanelOverNavBar: true,

      controller: CSBloc.of(context).stageBloc.controller,
      collapsedPanel: const CSPanelCollapsed(key: KEY_COLLAPSED,),

      extendedPanel: const CSPanelExtended(),

      body: const CSBody(),

      openedPanelSubtitle: (settingsPage)=>settingsThemes[settingsPage].longName,
      appBarTitle: const CSTopBarTitle(),

      backToClosePanel: true,
      backToDefaultPageClosed: true,
      backToDefaultPageOpened: true,
      backToPreviousPageClosed: false,
      backToPreviousPageOpened: false,

      pandaOpenedPanelBottomBar: true,
      themedBackGround: false,
    );

  }

}

