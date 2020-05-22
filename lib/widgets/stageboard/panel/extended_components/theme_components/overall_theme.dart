import 'package:counter_spell_new/core.dart';

class OverallTheme extends StatelessWidget {
  const OverallTheme();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final themeController = stage.themeController;
    final theme = Theme.of(context);

    return BlocVar.build5(
      themeController.brightness.autoDark, 
      themeController.brightness.brightness,
      themeController.brightness.darkStyle,
      themeController.brightness.autoDarkMode,
      bloc.payments.unlocked,
      builder: (_, bool autoDark, Brightness brightness, DarkStyle darkStyle, AutoDarkMode autoDarkMode, bool unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Section([
                PanelTitle("Base Theme", centered: false),
                Row(children: const <Widget>[
                  Expanded(child: StagePanelSingleColor()),
                  Expanded(child: StageAccentColor()),
                ],),
              ]),
              const Section([
                SectionTitle("Brightness"),
                StageBrightnessToggle(),
              ]),
            ],
          ),
          if(!unlocked)
            Positioned.fill(child: GestureDetector(
              onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
              child: Container(
                color: theme.scaffoldBackgroundColor
                    .withOpacity(0.5),
              ),),
            ),
        ],
      ),
    );
  }

}