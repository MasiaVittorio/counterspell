import 'package:counter_spell_new/core.dart';
import 'theme_components/all.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    return SingleChildScrollView(
      physics: stage.panelScrollPhysics(),
      child: Column(
        children: <Widget>[
          const OverallTheme(),
          const ThemeColors(),
          ListTile(
            title: const Text("Reset to default"),
            leading: const Icon(McIcons.restore),
            onTap: () => stage.showAlert(ConfirmStageAlert(
              warningText: "Are you sure? This action cannot be undone.",
              confirmText: "Yes, reset to default colors",
              cancelText: "No, keep the current theme",
              action: () {
                if(stage.themeController.light.value){
                  stage.themeController.lightPrimary.set(CSStage.primary);
                  stage.themeController.lightPrimaryPerPage.set(<CSPage,Color>{
                    for(final entry in defaultPageColorsLight.entries)
                      entry.key: Color(entry.value.value),
                  });
                } else {
                  stage.themeController.darkPrimariesPerPage.value[stage.themeController.darkStyle.value]
                    = <CSPage,Color>{
                      for(final entry in defaultPageColorsDark.entries)
                        entry.key: Color(entry.value.value),
                    };
                  stage.themeController.darkPrimariesPerPage.refresh();
                  stage.themeController.darkPrimaries.value[stage.themeController.darkStyle.value]
                    = CSStage.primary;
                  stage.themeController.darkPrimaries.refresh();
                }
              },
            ),size: ConfirmStageAlert.height),
          ),
        ],
      ),
    );
  }
}
