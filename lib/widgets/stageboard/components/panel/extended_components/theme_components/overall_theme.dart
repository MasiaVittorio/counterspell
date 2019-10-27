import 'package:flutter/material.dart';
import 'package:sidereus/sidereus.dart';
import 'package:stage/stage.dart';

class OverallTheme extends StatelessWidget {
  const OverallTheme();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final themeController = stage.themeController;

    return BlocVar.build4(
      themeController.autoDark, 
      themeController.light,
      themeController.darkStyle,
      themeController.timeOfDay,
      builder: (_, autoDark, light, darkStyle, timeOfDay)
      => Section([
        SectionTitle("Brightness"),

        RadioSlider(
          selectedIndex: autoDark ? 1 : light ? 0 : 2,
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
          listed: autoDark,
          child: RadioSlider(
            title: const Text("Based on:"),
            selectedIndex: timeOfDay ? 0 : 1,
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
          listed: !light,
          child:  ListTile(
            title: const Text("Dark Style:"),
            trailing: AnimatedText(
              text: DarkStyles.nameOf(darkStyle),
              duration: const Duration(milliseconds: 220),
            ),
            leading: const Icon(Icons.format_color_fill),
            onTap: (){
              final current = themeController.darkStyle;
              themeController.darkStyle.set(DarkStyles.next[current]);
            },
          ),
        ),
      ]),
    );
  }
}