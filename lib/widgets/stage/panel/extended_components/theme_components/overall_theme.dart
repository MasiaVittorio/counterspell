import 'package:counter_spell/core.dart';

class OverallTheme extends StatelessWidget {
  const OverallTheme({super.key});
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final bloc = CSBloc.of(context);
    final themeController = stage.themeController;
    final theme = Theme.of(context);

    return BlocVar.build5<bool?, Brightness, DarkStyle, AutoDarkMode?, bool?>(
      themeController.brightness.autoDark,
      themeController.brightness.brightness,
      themeController.brightness.darkStyle,
      themeController.brightness.autoDarkMode,
      bloc.payments.unlocked,
      builder: (_, bool? autoDark, Brightness? brightness, DarkStyle? darkStyle,
              AutoDarkMode? autoDarkMode, bool? unlocked) =>
          Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const PanelTitle("Base Theme", centered: false),
              const SubSection([
                Row(
                  children: <Widget>[
                    Expanded(child: StagePanelSingleColor()),
                    Expanded(child: StageAccentColor()),
                  ],
                ),
              ]),
              const SectionTitle("Brightness"),
              RadioSliderTheme.merge(
                data: RadioSliderThemeData(),
                child: const StageBrightnessToggle(
                  showDarkStylesOnlyIfDark: true,
                ),
              ),
            ],
          ),
          if (!unlocked!)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => stage.showAlert(const SupportAlert(),
                    size: SupportAlert.height),
                child: Container(
                  color: theme.canvasColor.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
