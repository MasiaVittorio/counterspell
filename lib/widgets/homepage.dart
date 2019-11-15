import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/stageboard_components.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CSBloc bloc = CSBloc.of(context);
    
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

      onPanelOpen: bloc.scroller.cancel,

      pandaOpenedPanelBottomBar: true,
      backgroundColor: (theme) => Colors.black,
      splashScreenBackground: const Color(0xFF263133),
      splashScreenIcon: const Icon(CsIcon.counter_spell, color: Colors.white, size: 40,),
    );

  }

}

