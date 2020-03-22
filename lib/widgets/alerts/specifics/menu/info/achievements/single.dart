import 'package:counter_spell_new/core.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'data/all.dart';

class AchievementAlert extends StatelessWidget {

  final String shortTitle;

  static const double height = 550;

  const AchievementAlert(this.shortTitle);

  @override
  Widget build(BuildContext context) {
    
    return CSBloc.of(context).achievements.map.build((_,map){
      final Achievement achievement = map[shortTitle];
      return HeaderedAlert(
        achievement.shortTitle,
        // canvasBackground: true,
        alreadyScrollableChild: true,
        child: Padding(
          padding: const EdgeInsets.only(top: AlertTitle.height),
          child: Column(children: <Widget>[
            AchievementAgnosticSection(achievement),          
            Expanded(child: Section(<Widget>[
              Expanded(child: achieveHints[achievement.shortTitle] ?? Container()),
            ], last: true),),
          ],),
        ),
      );
    });
  }
}

class AchievementAgnosticSection extends StatelessWidget {
  const AchievementAgnosticSection(this.achievement);
  final Achievement achievement;

  static const double contentHeight = 140;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle subhead = theme.textTheme.subhead;
    final CSBloc bloc = CSBloc.of(context);
    final StageData stage = Stage.of(context);

    return Section(<Widget>[
      SectionTitle(achievement.title),
      CSWidgets.height5,
      SizedBox(
        height: contentHeight,
        child: Row(children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SubSection.withoutMargin(<Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                          child: Text(achievement.text, style: subhead),
                        ),
                      ),
                    ],),
                  ),
                  CSWidgets.height12,
                  // ListTile(
                  //   dense: true,
                  //   title: const Text("Reset"),
                  //   leading: const Icon(McIcons.restart),
                  //   onTap: () {
                  //     stage.showAlert(
                  //       ConfirmAlert(
                  //         action: () => bloc.achievements.reset(achievement.shortTitle),
                  //         warningText: "Reset this achievement's progress?",
                  //       ),
                  //       size: ConfirmAlert.height,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          InkResponse(
            // borderRadius: BorderRadius.circular(contentHeight),
            radius: contentHeight/2.4,
            onTap: () {
              stage.showAlert(
                ConfirmAlert(
                  action: () => bloc.achievements.reset(achievement.shortTitle),
                  warningText: "Reset this achievement's progress?",
                ),
                size: ConfirmAlert.height,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18.0),
              width: contentHeight,
              child: SleekCircularSlider(
                appearance: appearance(Medal.gold, theme),
                initialValue: (achievement.count / achievement.targetGold).clamp(0, 1) * 100.0,
                innerWidget: (_) => Stack(alignment: Alignment.center, children: <Widget>[
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: SleekCircularSlider(
                        appearance: appearance(Medal.silver, theme),
                        initialValue: (achievement.count / achievement.targetSilver).clamp(0.0, 1.0) * 100.0,
                        innerWidget: (_) => Padding(
                          padding: const EdgeInsets.all(padding),
                          child: SleekCircularSlider(
                            appearance: appearance(Medal.bronze, theme),
                            initialValue: (achievement.count / achievement.targetBronze).clamp(0.0, 1.0) * 100.0,
                            innerWidget: (_) => Container(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text("${achievement.count}")),
                  for(final m in Medal.values)
                    Positioned(
                      bottom: (trackWidth + padding*0.3) * <Medal,int>{
                        Medal.bronze: 2,
                        Medal.silver: 1,
                        Medal.gold: 0,
                      }[m],
                      child: Text(
                        "${achievement.target(m)}", 
                        style: TextStyle(
                          fontSize: labelSize, 
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: (trackWidth + padding*0.3) * 2 + labelSize + 3,
                    child: Container(
                      width: 12,
                      height: 1,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],),
              ),
            ),
          ),
        ],),
      ),
    ],);
  }

  static const double padding = 12.0;
  static const double labelSize = trackWidth*1.45;
  static const double trackWidth = 8;

  CircularSliderAppearance appearance(Medal medal, ThemeData theme) {
    final double angle = <Medal,double>{
      Medal.bronze: 45,
      Medal.silver: 40,
      Medal.gold: 35,
    }[medal];
    return CircularSliderAppearance(
      animationEnabled: false, 
      startAngle: 90 + angle,
      angleRange: 360 - angle*2,
      size: contentHeight * 0.7,
      customWidths: CustomSliderWidths(
        shadowWidth: 0,
        trackWidth: trackWidth,
        progressBarWidth: trackWidth,
        handlerSize: 0,
      ),
      customColors: CustomSliderColors(
        progressBarColor: medal.colorOnTheme(theme),
        trackColor: theme.colorScheme.onSurface.withOpacity(0.1),
        progressBarColors: null,
        hideShadow: true,
      ),
    );
  }
}