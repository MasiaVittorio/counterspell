// import 'package:counter_spell_new/core.dart';
// import 'achievement_tile.dart';

// class DoneAchievements extends StatelessWidget {
//   const DoneAchievements();
//   @override
//   Widget build(BuildContext context) {
//     final bloc = CSBloc.of(context);

//     return bloc.achievements.map.build((_, map)
//       => Column(children: <Widget>[
//         for(final achievement in map.values)
//           if(achievement!.gold) 
//             AchievementTile(achievement),
//       ].separateWith(CSWidgets.divider),),
//     );
//   }
// }