import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/stageboard_components.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CSBloc bloc = CSBloc.of(context);
    
    return WillPopScope(
      onWillPop: bloc.scroller.decidePop,
      child: Stage<CSPage,SettingsPage>(
        accentSelectedPage: false,
        forceOpenedPanelOverNavBar: true,

        controller: bloc.stageBloc.controller,
        collapsedPanel: const CSPanelCollapsed(key: WidgetsKeys.homePage,),

        extendedPanel: const CSPanelExtended(key: WidgetsKeys.extendedPanel,),

        body: const CSBody(key: WidgetsKeys.body,),

        openedPanelSubtitle: (settingsPage)=>settingsThemes[settingsPage].longName,
        appBarTitle: const CSTopBarTitle(key: WidgetsKeys.animatedAppTitle,),

        backToClosePanel: true,
        backToDefaultPageClosed: true,
        backToDefaultPageOpened: true,
        backToPreviousPageClosed: false,
        backToPreviousPageOpened: false,

        onPanelOpen: bloc.scroller.cancel,
        onPanelClose: () {
          bloc.stageBloc.playerDetailsPage = null;
        },

        pandaOpenedPanelBottomBar: true,
        backgroundColor: (theme) => Colors.black,
        splashScreenBackground: const Color(0xFF263133),
        splashScreenIcon: const Icon(CSIcons.counterSpell, color: Colors.white, size: 40,),
      ),
    );

  }

}

