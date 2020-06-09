import 'package:counter_spell_new/core.dart';

class ScrollSensitivity extends StatelessWidget {
  const ScrollSensitivity();
  static const double height = 500.0;


  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    final _sens = settings.scrollSensitivity;
    final _speed = settings.scrollDynamicSpeed;
    final _speedValue = settings.scrollDynamicSpeedValue;
    final _oneStatic = settings.scroll1Static;
    final _oneStaticValue = settings.scroll1StaticValue;
    final _preBoost = settings.scrollPreBoost;
    final _preBoostValue = settings.scrollPreBoostValue;

    return HeaderedAlertCustom(
      _sens.build((_,sens) => FullSlider(
        titleBuilder: (val) => Text("Scroll Sensitivity: ${((val*10.round()) /10).toStringAsFixed(1)}"),
        min: 4.0,
        max: 14.0,
        onChangeEnd: _sens.set,
        value: sens,
        leading: Icon(Icons.gesture),
        defaultValue: CSSettings.sensVal,
      ),),
      titleSize: 56.0 + 16, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          _speed.build((_,speed) => Section([
            SwitchListTile(
              value: speed,
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
                value: speedValue,
                min: 0.1,
                max: 0.95,
                defaultValue: CSSettings.sensSpeedVal,
                leadingBuilder: (val) => Icon(val < small ? McIcons.speedometer_slow : val >= big ? McIcons.speedometer : McIcons.speedometer_medium),
                titleBuilder: (val) => Text("Speed Weight: ${val.toStringAsFixed(1)}"),
              );
            }),
            CSWidgets.height10,
          ],),),

          _preBoost.build((_,preBoost) => Section([
            SwitchListTile(
              value: preBoost,
              onChanged: _preBoost.set,
              title: const Text("Sens boost before 1"),
              subtitle: const Text("Avoid being stuck around 0"),
            ),
            _preBoostValue.build((_, preBoostValue) => FullSlider(
              onChangeEnd: _preBoostValue.set,
              enabled: preBoost,
              value: preBoostValue,
              min: 1.2,
              max: 3.5,
              defaultValue: CSSettings.sensPreBoostVal,
              leading: Icon(Icons.add_circle_outline),
              titleBuilder: (val) => Text("Boost multiplier: ${val.toStringAsFixed(1)}"),
            )),
            CSWidgets.height10,
          ],),),

          _oneStatic.build((_,oneStatic) => Section([
            SwitchListTile(
              value: oneStatic,
              onChanged: _oneStatic.set,
              title: const Text("Sens dampening around 1"),
              subtitle: const Text("Slow down in the range [1,2]"),
            ),
            _oneStaticValue.build((_, oneStaticValue) => FullSlider(
              onChangeEnd: _oneStaticValue.set,
              enabled: oneStatic,
              value: oneStaticValue,
              min: 0.1,
              max: 0.95,
              leading: Icon(Icons.remove_circle_outline),
              defaultValue: CSSettings.sens1StaticVal,
              titleBuilder: (val) => Text("Dampening multiplier: ${val.toStringAsFixed(1)}"),
            )),
            CSWidgets.height10,
          ],),),

          settings.arenaScreenVerticalScroll.build((_, vertical)
            => SwitchListTile(
              value: vertical,
              onChanged: settings.arenaScreenVerticalScroll.set,
              title: const Text("Vertical Scroll on Arena Mode"),
              secondary: const Icon(McIcons.gesture_swipe_down),
            ),
          ),
          CSWidgets.divider,
          ListTile(
            title: const Text("Restore default values"),
            leading: const Icon(Icons.settings_backup_restore),
            onTap: (){
              _sens.set(CSSettings.sensVal);
              _speed.set(true);
              _speedValue.set(CSSettings.sensSpeedVal);
              _preBoost.set(true);
              _preBoostValue.set(CSSettings.sensPreBoostVal);
              _oneStatic.set(true);
              _oneStaticValue.set(CSSettings.sens1StaticVal);
            },
          ),

        ],
      ),
    );
  }
}