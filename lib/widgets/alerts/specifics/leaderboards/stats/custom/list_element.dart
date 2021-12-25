import 'package:counter_spell_new/core.dart';
import 'single_screen/single_screen.dart';

class CustomStatWidget extends StatelessWidget {

  static const double heigth = 156.0;

  final CustomStat stat;
  final VoidCallback onSingleScreenCallback;

  const CustomStatWidget(this.stat, {
    required this.onSingleScreenCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Section([
      SectionTitle(stat.title),
      SubSection([
        ExtraButtons(children: [
          InfoDisplayer(
            title: Text("Appearances"), 
            background: const Icon(McIcons.cards), 
            value: Text("${stat.appearances}"),
            detail: Text("(Total)"),
          ),
          InfoDisplayer(
            title: Text("Wins"), 
            background: const Icon(McIcons.trophy), 
            value: Text("${stat.wins}"),
            color: CSColors.gold,
            detail: Text("(Overall)"),
          ),
        ]),
      ], onTap: (){
        this.onSingleScreenCallback?.call();
        Stage.of(context)!.showAlert(
          CustomStatSingleScreen(stat),
          size: CustomStatSingleScreen.height,
        );
      },),
    ]);
  }
}