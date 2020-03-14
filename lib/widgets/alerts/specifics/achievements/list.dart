import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class AchievementsAlert extends StatelessWidget {

  const AchievementsAlert();

  static const double height = 550;
  
  @override
  Widget build(BuildContext context) {
    return RadioHeaderedAlert<bool>(
      initialValue: false, 
      orderedValues: [false,true], 
      items: const <bool,RadioHeaderedItem>{
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