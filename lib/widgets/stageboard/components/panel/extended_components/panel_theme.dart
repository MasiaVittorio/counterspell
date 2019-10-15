import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/material_community_icons.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
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
    final bloc = CSBloc.of(context);

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
        bloc.themer.theme.build( (context, theme) {
          return Section([
            SectionTitle("Overall Theme"),
            RadioSlider(
              selectedIndex: theme.light ? 0:1,
              items: [
                RadioSliderItem(
                  icon: const Icon(McIcons.weather_sunny),
                  title: const Text("Light"),
                ),
                RadioSliderItem(
                  icon: const Icon(McIcons.weather_night),
                  title: const Text("Dark"),
                ),
              ],
              onTap: (i) => bloc.themer.theme.set(
                theme.copyWith(light: i==0)
              ),
            ),
            AnimatedListed(
              duration: const Duration(milliseconds: 220),
              listed: !theme.light,
              child:  ListTile(
                title: const Text("Dark Style:"),
                trailing: AnimatedText(
                  text: darkNamesMap[theme.darkStyle],
                  duration: MyDurations.fast,
                ),
                leading: const Icon(Icons.format_color_fill),
                onTap: (){
                  bloc.themer.theme.set(
                    theme.copyWith(
                      darkStyle: nextDarkStyle(
                        theme.darkStyle
                      ),
                    )
                  );
                },
              ),
              // child: Column(
              //   mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: <Widget>[
              //     const Divider(),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
              //       child: InkWell(
              //         onTap: (){
              //           bloc.themer.theme.set(theme.copyWith(
              //             darkStyle: nextDarkStyle(theme.darkStyle),
              //           ));
              //         },
              //         child: Align(
              //           alignment: Alignment.centerRight,
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              //             child: AnimatedText(
              //               duration: const Duration(milliseconds: 220),
              //               text: "Dark Style: ${darkNamesMap[theme.darkStyle]}",
              //               style: TextStyle(
              //                 inherit: true,
              //                 color: RightContrast(Theme.of(context)).onCanvas,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ]);
        }),
      ],
    );
  }
}
