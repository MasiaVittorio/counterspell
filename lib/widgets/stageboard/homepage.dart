import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/counterspell_widget_keys.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/widgets/stageboard/scaffold_components.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return StageBoard<CSPage,dynamic>(
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

      openedPanelTitle: (_) => "CounterSpell",
      customAppBarTitle: const CSTopBarTitle(),

      backToClosePanel: true,
      backToDefaultPageClosed: true,
      backToDefaultPageOpened: false,
      backToPreviousPageClosed: false,
      backToPreviousPageOpened: false,

    );

  }

      // CSPage.history: Color(0xFF424242),
      // CSPage.counters: Color(0xFF263133), 
      // CSPage.life: Color(0xFF2E7D32), 
      // CSPage.commander: Color(0xFF00838F),


}

