import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stageboard/stageboard_components.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CSBloc bloc = CSBloc.of(context)!;
    
    return WillPopScope(
      onWillPop: bloc.scroller!.decidePop,
      child: Stage<CSPage?,SettingsPage?>(
        controller: bloc.stageBloc!.controller,

        collapsedPanel: const CSPanelCollapsed(key: WidgetsKeys.collapsed,),

        extendedPanel: const CSPanelExtended(key: WidgetsKeys.extendedPanel,),

        body: const CSBody(key: WidgetsKeys.body,),

        topBarContent: StageTopBarContent(
          title: const CSTopBarTitle(key: WidgetsKeys.animatedAppTitle,),
          subtitle: StageTopBarSubtitle<SettingsPage>(
            (settingsPage) => settingsThemes[settingsPage]!.longName,
          ),
          elevations: <StageColorPlace,double>{
            StageColorPlace.texts: 4,
            StageColorPlace.background: 16,
          },
        ),
        
        backgroundColor: (theme, place) => place.isTexts 
          ? theme.scaffoldBackgroundColor 
          : Colors.black,

        splashScreen: const StageSplashScreen(
          background: Color(0xFF263133), 
          icon: Icon(CSIcons.counterSpell, color: Colors.white, size: 40,),
        ),

        shadowBuilder: (val, place) => BoxShadow(
            blurRadius: place.isTexts 
              ? val.mapToRangeLoose(2.0, 6.0) 
              : val.mapToRangeLoose(10.0, 20.0), 
            color: const Color(0x50000000),
            offset: Offset(
              0.0, 
              place.isTexts ? 3 : 7,
            ),
          ),
      ),
    );

  }

}

