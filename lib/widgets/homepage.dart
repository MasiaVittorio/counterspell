import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/stage/stageboard_components.dart';

class CSHomePage extends StatelessWidget {
  const CSHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CSBloc bloc = CSBloc.of(context);
    
    return WillPopScope(
      onWillPop: bloc.scroller.decidePop,
      child: Stage<CSPage?,SettingsPage?>(
        controller: bloc.stageBloc.controller,

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
          ? Colors.black 
          // ? theme.canvasColor 
          : Colors.black,

        splashScreen: const StageSplashScreen(
          background: Color(0xFF263133), 
          icon: Icon(CSIcons.counterSpell, color: Colors.white, size: 40,),
        ),

        scaffoldBackgroundFill: const _ScaffoldBackgroundFill(),

        customDecorationBuilder: (val, theme, place, dim, _) => place.isTexts 
          ? BoxDecoration(
              color: bloc.themer.computePanelColor(val, theme),
              borderRadius: BorderRadius.circular(val.mapToRangeLoose(
                dim.panelRadiusClosed, 
                0,
              )),
            )
          : BoxDecoration(
              boxShadow: [BoxShadow(
                blurRadius: val.mapToRangeLoose(10.0, 20.0), 
                color: const Color(0x50000000),
                offset: const Offset(0, 7),
              )],
              borderRadius: BorderRadius.circular(val.mapToRangeLoose(
                dim.panelRadiusClosed, 
                dim.panelRadiusOpened,
              )),
              color: theme.canvasColor,
            ),
      ),
    );

  }

}



class _ScaffoldBackgroundFill extends StatelessWidget {
  const _ScaffoldBackgroundFill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final theme = Theme.of(context);

    return stage.themeController.colorPlace.build((_, place) => Container(
      color: place.isTexts ? theme.canvasColor : theme.scaffoldBackgroundColor,
    ),);
  }
}