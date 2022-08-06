import 'package:counter_spell_new/core.dart';



class PresetsAlert extends StatelessWidget {
  static const double height = 400.0;

  const PresetsAlert();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context)!;
    final stage = Stage.of(context)!;
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: stage.panelController.panelScrollPhysics(),
        child: bloc.themer.savedSchemes.build((_, savedSchemes) {
          List<CSColorScheme> all = [...CSColorScheme.defaults.values, ...savedSchemes.values];
          List<CSColorScheme> lights = [
            for(final s in all)
              if(s.light) s,
          ]..sort((s1,s2)=>s1.name.compareTo(s2.name));

          Map<DarkStyle,List<CSColorScheme>> darks = {
            for(final style in DarkStyle.values)
              style: [
                for(final s in all) 
                  if((!s.light) && s.darkStyle == style) s,
              ]..sort((s1,s2)=>s1.name.compareTo(s2.name)),
          };

          return Column(children: <Widget>[
            lights.first.applyBaseTheme(child: Section([
              const PanelTitle("Light themes", centered: false,),
              for(final s in lights)
                PresetTile(s),
            ]),),
            for(final style in DarkStyle.values)
              darks[style]!.first.applyBaseTheme(child: Section([
                SectionTitle("${style.name} themes"),
                for(final s in darks[style]!)
                  PresetTile(s),
              ]),),

          ],);
        }),
      ),
    );
  }
}

// TODO: when selecting a preset to load, the margin around the player tiles 
//  doens't update between flat and solid design language

class PresetTile extends StatelessWidget {
  final CSColorScheme scheme;
  const PresetTile(this.scheme);

  static const double _rowSize = _rowPadding*2 + _medalSize;
  static const double _rowPadding = 3.0;
  static const double _medalSize = 36;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    final bloc = CSBloc.of(context);
    final bool deletable = !CSColorScheme.defaults.keys.contains(scheme.name);

    return scheme.applyBaseTheme(child: Material(
      // color: scheme.primary,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0.0),
        title: Text(
          scheme.name, 
          style: TextStyle(color: scheme.accent),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(100),
            color: scheme.primary,
            child: const SizedBox(height: 40, width: 40,),
          ),
        ),
        subtitle: SizedBox(
          height: _rowSize,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              for(final page in stage.mainPagesController.pagesData.keys)
                Padding(
                  padding: const EdgeInsets.all(_rowPadding),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(100),
                    color: scheme.colorPlace.isTexts 
                      ? null 
                      : scheme.perPage[page],
                    child: Container(
                      width: _medalSize,
                      child: Icon(
                        stage.mainPagesController.pagesData[page]!.icon,
                        color: scheme.colorPlace.isTexts 
                          ? scheme.perPage[page]
                          : CSColors.contrastWith(scheme.perPage[page]!),
                      )
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(_rowPadding),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(100),
                  color: scheme.colorPlace.isTexts 
                    ? null 
                    : scheme.defenceColor,
                  child: Container(
                    width: _medalSize,
                    child: Icon(
                      CSIcons.defenceFilled, 
                      color: scheme.colorPlace.isTexts 
                      ? scheme.defenceColor 
                      : CSColors.contrastWith(scheme.defenceColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: deletable 
          ? IconButton(
            icon: const Icon(Icons.delete_forever, color: CSColors.delete,),
            onPressed: (){
              bloc!.themer.savedSchemes.value.remove(scheme.name);
              bloc.themer.savedSchemes.refresh();
            },
          ) 
          : null,
        onTap: (){
          final themeController = stage.themeController;
          final themer = bloc!.themer;

          Map<CSPage,Color> perPage = <CSPage,Color>{
            for(final entry in scheme.perPage.entries)
              entry.key: Color(entry.value.value),
          };  // Copy map

          themeController.colorPlace.set(scheme.colorPlace);
          if(scheme.light){
            if(themeController.brightness.autoDark.value!){
              themeController.brightness.autoDark.set(false);
            }
            themeController.brightness.brightness.setDistinct(Brightness.light);
            // need to be set before editing colors
          
            themeController.currentColorsController.editPanelPrimary(scheme.primary);
            themeController.currentColorsController.editMainPagedPrimaries(perPage);
            themeController.currentColorsController.editAccent(scheme.accent);
          } else {
            if(themeController.brightness.autoDark.value!){
              themeController.brightness.autoDark.set(false);
            } 
            themeController.brightness.brightness.setDistinct(Brightness.dark);
            themeController.brightness.darkStyle.setDistinct(scheme.darkStyle!);
            // need to be set before editing colors

            themeController.currentColorsController.editPanelPrimary(scheme.primary);
            themeController.currentColorsController.editMainPagedPrimaries(perPage);
            themeController.currentColorsController.editAccent(scheme.accent);
          }
          themer.defenceColor.set(scheme.defenceColor);
          stage.closePanel();
        },
      ),
    ),);
  }
}
