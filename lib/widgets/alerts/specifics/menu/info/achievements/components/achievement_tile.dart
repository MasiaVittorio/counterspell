import 'package:counter_spell_new/core.dart';

class AchievementTile extends StatelessWidget {
  
  final Achievement achievement;

  const AchievementTile(this.achievement);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    final Color goldColor = AchieveUI.colorOnTheme(Medal.gold, theme);
    final Color silverColor = AchieveUI.colorOnTheme(Medal.silver, theme);
    final Color bronzeColor = AchieveUI.colorOnTheme(Medal.bronze, theme);
    final Color neutralColor = theme.colorScheme.onSurface;

    final StageData stage = Stage.of(context);

    return InkWell(
      onTap: () => stage.showAlert(AchievementAlert(achievement), size: AchievementAlert.height),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title: Text(achievement.shortTitle),
              subtitle: Text(achievement.title),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Bronze: ${achievement.targetBronze}", style: TextStyle(color: bronzeColor),),
                  Text("Silver: ${achievement.targetSilver}", style: TextStyle(color: silverColor),),
                  Text("Gold: ${achievement.targetGold}", style: TextStyle(color: goldColor),),
                ],
              ),
            ),
            Slider(
              value: achievement.count.toDouble(),
              max: achievement.targetGold.toDouble(),
              min: 0.0,
              onChanged: (_){},
              activeColor: achievement.gold 
                ? goldColor 
                : achievement.silver 
                  ? silverColor 
                  : achievement.bronze 
                    ? bronzeColor 
                    : neutralColor,
              inactiveColor: achievement.gold 
                ? goldColor //useless
                : achievement.silver 
                  ? goldColor
                  : achievement.bronze
                    ? silverColor
                    : bronzeColor,
            ),
          ],
        ),
      ),
    );
  }
}