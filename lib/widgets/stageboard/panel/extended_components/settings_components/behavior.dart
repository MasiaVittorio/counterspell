import 'package:counter_spell_new/core.dart';

class SettingsBehavior extends StatelessWidget {
  const SettingsBehavior();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    final stage = Stage.of(context);
    return Section([
      const SectionTitle("Behavior"),
      settings.wantVibrate.build((_, vibrate)
        => SwitchListTile(
          value: vibrate,
          onChanged: settings.wantVibrate.set,
          title: const Text("Vibration"),
          secondary: const Icon(Icons.vibration),
        ),
      ),
      _divider,
      settings.confirmDelay.build((_, dur) => CSSliderEnd(
        icon: const Icon(Icons.timelapse),
        value: dur.inMilliseconds.toDouble(),
        min: 200,
        max: 2000,
        onChangeEnd: (val) => settings.confirmDelay.set(Duration(milliseconds: val.round())),
        title: (val) => "Confirm delay: ${_fromMilliseconds(val.round())}",
        restartTo: CSSettings.confirmDelayVal.inMilliseconds.toDouble(),
        bigTitle: true,
      )),
      _divider,
      ListTile(
        title: const Text("Scroll Feeling"),
        leading: Icon(McIcons.gesture_swipe_horizontal),
        onTap: () => stage.showAlert(
          const ScrollSensitivity(),
          alertSize: ScrollSensitivity.height,
        ),
      ),
    ]);
  }

  static const _divider = Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child:Divider(height: 8.0,));
}

String _fromMilliseconds(int mil){
  if(mil >= 1000){
    return "${(mil/10).round() / 100} seconds";
  } else {
    return "$mil ms";
  }
}