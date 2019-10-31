import 'package:counter_spell_new/core.dart';
import 'settings_components/all.dart';

const Set<CSPage> disablablePages = const {
  CSPage.commanderDamage, 
  CSPage.commanderCast, 
  CSPage.counters,
};

class PanelSettings extends StatelessWidget {
  const PanelSettings();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final pagesController = stage.pagesController;
    final pageThemes = pagesController.pagesData;
    final enabledPages = pagesController.enabledPages;
    
    return enabledPages.build((_, enabledPages)=> SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            const AlertTitle("Enabled Screens", centered: false),
            for(final page in disablablePages)
              SwitchListTile(
                title: Text(pageThemes[page].longName),
                value: enabledPages[page],
                onChanged: (_) => pagesController.togglePage(page),
                secondary: Icon(pageThemes[page].icon),
              ),
          ]),
          const SettingsBehavior(),
        ],
      ),
    ));
  }
}