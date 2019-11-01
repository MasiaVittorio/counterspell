import 'package:counter_spell_new/business_logic/bloc.dart';
import 'package:counter_spell_new/app_structure/pages.dart';
import 'package:counter_spell_new/core.dart';
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

    return themeController.primaryColorsMap.build((_, map)
      => Section(<Widget>[
        SectionTitle("Colors"),
        for(final page in closedPages.pagesData.keys)
          ListTile(
            title: Text(closedPages.pagesData[page].longName),
            leading: Icon(
              closedPages.pagesData[page].icon, 
              color: map[page],
            ),
            trailing: CircleAvatar(backgroundColor: map[page],),
            onTap: () => pickPageColor(stage, page, map),
          ),
        bloc.themer.theme.build((context, csTheme)
          => ListTile(
            title: Text("Commander Defence"),
            leading: Icon(
              CSTypesUI.defenceIconFilled, 
              color: csTheme.commanderDefence,
            ),
            trailing: CircleAvatar(backgroundColor: csTheme.commanderDefence,),
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
            trailing: CircleAvatar(backgroundColor: primary,),
            onTap:() => pickPrimaryColor(stage, primary),
          ),
        ),
      ],),
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
}