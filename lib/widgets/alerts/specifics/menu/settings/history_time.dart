
import 'package:counter_spell_new/core.dart';


class HistoryTimeAlert extends StatelessWidget {

  const HistoryTimeAlert();

  static const double size = 190.0;

  @override
  Widget build(BuildContext context) {

    final timeMode = CSBloc.of(context)!.settings.gameSettings.timeMode;

    return timeMode.build((_, mode) => HeaderedAlert(
      "History screen time mode",
      canvasBackground: true,
      bottom: Center(child: ListTile(
        title: AnimatedText(
          {
            TimeMode.clock: "(Tells you that a change happened at: 21:45)",
            TimeMode.inGame: "(Tells you that a change happened 37 minutes into a game)",
            TimeMode.none: "(Doesn't tell you when a change happened in the history screen)",
          }[mode]!,
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      )),
      child: RadioSlider(
        onTap: (i) => timeMode.set(TimeMode.values[i]),
        selectedIndex: TimeMode.values.indexOf(mode!),
        items: [for(final timeMode in TimeMode.values)
          RadioSliderItem(
            icon: Icon(TimeModes.icons[timeMode]),
            title: Text(TimeModes.nameOf(timeMode)!),
          ),
        ],
      ),
    ));
  }
}

