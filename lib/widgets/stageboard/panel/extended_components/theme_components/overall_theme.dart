import 'package:counter_spell_new/core.dart';


class OverallTheme extends StatelessWidget {
  const OverallTheme();
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final themeController = stage.themeController;
    final theme = Theme.of(context);

    return BlocVar.build5(
      themeController.autoDark, 
      themeController.light,
      themeController.darkStyle,
      themeController.timeOfDay,
      bloc.payments.unlocked,
      builder: (_, autoDark, light, darkStyle, timeOfDay, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Section([
            AlertTitle("Brightness", centered: false),

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
                  final current = themeController.darkStyle.value;
                  themeController.darkStyle.setDistinct(DarkStyles.next[current]);
                },
              ),
            ),
          ]),
          if(!unlocked)
            Positioned.fill(child: GestureDetector(
              onTap: () => stage.showAlert(const Support(), size: Support.height),
              child: Container(
                color: theme.scaffoldBackgroundColor
                    .withOpacity(0.5),
              ),),
            ),
        ],
      ),
    );
  }
}