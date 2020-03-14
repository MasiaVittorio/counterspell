import 'package:counter_spell_new/core.dart';

class AchievementTile extends StatelessWidget {
  
  final Achievement achievement;

  const AchievementTile(this.achievement);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(achievement.shortTitle),
      subtitle: Text(achievement.title),
      leading: Icon(McIcons.medal, color: null,), //TODO: medal color
      trailing: Text("${achievement.count} / ${achievement.targetGold}"),
    );
  }
}