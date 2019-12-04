import 'package:counter_spell_new/core.dart';

class ThemeResetter extends StatelessWidget {

  const ThemeResetter();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return ListTile(
      title: const Text("Reset to default"),
      leading: const Icon(McIcons.restart),
      onTap: () => stage.showAlert(ConfirmAlert(
        warningText: "Are you sure? This action cannot be undone.",
        confirmText: "Yes, reset to default colors",
        cancelText: "No, keep the current theme",
        action: () {
          final themeController = stage.themeController;
          final style = themeController.darkStyle.value;
          final light = themeController.light.value;
          final defaultScheme = CSColorScheme.defaultScheme(light, style); 
          Map<CSPage,Color> perPage = <CSPage,Color>{
            for(final entry in defaultScheme.perPage.entries)
              entry.key: Color(entry.value.value),
          };

          if(light){
            themeController.lightPrimary.set(defaultScheme.primary);
            themeController.lightPrimaryPerPage.set(perPage);
            themeController.lightAccent.set(defaultScheme.accent);
          } else {
            themeController.darkPrimariesPerPage.value[style] = perPage;
            themeController.darkPrimariesPerPage.refresh();

            themeController.darkPrimaries.value[style] = defaultScheme.primary;
            themeController.darkPrimaries.refresh();

            themeController.darkAccents.value[style] = defaultScheme.accent;
            themeController.darkAccents.refresh();
          }
        },
      ),size: ConfirmAlert.height),
    );
  }
}