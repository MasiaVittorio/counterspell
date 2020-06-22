import 'package:counter_spell_new/core.dart';

class SettingsBehavior extends StatelessWidget {
  const SettingsBehavior();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSSettings settings = bloc.settings;
    final StageData<CSPage,SettingsPage> stage = Stage.of(context);

    return Section([
      const PanelTitle("Behavior", centered: false,),
      Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 8.0),
        child: Row(children: <Widget>[
          Expanded(child: settings.wantVibrate.build((_, vibrate)
            => ExtraButton(
              text: "Vibration",
              icon: vibrate ? McIcons.vibrate : McIcons.vibrate_off,
              onTap: () => settings.wantVibrate.set(!vibrate),
            ),
          ),),
          Expanded(child: ExtraButton(
            text: "Scroll Settings",
            icon: Icons.gesture,
            onTap: () => stage.showAlert(
              const ScrollSensitivity(),
              size: ScrollSensitivity.height,
            ),
          ),),
        ].separateWith(CSWidgets.extraButtonsDivider),),
      ),
      // settings.wantVibrate.build((_, vibrate)
      //   => SwitchListTile(
      //     value: vibrate,
      //     onChanged: settings.wantVibrate.set,
      //     title: const Text("Vibration"),
      //     secondary: const Icon(Icons.vibration),
      //   ),
      // ),
      // ListTile(
      //   title: const Text("Scroll Feeling"),
      //   leading: Icon(Icons.touch_app),
      //   trailing: Icon(Icons.keyboard_arrow_right),
      //   onTap: () => stage.showAlert(
      //     const ScrollSensitivity(),
      //     size: ScrollSensitivity.height,
      //   ),
      // ),
      CSWidgets.divider,
      settings.confirmDelay.build((_, dur) => FullSlider(
        leading: const Icon(Icons.timelapse),
        value: dur.inMilliseconds.toDouble(),
        min: 500,
        max: 2000,
        tapToEditBy: 50,
        divisions: 30,
        onChangeEnd: (val) => settings.confirmDelay.set(Duration(milliseconds: val.round())),
        titleBuilder: (val) => Text("Confirm delay: ${_fromMilliseconds(val.round())}"),
        defaultValue: CSSettings.confirmDelayVal.inMilliseconds.toDouble(),
      ),),
    ]);
  }

}

String _fromMilliseconds(int mil){
  if(mil >= 1000){
    return "${(mil/10).round() / 100} seconds";
  } else {
    return "$mil ms";
  }
}