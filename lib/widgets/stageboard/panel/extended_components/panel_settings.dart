import 'package:counter_spell_new/core.dart';
import 'settings_components/all.dart';


class PanelSettings extends StatelessWidget {
  const PanelSettings();
 
  static const Set<CSPage> disablablePages = const {
    CSPage.commanderDamage, 
    CSPage.commanderCast, 
    CSPage.counters,
  };
 
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final pagesController = stage.pagesController;
    final enabledPages = pagesController.enabledPages;
    
    return enabledPages.build((_, enabledPages)=> SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          const SettingsBehavior(),
          const SettingsAppearance(),
        ],
      ),
    ));
  }
}