import 'package:counter_spell_new/core.dart';

class SettingsAppearance extends StatelessWidget {
  const SettingsAppearance();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context)!;
    final CSSettings settings = bloc.settings!;
    final StageData<CSPage,SettingsPage>? stage = Stage.of(context);

    return Section([
      const SectionTitle("Appearance"),
      ExtraButtons(
        flexes: [9,6,6],
        children: <Widget>[
          settings.appSettings.alwaysOnDisplay.build((_, alwaysOn) 
            => ExtraButtonToggle(
              value: alwaysOn,
              onChanged: settings.appSettings.alwaysOnDisplay.set,
              text: "Always on display",
              icon: Icons.settings_brightness,
              // twoLines: true,
            ),
          ),
          ExtraButton(
            text: "Images",
            icon: Icons.invert_colors,
            onTap: () => stage!.showAlert(
              const ImageOpacity(),
              size: ImageOpacity.height,
            ),
          ),
          ExtraButton(
            text: "History",
            icon: CSIcons.historyFilled,
            onTap: () => stage!.showAlert(
              const HistoryTimeAlert(),
              size: HistoryTimeAlert.size,
            )
          ),
        ],
      ),

      settings.appSettings.numberFontSizeFraction.build(
        (context, val) => FullSlider(
          value: val!,
          onChangeEnd: settings.appSettings.numberFontSizeFraction.set,
          titleBuilder: (v) {
            final mapped = v.mapToRangeLoose(
              0.1, 1.0, 
              fromMax: 0.32, fromMin: 0.25,
            );
            return Text("Number font size: ${mapped.toStringAsFixed(2)}");
          },
          min: 0.25,
          max: 0.32,
          leading: Icon(
            Icons.text_fields, 
            size: val * CSSizes.minTileSize * 1.2,
          ),
          defaultValue: 0.27,
          divisions: 18,
        ),
      ),

    ]);
  }
}