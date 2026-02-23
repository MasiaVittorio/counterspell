import 'package:counter_spell/core.dart';

import 'settings_components/all.dart';

class PanelSettings extends StatelessWidget {
  const PanelSettings({super.key});

  static const Set<CSPage> disablablePages = {
    CSPage.commanderDamage,
    CSPage.commanderCast,
    CSPage.counters,
  };

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;

    return LayoutBuilder(
        builder: (_, constraints) => ConstrainedBox(
              constraints: constraints,
              child: SingleChildScrollView(
                physics: stage.panelController.panelScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    const SettingsBehavior(),
                    const Divider(
                      height: 7,
                    ),
                    const Space.vertical(8),
                    SettingsAppearance(compact: constraints.maxHeight < 645),
                    const Divider(
                      height: 7,
                    ),
                    const Space.vertical(10),
                    const SettingsData(),
                  ],
                ),
              ),
            ));
  }
}
