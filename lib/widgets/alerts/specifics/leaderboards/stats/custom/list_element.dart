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
        ButtonTilesRow(children: [
          InfoDisplayer(
            title: const Text("Appearances"), 
            background: const Icon(McIcons.cards), 
            value: Text("${stat.appearances}"),
            detail: const Text("(Total)"),
          ),
          InfoDisplayer(
            title: const Text("Wins"), 
            background: const Icon(McIcons.trophy), 
            value: Text("${stat.wins}"),
            color: CSColors.gold,
            detail: const Text("(Overall)"),
          ),
        ]),
      ], onTap: (){
        onSingleScreenCallback.call();
        Stage.of(context)!.showAlert(
          CustomStatSingleScreen(stat),
          size: CustomStatSingleScreen.height,
        );
      },),
    ]);
  }
}