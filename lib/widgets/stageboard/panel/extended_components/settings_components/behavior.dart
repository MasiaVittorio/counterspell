import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/ui_model/icons/material_community_icons.dart';
import 'package:counter_spell_new/widgets/resources/alerts/settings/scroll.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/section.dart';
import 'package:stage/stage.dart';

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
        leading: Icon(McIcons.gesture_swipe_horizontal),
        onTap: () => stage.showAlert(
          const ScrollSensitivity(),
          alertSize: ScrollSensitivity.height,
        ),
      ),
    ]);
  }
}