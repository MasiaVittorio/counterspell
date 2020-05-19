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
          final style = themeController.brightness.darkStyle.value;
          final brightness = themeController.brightness.brightness.value;

          final defaultScheme = CSColorScheme.defaultScheme(brightness.isLight, style); 
          Map<CSPage,Color> perPage = <CSPage,Color>{
            for(final entry in defaultScheme.perPage.entries)
              entry.key: Color(entry.value.value),
          }; // copy the map

          themeController.colors.editPanelPrimary(defaultScheme.primary);
          themeController.colors.editMainPagedPrimaries(perPage);
          themeController.colors.editAccent(defaultScheme.accent);
        },
      ),size: ConfirmAlert.height),
    );
  }
}