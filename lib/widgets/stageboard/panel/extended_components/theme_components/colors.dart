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

    return BlocVar.build2(themeController.primaryColorsMap, bloc.payments.unlocked ,builder: (_, map, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Section(<Widget>[
            SectionTitle("Colors"),
            for(final page in closedPages.pagesData.keys)
              ListTile(
                title: Text(closedPages.pagesData[page].longName),
                leading: Icon(
                  closedPages.pagesData[page].icon, 
                  color: map[page],
                ),
                trailing: ColorCircle(map[page]),
                onTap: () => pickPageColor(stage, page, map),
              ),
            bloc.themer.theme.build((context, csTheme)
              => ListTile(
                title: Text("Commander Defence"),
                leading: Icon(
                  CSTypesUI.defenceIconFilled, 
                  color: csTheme.commanderDefence,
                ),
                trailing: ColorCircle(csTheme.commanderDefence,),
                onTap: () => pickDefenceColor(stage, csTheme),
              ),
            ),
            themeController.panelPrimaryColor.build((_, primary) 
              =>ListTile(
                title: Text("Primary Color"),
                leading: Icon(
                  Icons.palette,
                  color: primary,
                ),
                trailing: ColorCircle(primary,),
                onTap:() => pickPrimaryColor(stage, primary),
              ),
            ),
            BlocVar.build4(
              themeController.lightAccent,
              themeController.darkAccents,
              themeController.light,
              themeController.darkStyle,
              builder:(_, Color lightAccent, Map<DarkStyle,Color> darkAccents, bool light, DarkStyle style) {
                final accentColor = light ? lightAccent : darkAccents[style];
                return ListTile(
                  title: Text("Primary Color"),
                  leading: Icon(
                    Icons.palette,
                    color: accentColor,
                  ),
                  trailing: ColorCircle(accentColor,),
                  onTap:() => pickAccentColor(stage, accentColor),
                );
              },
            ),
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
      ),
    );
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

  static void pickPrimaryColor(StageData stage, Color primary) {
    stage.showAlert(
      SheetColorPicker(
        underscrollCallback: stage.panelController.closePanel,
        color: primary,
        onSubmitted: (color){
          stage.themeController.editPrimaryDefault(color);
          stage.panelController.closePanel();
        },
      ),
      size: 480.0,
    );
  }
  static void pickAccentColor(StageData stage, Color accent) {
    stage.showAlert(
      SheetColorPicker(
        underscrollCallback: stage.panelController.closePanel,
        color: accent,
        onSubmitted: (color){
          stage.themeController.editAccent(color);
          stage.panelController.closePanel();
        },
      ),
      size: 480.0,
    );
  }
}


class ColorCircle extends StatelessWidget {
  final Color color;
  const ColorCircle(this.color);

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
          border: ThemeData.estimateBrightnessForColor(color) == ThemeData.estimateBrightnessForColor(theme.canvasColor)
            ? Border.all(color: theme.colorScheme.onSurface, width: 1)
            : null,
        ),
      ),
    );
  }
}

// class ColorCircleIcon extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   const ColorCircleIcon(this.icon, {@required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final Color contrast = ThemeData.estimateBrightnessForColor(color) == ThemeData.estimateBrightnessForColor(theme.canvasColor) 
//       ? theme.colorScheme.onSurface 
//       : theme.canvasColor;
//     return Material(
//       color: color,
//       elevation: 4,
//       borderRadius: BorderRadius.circular(100),
//       child: Container(
//         height: 40,
//         width: 40,
//         child: Icon(icon, color: contrast,),
//       ),
//     );
//   }
// }