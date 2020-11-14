import 'package:counter_spell_new/core.dart';

class ThemeColors extends StatelessWidget {

  const ThemeColors();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);
    final placeVar = stage.themeController.colorPlace;
    final themer = bloc.themer;

    return bloc.payments.unlocked.build((_, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Section([
                const SectionTitle("Design patterns"),
                placeVar.build((_, val) => SwitchListTile(
                  value: val.isTexts, 
                  onChanged: (_) => themer.toggleGoogleLikeColors(),
                  title: const Text("Google-like colors"),
                  subtitle: AnimatedText(val.isTexts
                    ? "Colored text"
                    : "Colored background"
                  ),
                  secondary: Icon(val.isTexts 
                    ? McIcons.alpha_a_box_outline
                    : McIcons.alpha_a_box
                  ),
                ),),
                if(!CSThemer.flatLinkedToColorPlace)
                themer.flatDesign.build((context, val) => SwitchListTile(
                  value: val,
                  onChanged: (_) => themer.toggleFlatDesign(),
                  title: const Text("Flat design"),
                  subtitle: const Text("Over material"),
                  secondary: Icon(val
                    ? McIcons.rounded_corner
                    : McIcons.android_studio
                  ),
                )),
              ]),
              Section(<Widget>[
                const SectionTitle("CounterSpell Colors"),
                StageMainColorsPerPage(extraChildren: <Widget>[
                  bloc.themer.defenceColor.build((context, defenceColor)
                    => ListTile(
                      title: const Text("Defence"),
                      leading: ColorCircleDisplayer(defenceColor, icon: CSIcons.defenceIconFilled),
                      onTap: () => pickDefenceColor(stage, defenceColor, bloc),
                    ),
                  ),
                ],),
              ],),
            ],
          ),

          if(!unlocked) Positioned.fill(child: GestureDetector(
            onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
            child: Container(
              color: theme.scaffoldBackgroundColor
                  .withOpacity(0.5),
            ),
          ),),
        ],
      ),);
  }


  static void pickDefenceColor(StageData stage, Color defenceColor, CSBloc bloc) {
    stage.pickColor(
      initialColor: defenceColor ?? Colors.green.shade700,
      onSubmitted: (color){
        bloc.themer.defenceColor.set(color);
        stage.closePanel();
      },
    );
  }

}


