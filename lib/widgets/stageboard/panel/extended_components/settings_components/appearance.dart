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
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 8.0),
        child: Row(children: <Widget>[
          Expanded(child: ExtraButton(
            text: "Images",
            icon: Icons.invert_colors,
            onTap: () => stage.showAlert(
              const ImageOpacity(),
              size: ImageOpacity.height,
            ),
          ),),
          Expanded(child: ExtraButton(
            text: "Arena Settings",
            icon: CSIcons.counterSpell,
            iconSize: CSIcons.ideal_counterspell_size,
            iconPadding: CSIcons.ideal_counterspell_padding,
            onTap: () => stage.showAlert(
              const ArenaSettings(),
              size: ArenaSettings.height,
            ),
          ),),
        ].separateWith(CSWidgets.extraButtonsDivider),),
      ),
      CSWidgets.divider,
      settings.alwaysOnDisplay.build((_, alwaysOn) => SwitchListTile(
        value: alwaysOn,
        onChanged: settings.alwaysOnDisplay.set,
        title: const Text("Always on display"),
        secondary: const Icon(Icons.settings_brightness),
      ),),
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