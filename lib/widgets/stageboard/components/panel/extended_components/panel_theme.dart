import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/material_color_picker/sheet_color_picker.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage_board/stage_board.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  @override
  Widget build(BuildContext context) {

    final stageBoard = StageBoard.of(context);
    final closedPages = stageBoard.pagesController;

    return ListView(
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        Section([
          SectionTitle("Screen Colors"),
          for(final page in closedPages.orderedPages)
            ListTile(
              title: Text(closedPages.pageThemes[page].longName),
              leading: Icon(
                closedPages.pageThemes[page].icon, 
                color: closedPages.pageThemes[page].primaryColor,
              ),
              trailing: CircleAvatar(backgroundColor: closedPages.pageThemes[page].primaryColor,),
              onTap: () {
                closedPages.page = page;
                stageBoard.showAlert(
                  SheetColorPicker(
                    underscrollCallback: stageBoard.panelController.closePanel,
                    color: closedPages.pageThemes[page].primaryColor ?? Colors.green.shade700,
                    onSubmitted: (color){
                      closedPages.editPageTheme(page, 
                        primaryColor: color,
                      );
                      stageBoard.panelController.closePanel();
                    },
                  ),
                  alertSize: 480.0,
                );
              },
            ),
        ]),
      ],
    );
  }
}
