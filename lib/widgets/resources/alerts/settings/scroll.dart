import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';

class ScrollSensitivity extends StatelessWidget {
  const ScrollSensitivity();
  static const double height 
          = _hTitle 
          + _hSlider         
            + _hDividers /////////////
          + _hPre 
          + _hPreSlider
            + _hDividers /////////////
          + _h1Static
          + _h1StaticSlider;

  static const double _hTitle = 32.0;
  static const double _hSlider = 64.0;
  static const double _hPre = 72.0;
  static const double _h1Static = 72.0;
  static const double _hPreSlider = 64.0;
  static const double _h1StaticSlider = 64.0;
  static const double _hDividers = 8.0;
  static const Widget _divider = const Divider(height: _hDividers,);

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final settings = bloc.settings;
    final sens = settings.scrollSensitivity;

    
    return BlocVar.build2(
      settings.scroll1Static,
      settings.scrollPreBoost,
      builder: (_, bool oneStatic, bool preBoost) => SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: _hTitle,
              child: const Center(child: const Text("Scroll Sensitivity"),),
            ),
            SizedBox(
              height: _hSlider,
              child: sens.build((_, sensitivity) => Slider(
                onChanged: (_){},
                onChangeEnd: sens.set,
                value: sensitivity,
              )),
            ),
            _divider,
            SizedBox(
              height: _hPre,
              child: SwitchListTile(
                value: preBoost,
                onChanged: settings.scrollPreBoost.set,
                title: const Text("Sens boost before 1"),
                subtitle: const Text("Avoid being stuck around 0"),
              ),
            ),
            SizedBox(
              height: _hPreSlider,
              child: settings.scrollPreBoostValue.build((_, preBoostValue) => Slider(
                onChanged: preBoost ? (_){} : null,
                onChangeEnd: settings.scrollPreBoostValue.set,
                value: preBoostValue,
              )),
            ),
            _divider,
            SizedBox(
              height: _h1Static,
              child: SwitchListTile(
                value: oneStatic,
                onChanged: settings.scroll1Static.set,
                title: const Text("Sens dampening around 1"),
                subtitle: const Text("Make it easier to scroll a +1 or a -1"),
              ),
            ),
            SizedBox(
              height: _h1StaticSlider,
              child: settings.scroll1StaticValue.build((_, oneStaticValue) => Slider(
                onChanged: oneStatic ? (_){} : null,
                onChangeEnd: settings.scroll1StaticValue.set,
                value: oneStaticValue,
              )),
            ),
          ],
        ),
      ),
    );
  }
}