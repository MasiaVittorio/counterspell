import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/models/ui/type_ui.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/material_color_picker/sheet_color_picker.dart';
import 'package:sidereus/reusable_widgets/reusable_widgets.dart';
import 'package:stage_board/stage_board.dart';


class PanelTheme extends StatelessWidget {
  const PanelTheme();

  @override
  Widget build(BuildContext context) {

    final stageBoard = StageBoard.of(context);
    final themeController = stageBoard.themeController;
    final closedPages = stageBoard.pagesController;
    final primary = themeController.panelPrimaryColor();
    final bloc = CSBloc.of(context);

    return SingleChildScrollView(
      physics: stageBoard.scrollPhysics(),
      child: Column(
        children: <Widget>[
          Section([
            SectionTitle("Brightness"),
            RadioSlider(
              selectedIndex: themeController.autoDark ? 1 : themeController.light ? 0 : 2,
              items: [
                RadioSliderItem(
                  icon: const Icon(Icons.brightness_7),
                  title: const Text("Light"),
                ),
                RadioSliderItem(
                  icon: const Icon(Icons.brightness_auto),
                  title: const Text("Auto"),
                ),
                RadioSliderItem(
                  icon: const Icon(Icons.brightness_2),
                  title: const Text("Dark"),
                ),
              ],
              onTap: (i){
                switch (i) {
                  case 0:
                    themeController.disableAutoDark(true);
                    break;
                  case 1:
                    themeController.enableAutoDark(MediaQuery.of(context));
                    break;
                  case 2:
                    themeController.disableAutoDark(false);
                    break;
                  default:
                }
              },
            ),
            AnimatedListed(
              listed: themeController.autoDark,
              child: RadioSlider(
                title: const Text("Based on:"),
                selectedIndex: themeController.timeOfDay ? 0 : 1,
                onTap: (i){
                  switch (i) {
                    case 0:
                      themeController.autoDarkBasedOnTime();
                      break;
                    case 1:
                      themeController.autoDarkBasedOnSystem(MediaQuery.of(context));
                      break;
                    default:
                  }
                },
                items: const [
                  RadioSliderItem(
                    icon: const Icon(Icons.timelapse),
                    title: const Text("Day time"),
                  ),
                  RadioSliderItem(
                    icon: const Icon(Icons.timeline),
                    title: const Text("System"),
                  ),
                ],
              ),
            ),
            AnimatedListed(
              duration: const Duration(milliseconds: 220),
              listed: !themeController.light,
              child:  ListTile(
                title: const Text("Dark Style:"),
                trailing: AnimatedText(
                  text: DarkStyles.nameOf(themeController.darkStyle),
                  duration: const Duration(milliseconds: 220),
                ),
                leading: const Icon(Icons.format_color_fill),
                onTap: (){
                  final current = themeController.darkStyle;
                  themeController.darkStyle = DarkStyles.next[current];
                },
              ),
            ),
          ]),
          Section(<Widget>[
            SectionTitle("Colors"),
            for(final page in closedPages.orderedPages)
              ListTile(
                title: Text(closedPages.pagesData[page].longName),
                leading: Icon(
                  closedPages.pagesData[page].icon, 
                  color: themeController.primaryColor(page, false, false),
                ),
                trailing: CircleAvatar(backgroundColor: themeController.primaryColor(page, false, false),),
                onTap: () {
                  closedPages.page = page;
                  stageBoard.showAlert(
                    SheetColorPicker(
                      underscrollCallback: stageBoard.panelController.closePanel,
                      color: themeController.primaryColor(page, false, false) ?? Colors.green.shade700,
                      onSubmitted: (color){
                        themeController.editPrimaryPerPage(
                          page, 
                          color,
                        );
                        stageBoard.panelController.closePanel();
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
                  stageBoard.showAlert(
                    SheetColorPicker(
                      underscrollCallback: stageBoard.panelController.closePanel,
                      color: csTheme.commanderDefence ?? Colors.green.shade700,
                      onSubmitted: (color){
                        themeController.editPrimaryPerPage(
                          csTheme.commanderDefence, 
                          color,
                        );
                        stageBoard.panelController.closePanel();
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
                stageBoard.showAlert(
                  SheetColorPicker(
                    underscrollCallback: stageBoard.panelController.closePanel,
                    color: primary,
                    onSubmitted: (color){
                      themeController.editPrimaryDefault(color);
                      stageBoard.panelController.closePanel();
                    },
                  ),
                  alertSize: 480.0,
                );
              },            
            ),
          ],),
        ],
      ),
    );
  }
}
