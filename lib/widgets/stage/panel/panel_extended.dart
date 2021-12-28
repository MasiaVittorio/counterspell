import 'package:counter_spell_new/core.dart';
import 'extended_components/all.dart';


class CSPanelExtended extends StatelessWidget {
  const CSPanelExtended({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StageExtendedPanel<SettingsPage>(
      children: <SettingsPage,Widget>{
        SettingsPage.game: const PanelGame(),
        SettingsPage.info: const PanelInfo(),
        SettingsPage.settings: const PanelSettings(),
        SettingsPage.theme: const PanelTheme(),
      },
    );
  }


}

