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
      ListTile(
        title: const Text("Scroll Feeling"),
        leading: Icon(Icons.touch_app),
        trailing: Icon(Icons.exit_to_app),
        onTap: () => stage.showAlert(
          const ScrollSensitivity(),
          size: ScrollSensitivity.height,
        ),
      ),
      settings.alwaysOnDisplay.build((_, alwaysOn) => SwitchListTile(
        value: alwaysOn,
        onChanged: settings.alwaysOnDisplay.set,
        title: const Text("Always on display"),
        secondary: const Icon(Icons.settings_brightness),
      ),),
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