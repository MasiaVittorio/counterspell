// import 'package:counter_spell/core.dart';
// import 'components/all.dart';

// class AchievementsAlert extends StatelessWidget {

//   const AchievementsAlert({this.initialDone = false});
//   final bool initialDone; 

//   static const double height = 550;

//   static const String pageKey = "achievementsListAlert";
  
//   @override
//   Widget build(BuildContext context) {
//     final stage = Stage.of(context)!;

//     return RadioHeaderedAlert<bool>(  // true = done
//       initialValue: stage.panelController.alertController.savedStates[pageKey] ?? initialDone ?? false,
//       onPageChanged: (p) => stage.panelController.alertController.savedStates[pageKey] = p,
//       orderedValues: const [false,true], 
//       accentSelected: true,
//       items: const <bool,RadioHeaderedItem>{
//         false: RadioHeaderedItem(
//           longTitle: "Currently open", 
//           title: "To do",
//           child: TodoAchievements(), 
//           icon: McIcons.target,
//         ),
//         true: RadioHeaderedItem(
//           longTitle: "Completed", 
//           title: "Done",
//           child: DoneAchievements(), 
//           icon: McIcons.bookmark_check,
//           unselectedIcon: McIcons.bookmark_outline,
//         ),
//       },
//     );
//   }
// }