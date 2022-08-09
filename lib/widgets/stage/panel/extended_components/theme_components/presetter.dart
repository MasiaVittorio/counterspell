import 'package:counter_spell_new/core.dart';

class ThemePResetter extends StatelessWidget {
  const ThemePResetter();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final themer = bloc.themer;
    final StageData<CSPage, SettingsPage> stage =
        Stage.of(context) as StageData<CSPage, SettingsPage>;
    final themeController = stage.themeController;
    final derived = themeController.derived;
    final brightnessController = themeController.brightness;

    return BlocVar.build8(
      themer.savedSchemes, themer.defenceColor, 
      derived.currentPrimaryColor, derived.accentColor,
      derived.mainPageToPrimaryColor, brightnessController.brightness, 
      themeController.colorPlace, brightnessController.darkStyle, 
      builder: (
        _, Map<String,CSColorScheme> savedSchemes, Color defenceColor, 
        Color primary, Color accent, 
        Map<CSPage, Color>? perPage, Brightness brightness, 
        StageColorPlace colorPlace, DarkStyle darkStyle,
      ){

        final derivedScheme = CSColorScheme(
          "",
          primary: primary,
          accent: accent,
          perPage: perPage!,
          light: brightness.isLight,
          darkStyle: darkStyle,
          defenceColor: defenceColor,
          colorPlace: colorPlace,
        );

        final bool saved = [
          ...savedSchemes.values,
          ...CSColorScheme.defaults.values,
        ].any((scheme) => scheme.equivalentTo(derivedScheme));

        void save() => stage.showAlert(
          InsertAlert(
            onConfirm: (name) {
              if (CSColorScheme.defaults.keys .contains(name)) return false;
              if (savedSchemes
                  .containsKey(name)) {
                stage.showAlert(
                  ConfirmAlert(
                    warningText:
                        '"$name" is already used',
                    confirmText:
                        "Overwrite $name",
                    confirmIcon: McIcons
                        .content_save_edit,
                    action: () {
                      themer.savedSchemes
                              .value[name] =
                          derivedScheme
                              .renamed(name);
                      themer.savedSchemes
                          .refresh();
                    },
                  ),
                  size: ConfirmAlert.height,
                );
                return false;
              }
              themer.savedSchemes.value[name] =
                  derivedScheme.renamed(name);
              themer.savedSchemes.refresh();
              return true;
            },
            checkErrors: (name) {
              if (name == "") {
                return "Insert name";
              }
              if (CSColorScheme.defaults.keys
                  .contains(name)) {
                return "Avoid default names";
              }
              return null;
            },
            labelText:
                "Save color scheme with name",
          ),
          size: InsertAlert.height,
        );

        void load() => stage.showAlert(
          const PresetsAlert(),
          size: PresetsAlert.height,
        );

        return ButtonTilesRow(children: [
          ButtonTile(
            icon: Icons.input, 
            text: "Load Preset", 
            onTap: load,
          ),
          ButtonTile(
            icon: saved ? Icons.check : McIcons.content_save_outline, 
            text: saved ? "Saved" : "Save", 
            onTap: saved ? null : save,
          ),
        ]);

      },
    );

  }
}
