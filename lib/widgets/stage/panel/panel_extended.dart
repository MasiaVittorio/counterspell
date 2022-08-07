import 'package:counter_spell_new/core.dart';
import 'extended_components/all.dart';


class CSPanelExtended extends StatelessWidget {
  const CSPanelExtended({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StageExtendedPanel<SettingsPage>(
      children: <SettingsPage,Widget>{
        SettingsPage.game: PanelGame(),
        SettingsPage.info: PanelInfo(),
        SettingsPage.settings: PanelSettings(),
        SettingsPage.theme: PanelTheme(),
      },
      customBackground: transparent,
    );
  }

  static Color transparent(ThemeData theme) => Colors.transparent;

}

