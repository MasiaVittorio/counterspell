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
            initialText: (){
              late final String seed1;
              if(derivedScheme.light){
                seed1 = "Light";
              } else {
                switch (derivedScheme.darkStyle) {
                  case DarkStyle.amoled:
                    seed1 = "Amoled";
                    break;
                  case DarkStyle.dark:
                    seed1 = "Dark";
                    break;
                  case DarkStyle.nightBlack:
                    seed1 = "Night Black";
                    break;
                  case DarkStyle.nightBlue:
                    seed1 = "Night Blue";
                    break;
                  default: 
                    seed1 = "Error";
                    break;
                }
              }
              final String seed2 = derivedScheme.colorPlace.isTexts
                ? "Flat"
                : "Solid";
              final String seed = "$seed1 $seed2";
              for(final n in [1,2,3,4,5,6,7,8,9,10]){
                String option = "$seed $n";
                if(!savedSchemes.containsKey(option)){
                  return option;
                }
              }
              return null;
            }(),
            onConfirm: (name) {
              if (CSColorScheme.defaults.keys.contains(name)) return false;
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
            labelText: "Save color scheme with name",
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
