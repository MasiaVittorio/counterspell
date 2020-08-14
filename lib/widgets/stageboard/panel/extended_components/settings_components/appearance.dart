import 'package:counter_spell_new/core.dart';

class SettingsAppearance extends StatelessWidget {
  const SettingsAppearance();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSSettings settings = bloc.settings;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return Section([
      const SectionTitle("Appearance"),
      ExtraButtons(
        children: <Widget>[
          settings.appSettings.alwaysOnDisplay.build((_, alwaysOn) 
            => ExtraButtonToggle(
              value: alwaysOn,
              onChanged: settings.appSettings.alwaysOnDisplay.set,
              text: "Always on display",
              icon: Icons.settings_brightness,
            ),
          ),
          ExtraButton(
            text: "Images",
            icon: Icons.invert_colors,
            onTap: () => stage.showAlert(
              const ImageOpacity(),
              size: ImageOpacity.height,
            ),
          ),
        ],
      ),

      settings.appSettings.numberFontSizeFraction.build(
        (context, val) => FullSlider(
          value: val,
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

      const SectionTitle("History time"),
      bloc.settings.gameSettings.timeMode.build((_,mode)=> RadioSlider(
        onTap: (i) => settings.gameSettings.timeMode.set(TimeMode.values[i]),
        selectedIndex: TimeMode.values.indexOf(mode),
        items: [for(final timeMode in TimeMode.values)
          RadioSliderItem(
            icon: Icon(TimeModes.icons[timeMode]),
            title: Text(TimeModes.nameOf(timeMode)),
          ),
        ],
      )),

    ]);
  }
}