import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/business_logic/sub_blocs/settings.dart';
import 'package:counter_spell_new/widgets/resources/slider_end.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage/stage.dart';

class ScrollSensitivity extends StatelessWidget {
  const ScrollSensitivity();
  static const double height 
          = _hTitle 
          + _hSlider         
            + (_hDividers 
          + _hSwitch 
          + _hBigSlider)*3
          + _hTile;

  static const double _hTitle = 32.0;
  static const double _hSlider = 64.0;
  static const double _hBigSlider = 72.0;
  static const double _hSwitch = 72.0;
  static const double _hDividers = 14.0;
  static const double _hTile = 56.0;

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

    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: Stage.of(context).panelScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              _sens.build((_,sens) => Section([
                SizedBox(
                  height: _hTitle,
                  child: Center(child: Text("Scroll Sensitivity: ${((sens*10.round()) /10).toStringAsFixed(1)}"),),
                ),
                Slider(
                  min: 4.0,
                  max: 14.0,
                  onChanged: _sens.set,
                  value: sens,
                ),
              ],),),

              _speed.build((_,speed) => Section([
                SwitchListTile(
                  value: speed,
                  onChanged: _speed.set,
                  title: const Text("Dynamic sensitivity"),
                  subtitle: const Text("Adjust sens to the speed of your finger"),
                ),
                Container(
                  alignment: Alignment.center,
                  height: _hBigSlider,
                  child: _speedValue.build((_, speedValue) =>  CSSliderEnd(
                    onChangeEnd: _speedValue.set,
                    enabled: speed,
                    value: speedValue,
                    min: 0.1,
                    max: 0.95,
                    title: (val)=>"Speed Weight: ${val.toStringAsFixed(1)}",
                  )),
                ),
              ],),),

              _preBoost.build((_,preBoost) => Section([
                SwitchListTile(
                  value: preBoost,
                  onChanged: _preBoost.set,
                  title: const Text("Sens boost before 1"),
                  subtitle: const Text("Avoid being stuck around 0"),
                ),
                Container(
                  alignment: Alignment.center,
                  height: _hBigSlider,
                  child: _preBoostValue.build((_, preBoostValue) =>  CSSliderEnd(
                    onChangeEnd: _preBoostValue.set,
                    enabled: preBoost,
                    value: preBoostValue,
                    min: 1.2,
                    max: 3.5,
                    title: (val)=>"Boost multiplier: ${val.toStringAsFixed(1)}",
                  )),
                ),
              ],),),

              _oneStatic.build((_,oneStatic) => Section([
                SwitchListTile(
                  value: oneStatic,
                  onChanged: _oneStatic.set,
                  title: const Text("Sens dampening around 1"),
                  subtitle: const Text("Slow down in the range [1,2]"),
                ),
                Container(
                  alignment: Alignment.center,
                  height: _hBigSlider,
                  child: _oneStaticValue.build((_, oneStaticValue) =>  CSSliderEnd(
                    onChangeEnd: _oneStaticValue.set,
                    enabled: oneStatic,
                    value: oneStaticValue,
                    min: 0.1,
                    max: 0.95,
                    title: (val)=>"Dampening multiplier: ${val.toStringAsFixed(1)}",
                  )),
                ),
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
        ),
      ),
    );
  }
}