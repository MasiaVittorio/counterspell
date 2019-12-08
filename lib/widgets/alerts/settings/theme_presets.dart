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
              const AlertTitle("Light themes", centered: false,),
              for(final s in lights)
                PresetTile(s),
            ]),),
            for(final style in DarkStyle.values)
              darks[style].first.applyBaseTheme(child: Section([
                SectionTitle("${DarkStyles.nameOf(style)} themes"),
                for(final s in darks[style])
                  PresetTile(s),
              ]),),

          ],);
        }),
      ),
    );
  }
}

class PresetTile extends StatelessWidget {
  final CSColorScheme scheme;
  const PresetTile(this.scheme);

  static const double _rowSize = _rowPadding*2 + _medalSize;
  static const double _rowPadding = 3.0;
  static const double _medalSize = 36;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
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
            children: <Widget>[for(final page in stage.pagesController.pagesData.keys)
              Padding(
                padding: const EdgeInsets.all(_rowPadding),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(100),
                  color: scheme.perPage[page],
                  child: Container(
                    width: _medalSize,
                    child: Icon(
                      stage.pagesController.pagesData[page].icon,
                      color: CSColors.contrastWith(scheme.perPage[page]),
                    )
                  ),
                ),
              ),
              bloc.themer.defenceColor.build((_, defence) => Padding(
                padding: const EdgeInsets.all(_rowPadding),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(100),
                  color: defence,
                  child: Container(
                    width: _medalSize,
                    child: Icon(
                      CSIcons.defenceIconFilled, 
                      color: CSColors.contrastWith(defence),
                    ),
                  ),
                ),
              ),),
            ],
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
          Map<CSPage,Color> perPage = <CSPage,Color>{
            for(final entry in scheme.perPage.entries)
              entry.key: Color(entry.value.value),
          };

          if(scheme.light){
            if(themeController.autoDark.value){
              if(themeController.light.value == false){
                themeController.autoDark.set(false);
                themeController.light.set(true);
              } 
            } else {
              themeController.light.setDistinct(true);
            }
            themeController.lightPrimary.set(scheme.primary);
            themeController.lightPrimaryPerPage.set(perPage);
            themeController.lightAccent.set(scheme.accent);
          } else {
            if(themeController.autoDark.value){
              if(themeController.light.value){
                themeController.autoDark.set(false);
                themeController.light.set(false);
              } 
            } else {
              themeController.light.setDistinct(false);
            }
            themeController.darkStyle.setDistinct(scheme.darkStyle);
            themeController.darkPrimariesPerPage.value[scheme.darkStyle] = perPage;
            themeController.darkPrimariesPerPage.refresh();

            themeController.darkPrimaries.value[scheme.darkStyle] = scheme.primary;
            themeController.darkPrimaries.refresh();

            themeController.darkAccents.value[scheme.darkStyle] = scheme.accent;
            themeController.darkAccents.refresh();
          }
          stage.panelController.closePanel();
        },
      ),
    ),);
  }
}
