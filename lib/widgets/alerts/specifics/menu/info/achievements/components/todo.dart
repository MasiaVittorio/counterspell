import 'package:counter_spell_new/core.dart';
import 'achievement_tile.dart';

class TodoAchievements extends StatelessWidget {
  const TodoAchievements();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return BlocVar.build2(
      bloc.achievements.todo,
      bloc.achievements.map,
      builder: (_, Set<String> todo, Map<String,Achievement> map){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for(final shortTitle in todo)
              if(map[shortTitle]!= null) 
                AchievementTile(map[shortTitle]),
          ].separateWith(CSWidgets.divider),
        );
      },
    );
  }
}