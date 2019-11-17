import 'package:counter_spell_new/core.dart';
import 'package:sidereus/reusable_widgets/material_color_picker/sheet_color_picker.dart';

class ThemeColors extends StatelessWidget {
  const ThemeColors();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final themeController = stage.themeController;
    final closedPages = stage.pagesController;
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);


    return BlocVar.build2(themeController.primaryColorsMap, bloc.payments.unlocked ,builder: (_, map, unlocked){
      
      final List<Widget> children = [
        for(final page in closedPages.pagesData.keys)
          ListTile(
            title: Text(closedPages.pagesData[page].name),
            leading: ColorCircle(map[page], icon: closedPages.pagesData[page].icon,),
            onTap: () => pickPageColor(stage, page, map),
          ),
        bloc.themer.theme.build((context, csTheme)
          => ListTile(
            title: Text("Defence"),
            leading: ColorCircle(csTheme.commanderDefence, icon: CSTypesUI.defenceIconFilled),
            onTap: () => pickDefenceColor(stage, csTheme),
          ),
        ),    
      ];

      return Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Section(<Widget>[
            SectionTitle("CounterSpell Colors"),
            for(final couple in partition(children,2))
              if(couple.length == 1) couple[0]
              else Row(children: <Widget>[
                Expanded(child: couple[0]),
                Expanded(child: couple[1],)
              ],)
          ],),
          if(!unlocked)
            Positioned.fill(child: GestureDetector(
              onTap: () => stage.showAlert(const Support(), size: Support.height),
              child: Container(
                color: theme.scaffoldBackgroundColor
                    .withOpacity(0.5),
              ),
            ),),
        ],
      );

    },);
  }

  static void pickPageColor(StageData stage, CSPage page, Map<CSPage,Color> map, ) {
    stage.pagesController.pageSet(page);
    stage.showAlert(
      SheetColorPicker(
        underscrollCallback: stage.panelController.closePanel,
        color: map[page],
        onSubmitted: (color){
          stage.themeController.editPrimaryPerPage(
            page, 
            color,
          );
          stage.panelController.closePanel();
        },
      ),
      size: 480.0,
    );
  }

  static void pickDefenceColor(StageData stage, CSTheme csTheme, ) {
    stage.showAlert(
      SheetColorPicker(
        underscrollCallback: stage.panelController.closePanel,
        color: csTheme.commanderDefence ?? Colors.green.shade700,
        onSubmitted: (color){
          stage.themeController.editPrimaryPerPage(
            csTheme.commanderDefence, 
            color,
          );
          stage.panelController.closePanel();
        },
      ),
      size: 480.0,
    );
  }

}


class ColorCircle extends StatelessWidget {
  final Color color;
  final IconData icon;
  const ColorCircle(this.color, {this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color,
      elevation: 4,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
          border: ThemeData.estimateBrightnessForColor(color)==ThemeData.estimateBrightnessForColor(theme.canvasColor) && theme.brightness==Brightness.dark
            ? Border.all(color: theme.colorScheme.onSurface, width: 1)
            : null,
        ),
        child: icon == null ? null : Icon(
          icon, 
          size: 22,
          color: ThemeData.estimateBrightnessForColor(color) == Brightness.light 
            ? Colors.black 
            : Colors.white,
        ),
      ),
    );
  }
}
