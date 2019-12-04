import 'package:counter_spell_new/core.dart';



class PresetsAlert extends StatelessWidget {
  static const double height = 400.0;

  const PresetsAlert();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final stage = Stage.of(context);
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: stage.panelScrollPhysics(),
        child: Column(children: <Widget>[
          bloc.themer.savedSchemes.build((_, savedSchemes) => savedSchemes.isNotEmpty 
            ? Section(<Widget>[
              const AlertTitle("Saved color schemes", centered: false),
              for(final name in savedSchemes.keys.toList()..sort())
                PresetTile(savedSchemes[name]),
            ],)
            : SizedBox(),
          ),
          Section([
            const SectionTitle("Default color schemes"),
            for(final def in CSColorScheme.defaults.values)
              PresetTile(def),
          ], last: true,),
        ],
      ),),
    );
  }
}

class PresetTile extends StatelessWidget {
  final CSColorScheme scheme;
  const PresetTile(this.scheme);
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final bool deletable = !CSColorScheme.defaults.keys.contains(scheme.name);

    return Material(
      color: scheme.primary,
      child:ListTile(
        contentPadding: const EdgeInsets.all(0.0),
        title: Text(scheme.name, style: TextStyle(
          color: ThemeData.estimateBrightnessForColor(scheme.primary) == Brightness.dark
            ? Colors.white
            : Colors.black
        ),),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Material(
            borderRadius: BorderRadius.circular(100),
            color: scheme.accent,
            child: const SizedBox(height: 36, width: 36,),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
          child: SizedBox(
            height: 36.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[for(final page in stage.pagesController.pagesData.keys)
                SidChip(
                  icon: stage.pagesController.pagesData[page].icon,
                  text: stage.pagesController.pagesData[page].name,
                  color: scheme.perPage[page],
                ),
                bloc.themer.defenceColor.build((_, defence) => SidChip(
                  icon: CSTypesUI.defenceIconFilled,
                  text: "Defence",
                  color: defence,
                ),),
              ],
            ),
          ),
        ),
        trailing: deletable 
          ? IconButton(
            icon: const Icon(Icons.delete_forever, color: CSColors.delete,),
            onPressed: (){
              bloc.themer.savedSchemes.value.remove(scheme.name);
              bloc.themer.savedSchemes.refresh();
            },
          ) 
          : null,
        onTap: (){
          final themeController = stage.themeController;
          final style = themeController.darkStyle.value;
          final light = themeController.light.value;
          Map<CSPage,Color> perPage = <CSPage,Color>{
            for(final entry in scheme.perPage.entries)
              entry.key: Color(entry.value.value),
          };

          if(light){
            themeController.lightPrimary.set(scheme.primary);
            themeController.lightPrimaryPerPage.set(perPage);
            themeController.lightAccent.set(scheme.accent);
          } else {
            themeController.darkPrimariesPerPage.value[style] = perPage;
            themeController.darkPrimariesPerPage.refresh();

            themeController.darkPrimaries.value[style] = scheme.primary;
            themeController.darkPrimaries.refresh();

            themeController.darkAccents.value[style] = scheme.accent;
            themeController.darkAccents.refresh();
          }
          stage.panelController.closePanel();
        },
      ),
    );
  }
}
