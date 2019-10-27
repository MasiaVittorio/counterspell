import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/models/ui/type_ui.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/material_color_picker/sheet_color_picker.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

class ThemeColors extends StatelessWidget {
  const ThemeColors();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final themeController = stage.themeController;
    final closedPages = stage.pagesController;
    final bloc = CSBloc.of(context);

    return BlocVar.build3(
      themeController.primaryColorsMap, 
      themeController.panelPrimaryColor, 
      closedPages.orderedPages,
      builder: (_, map, primary, orderedPages)
        => Section(<Widget>[
          SectionTitle("Colors"),
          for(final page in orderedPages)
            ListTile(
              title: Text(closedPages.pagesData[page].longName),
              leading: Icon(
                closedPages.pagesData[page].icon, 
                color: map[page],
              ),
              trailing: CircleAvatar(backgroundColor: map[page],),
              onTap: () {
                closedPages.pageSet(page);
                stage.showAlert(
                  SheetColorPicker(
                    underscrollCallback: stage.panelController.closePanel,
                    color: map[page],
                    onSubmitted: (color){
                      themeController.editPrimaryPerPage(
                        page, 
                        color,
                      );
                      stage.panelController.closePanel();
                    },
                  ),
                  alertSize: 480.0,
                );
              },
            ),
          bloc.themer.theme.build((context, csTheme)
            => ListTile(
              title: Text("Commander Defence"),
              leading: Icon(
                CSTypesUI.defenceIconFilled, 
                color: csTheme.commanderDefence,
              ),
              trailing: CircleAvatar(backgroundColor: csTheme.commanderDefence,),
              onTap: () {
                stage.showAlert(
                  SheetColorPicker(
                    underscrollCallback: stage.panelController.closePanel,
                    color: csTheme.commanderDefence ?? Colors.green.shade700,
                    onSubmitted: (color){
                      themeController.editPrimaryPerPage(
                        csTheme.commanderDefence, 
                        color,
                      );
                      stage.panelController.closePanel();
                    },
                  ),
                  alertSize: 480.0,
                );
              },
            ),
          ),
          ListTile(
            title: Text("Primary Color"),
            leading: Icon(
              Icons.palette,
              color: primary,
            ),
            trailing: CircleAvatar(backgroundColor: primary,),
            onTap: () {
              stage.showAlert(
                SheetColorPicker(
                  underscrollCallback: stage.panelController.closePanel,
                  color: primary,
                  onSubmitted: (color){
                    themeController.editPrimaryDefault(color);
                    stage.panelController.closePanel();
                  },
                ),
                alertSize: 480.0,
              );
            },            
          ),
        ],),
    );
  }
}