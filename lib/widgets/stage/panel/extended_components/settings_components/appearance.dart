import 'package:counter_spell_new/core.dart';

class SettingsAppearance extends StatelessWidget {

  const SettingsAppearance({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSSettings settings = bloc.settings;
    final StageData<CSPage,SettingsPage>? stage = Stage.of(context);

    void showHistoryPicker() => stage!.showAlert(
      const HistoryTimeAlert(),
      size: HistoryTimeAlert.size,
    );

    void showImages() => stage!.showAlert(
      const ImageOpacity(),
      size: ImageOpacity.height,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        SubSection([
          const SectionTitle("Appearance"),
          ExtraButtons(
            flexes: compact ? const [9,6,6] : null,
            children: <Widget>[
              alwaysOnToggle(settings.appSettings),
              imagesButton(showImages),
              if(compact)
                historyButton(showHistoryPicker),
            ],
          ),
        ]),
        const Space.vertical(5),
        fontSizeSlider(settings.appSettings),
        
        if(!compact)...[
          const SectionTitle("History screen time mode"),
          historyPicker(settings.gameSettings),
          const Space.vertical(15),
        ],
      ],
    );
  }

  Widget historyPicker(CSSettingsGame gameSettings) 
    => gameSettings.timeMode.build((_, mode) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioSlider(
          onTap: (i) => gameSettings.timeMode.set(TimeMode.values[i]),
          selectedIndex: TimeMode.values.indexOf(mode!),
          items: [for(final timeMode in TimeMode.values)
            RadioSliderItem(
              icon: Icon(TimeModes.icons[timeMode]),
              title: Text(TimeModes.nameOf(timeMode)!),
            ),
          ],
          margin: const EdgeInsets.fromLTRB(10, 8, 10, 7),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedText(
            {
              TimeMode.clock: "(Tells you that a change happened at: 21:45)",
              TimeMode.inGame: "(Tells you that a change happened 37 minutes into a game)",
              TimeMode.none: "(Doesn't tell you when a change happened)",
            }[mode]!,
            style: const TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),);

  Widget fontSizeSlider(CSSettingsApp appSettings) 
    => appSettings.numberFontSizeFraction.build(
      (_, val) => FullSlider(
        mainAxisMargin: 10,
        value: val!,
        onChangeEnd: appSettings.numberFontSizeFraction.set,
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
    );

  Widget alwaysOnToggle(CSSettingsApp appSettings) 
    => appSettings.alwaysOnDisplay.build(
      (_, alwaysOn) => ExtraButtonToggle(
        value: alwaysOn,
        onChanged: appSettings.alwaysOnDisplay.set,
        text: "Always on display",
        icon: Icons.settings_brightness,
        forceExternalSize: true,
      ),
    );

  ExtraButton imagesButton(VoidCallback onTap) => ExtraButton(
    text: compact ? "Images" : "Images opacity",
    forceExternalSize: true,
    icon: Icons.invert_colors,
    onTap: onTap,
  );

  ExtraButton historyButton(VoidCallback showHistoryPicker) => ExtraButton(
    text: "History",
    forceExternalSize: true,
    icon: CSIcons.historyFilled,
    onTap: showHistoryPicker,
  );

}