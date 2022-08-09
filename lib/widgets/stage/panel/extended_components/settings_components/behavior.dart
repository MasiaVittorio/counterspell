import 'package:counter_spell_new/core.dart';

class SettingsBehavior extends StatelessWidget {
  const SettingsBehavior();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final CSSettings settings = bloc.settings;
    final scrollSettings = settings.scrollSettings;
    final StageData<CSPage,SettingsPage>? stage = Stage.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PanelTitle("Gestures", centered: false,),
        ButtonTilesRow(
          children: <Widget>[
            ButtonTile(
              text: "Scroll Sensitivity",
              icon: Icons.gesture,
              onTap: () => stage!.showAlert(
                const ScrollSensitivity(),
                size: ScrollSensitivity.height,
              ),
            ),
            settings.appSettings.wantVibrate.build((_, vibrate)
              => ToggleTile(
                text: "Haptic Feedback: ${vibrate ? 'on' : 'off'}",
                icon: McIcons.vibrate,
                iconOff: McIcons.vibrate_off,
                onChanged: settings.appSettings.wantVibrate.set,
                value: vibrate,
              ),
            ),
          ],
        ),
        scrollSettings.confirmDelay.build((_, dur) => FullSlider(
          mainAxisMargin: 10,
          crossAxisMargin: 0,
          leading: const Icon(Icons.timelapse),
          value: dur.inMilliseconds.toDouble(),
          min: 500,
          max: 2000,
          divisions: 30,
          onChangeEnd: (val) => scrollSettings.confirmDelay.set(Duration(milliseconds: val.round())),
          titleBuilder: (val) => Text("Confirm delay: ${_fromMilliseconds(val.round())}"),
          defaultValue: CSSettingsScroll.confirmDelayVal.inMilliseconds.toDouble(),
        ),),
        const Space.vertical(10),
      ],
    );
  }

}

String _fromMilliseconds(int mil){
  if(mil >= 1000){
    return "${(mil/10).round() / 100} seconds";
  } else {
    return "$mil ms";
  }
}