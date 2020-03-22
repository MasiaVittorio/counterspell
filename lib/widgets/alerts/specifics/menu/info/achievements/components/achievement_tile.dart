import 'package:counter_spell_new/core.dart';

class AchievementTile extends StatelessWidget {
  
  final Achievement achievement;

  const AchievementTile(this.achievement);

  @override
  Widget build(BuildContext context) {
    final StageData stage = Stage.of(context);
    final ThemeData theme = Theme.of(context);

    return Section(<Widget>[
      InkWell(
        onTap: () => stage.showAlert(
          AchievementAlert(achievement.shortTitle), 
          size: AchievementAlert.height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title: Text(achievement.shortTitle),
              subtitle: Text(achievement.title),
              trailing: Container(
                // padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: SubSection.getColor(theme),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AspectRatio(
                  aspectRatio: 1, 
                  child: Center(child: Text("${achievement.count}/${achievement.targetGold}")),
                ),
              ),
            ),
            PodiumProgressBar(achievement.count, 
              bronze: achievement.targetBronze, 
              silver: achievement.targetSilver, 
              gold: achievement.targetGold,
            ),
          ],
        ),
      ),
    ],);
  }
}


class PodiumProgressBar extends StatelessWidget {

  final int bronze;
  final int silver;
  final int gold;
  final int current;

  PodiumProgressBar(int current, {
    @required this.bronze,
    @required this.silver,
    @required this.gold,
  }): current = current.clamp(0, gold);

  int target(Medal medal) => <Medal,int>{
    Medal.bronze: this.bronze,
    Medal.silver: this.silver,
    Medal.gold: this.gold,
  }[medal];

  static const double barHeight = 12.0;
  static const double iconsHeight = 28.0;
  static const double height = barHeight + iconsHeight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onSurface;
    final Medal currentMedal = current >= gold ? Medal.gold : current >= silver ? Medal.silver : current >= bronze ? Medal.bronze : null;
    final Color accentColor = currentMedal?.colorOnTheme(theme) ?? theme.accentColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
      child: SizedBox(
        height: height,
        child: Stack(children: <Widget>[
          Positioned(
            bottom: 0.0,
            height: barHeight,
            left: 0.0,
            right: 0.0,
            child: Row(children: <Widget>[
              Expanded(
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(50)
                  ),
                ),
              ),
            ],),
          ),
          Positioned(
            bottom: 0.0,
            height: barHeight,
            left: 0.0,
            right: 0.0,
            child: Row(children: <Widget>[
              if(current > 0)
                Expanded(
                  flex: current,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(barHeight/2)
                    ),
                  ),
                )
              else
                Container(
                  height: barHeight,
                  width: barHeight,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(barHeight/2)
                  ),
                ),
              if(gold > current)Spacer(flex: gold - current,)
            ],),
          ),
          for(final medal in Medal.values)
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              height: iconsHeight,
              child: Align(
                alignment: Alignment(target(medal).mapToRange(-1, 1, fromMax: gold, fromMin: 0), 0),
                child: PodiumIcon(medal, size: iconsHeight * 0.7, colored: target(medal) <= current),
              ),
            ),
        ],),
      ),
    );
  }
}