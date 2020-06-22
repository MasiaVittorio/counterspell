import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class AchievementsAlert extends StatelessWidget {

  const AchievementsAlert();

  static const double height = 550;

  static const String pageKey = "achievementsListAlert";
  
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    return RadioHeaderedAlert<bool>(
      initialValue: stage.panelController.alertController.savedStates[pageKey] ?? false,
      onPageChanged: (p) => stage.panelController.alertController.savedStates[pageKey] = p,
      orderedValues: [false,true], 
      accentSelected: true,
      items: <bool,RadioHeaderedItem>{
        false: RadioHeaderedItem(
          longTitle: "Currently open", 
          title: "To do",
          child: TodoAchievements(), 
          icon: McIcons.target,
        ),
        true: RadioHeaderedItem(
          longTitle: "Completed", 
          title: "Done",
          child: DoneAchievements(), 
          icon: McIcons.bookmark_check,
          unselectedIcon: McIcons.bookmark_outline,
        ),
      },
    );
  }
}