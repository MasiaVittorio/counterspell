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


