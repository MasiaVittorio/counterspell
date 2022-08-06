// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:counter_spell_new/core.dart';

class ScrollSensitivity extends StatelessWidget {
  const ScrollSensitivity();
  static const double height = 500.0;


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final settings = bloc.settings;
    final scrollSettings = settings.scrollSettings;
    final _sens = scrollSettings.scrollSensitivity;
    final _speed = scrollSettings.scrollDynamicSpeed;
    final _speedValue = scrollSettings.scrollDynamicSpeedValue;
    final _oneStatic = scrollSettings.scroll1Static;
    final _oneStaticValue = scrollSettings.scroll1StaticValue;
    final _preBoost = scrollSettings.scrollPreBoost;
    final _preBoostValue = scrollSettings.scrollPreBoostValue;

    return HeaderedAlertCustom(
      _sens.build((_,sens) => FullSlider(
        titleBuilder: (val) => Text(
          "Scroll Sensitivity: ${((val*10.round()) /10).toStringAsFixed(1)}"
        ),
        min: 4.0,
        max: 14.0,
        divisions: 100,
        onChangeEnd: _sens.set,
        value: sens!,
        leading: const Icon(Icons.gesture),
        defaultValue: CSSettingsScroll.sensVal,
      ),),
      titleSize: 56.0 + 16, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          _speed.build((_,speed) => Section([
            SwitchListTile(
              value: speed!,
              onChanged: _speed.set,
              title: const Text("Dynamic sensitivity"),
              subtitle: const Text("Adjust sens to the speed of your finger"),
            ),
            _speedValue.build((_, speedValue) {
              const min = 0.1;
              const max = 0.95; 
              const delta = max - min;
              const small = min + delta/3;
              const big = min + delta * 2 / 3;
              return FullSlider(
                onChangeEnd: _speedValue.set,
                enabled: speed,
                value: speedValue!,
                min: 0.1,
                max: 0.95,
                divisions: 17,
                defaultValue: CSSettingsScroll.sensSpeedVal,
                leadingBuilder: (val) => Icon(val < small 
                  ? McIcons.speedometer_slow 
                  : val >= big 
                    ? McIcons.speedometer 
                    : McIcons.speedometer_medium
                ),
                titleBuilder: (val) 
                  => Text("Speed Weight: ${val.toStringAsFixed(2)}"),
              );
            }),
            CSWidgets.height10,
          ],),),

          _preBoost.build((_,preBoost) => Section([
            SwitchListTile(
              value: preBoost!,
              onChanged: _preBoost.set,
              title: const Text("Sens boost before 1"),
              subtitle: const Text("Avoid being stuck around 0"),
            ),
            _preBoostValue.build((_, preBoostValue) => FullSlider(
              onChangeEnd: _preBoostValue.set,
              enabled: preBoost,
              value: preBoostValue!,
              min: 1.2,
              max: 3.5,
              divisions: 23,
              defaultValue: CSSettingsScroll.sensPreBoostVal,
              leading: const Icon(Icons.add_circle_outline),
              titleBuilder: (val) 
                => Text("Boost multiplier: ${val.toStringAsFixed(1)}"),
            )),
            CSWidgets.height10,
          ],),),

          _oneStatic.build((_,oneStatic) => Section([
            SwitchListTile(
              value: oneStatic!,
              onChanged: _oneStatic.set,
              title: const Text("Sens dampening around 1"),
              subtitle: const Text("Slow down in the range [1,2]"),
            ),
            _oneStaticValue.build((_, oneStaticValue) => FullSlider(
              onChangeEnd: _oneStaticValue.set,
              enabled: oneStatic,
              value: oneStaticValue!,
              min: 0.1,
              max: 0.95,
              divisions: 17,
              leading: const Icon(Icons.remove_circle_outline),
              defaultValue: CSSettingsScroll.sens1StaticVal,
              titleBuilder: (val) 
                => Text("Dampening multiplier: ${val.toStringAsFixed(2)}"),
            )),
            CSWidgets.height10,
          ],),),

          // settings.arenaSettings.verticalScroll.build((_, vertical)
          //   => SwitchListTile(
          //     value: vertical,
          //     onChanged: settings.arenaSettings.verticalScroll.set,
          //     title: const Text("Vertical Scroll on Arena Mode"),
          //     secondary: const Icon(McIcons.gesture_swipe_down),
          //   ),
          // ),
          // CSWidgets.divider,
          // ListTile(
          //   title: const Text("Restore default values"),
          //   leading: const Icon(Icons.settings_backup_restore),
          //   onTap: (){
          //     _sens.set(CSSettingsScroll.sensVal);
          //     _speed.set(true);
          //     _speedValue.set(CSSettingsScroll.sensSpeedVal);
          //     _preBoost.set(true);
          //     _preBoostValue.set(CSSettingsScroll.sensPreBoostVal);
          //     _oneStatic.set(true);
          //     _oneStaticValue.set(CSSettingsScroll.sens1StaticVal);
          //   },
          // ),

        ],
      ),
    );
  }
}