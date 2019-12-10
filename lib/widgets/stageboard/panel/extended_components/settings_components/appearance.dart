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
      settings.alwaysOnDisplay.build((_, alwaysOn) => SwitchListTile(
        value: alwaysOn,
        onChanged: settings.alwaysOnDisplay.set,
        title: const Text("Always on display"),
        secondary: const Icon(Icons.settings_brightness),
      ),),
      ListTile(
        leading: const Icon(Icons.invert_colors),
        title: const Text("Commander image's opacity"),
        trailing: const Icon(Icons.exit_to_app),
        onTap: () => stage.showAlert(
          const ImageOpacity(),
          size: ImageOpacity.height,
        ),
      ),
      const SectionTitle("History time"),
      bloc.settings.timeMode.build((_,mode)=> RadioSlider(
        onTap: (i) => settings.timeMode.set(TimeMode.values[i]),
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