import 'package:counter_spell_new/core.dart';

class ThemeColors extends StatelessWidget {

  const ThemeColors();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);

    return bloc.payments.unlocked.build((_, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          SubSection(<Widget>[
            const SectionTitle("CounterSpell Colors"),
            StageMainColorsPerPage(extraChildren: <Widget>[
              bloc.themer.defenceColor.build((context, defenceColor)
                => ListTile(
                  title: const Text("Defence"),
                  leading: ColorCircleDisplayer(defenceColor, icon: CSIcons.defenceFilled),
                  onTap: () => pickDefenceColor(stage!, defenceColor, bloc),
                ),
              ),
            ],),
          ],),

          if(!unlocked) Positioned.fill(child: GestureDetector(
            onTap: () => stage!.showAlert(const SupportAlert(), size: SupportAlert.height),
            child: Container(
              color: theme.canvasColor
                  .withOpacity(0.5),
            ),
          ),),
        ],
      ),);
  }


  static void pickDefenceColor(StageData stage, Color defenceColor, CSBloc bloc) {
    stage.pickColor(
      initialColor: defenceColor,
      onSubmitted: (color){
        // (defence color changes with the color place, brightness, dark style)
        // saved themes are loaded as intended and change the design language etc
        bloc.themer.resolvableDefenceColor.set(
          bloc.themer.resolvableDefenceColor.value.copyWithState(
            color: color, 
            isLight: bloc.stage.themeController.brightness.brightness
              .value.isLight, 
            isFlat: bloc.stage.themeController.colorPlace
              .value.isTexts, 
            darkStyle: bloc.stage.themeController.brightness.darkStyle
              .value,
            ),
        );
        stage.closePanel();
      },
    );
  }

}


