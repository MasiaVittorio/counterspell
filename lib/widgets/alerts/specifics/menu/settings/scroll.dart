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
      _sens.build((_,sens) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionTitle("Scroll Sensitivity: ${((sens*10.round()) /10).toStringAsFixed(1)}"),
          Slider(
            min: 4.0,
            max: 14.0,
            onChanged: _sens.set,
            value: sens,
          ),
          CSWidgets.heigth10,
        ],
      ),),
      titleSize: 108.0, 
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
            SubSection(<Widget>[
              CSWidgets.heigth5,
              _speedValue.build((_, speedValue) =>  CSSlider(
                onChangeEnd: _speedValue.set,
                enabled: speed,
                value: speedValue,
                min: 0.1,
                max: 0.95,
                title: (val)=>"Speed Weight: ${val.toStringAsFixed(1)}",
              )),
            ],),
            CSWidgets.heigth10,
          ],),),

          _preBoost.build((_,preBoost) => Section([
            SwitchListTile(
              value: preBoost,
              onChanged: _preBoost.set,
              title: const Text("Sens boost before 1"),
              subtitle: const Text("Avoid being stuck around 0"),
            ),
            SubSection(<Widget>[
              CSWidgets.heigth5,
              _preBoostValue.build((_, preBoostValue) =>  CSSlider(
                onChangeEnd: _preBoostValue.set,
                enabled: preBoost,
                value: preBoostValue,
                min: 1.2,
                max: 3.5,
                title: (val)=>"Boost multiplier: ${val.toStringAsFixed(1)}",
              )),
            ],),
            CSWidgets.heigth10,
          ],),),

          _oneStatic.build((_,oneStatic) => Section([
            SwitchListTile(
              value: oneStatic,
              onChanged: _oneStatic.set,
              title: const Text("Sens dampening around 1"),
              subtitle: const Text("Slow down in the range [1,2]"),
            ),
            SubSection(<Widget>[
              CSWidgets.heigth5,
              _oneStaticValue.build((_, oneStaticValue) =>  CSSlider(
                onChangeEnd: _oneStaticValue.set,
                enabled: oneStatic,
                value: oneStaticValue,
                min: 0.1,
                max: 0.95,
                title: (val)=>"Dampening multiplier: ${val.toStringAsFixed(1)}",
              )),
            ],),
            CSWidgets.heigth10,
          ],),),

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