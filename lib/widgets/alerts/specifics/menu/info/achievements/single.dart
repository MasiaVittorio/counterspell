import 'package:counter_spell_new/core.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
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
        canvasBackground: true,
        alreadyScrollableChild: true,
        child: Padding(
          padding: const EdgeInsets.only(top: PanelTitle.height),
          child: Column(children: <Widget>[
            AchievementAgnosticSection(achievement),          
            Expanded(child: MediaQuery.removePadding(
              removeBottom: true,
              removeTop: true,
              removeLeft: true,
              removeRight: true,
              context: context,
              child: SubSection(<Widget>[
                Expanded(child: achieveHints[achievement.shortTitle] ?? Container(),),
              ]),
            )),
          ].separateWith(CSWidgets.height10, alsoLast: true),),
        ),
      );
    });
  }
}

class AchievementAgnosticSection extends StatelessWidget {
  const AchievementAgnosticSection(this.achievement);
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context);
    final StageData stage = Stage.of(context);

    return SubSection(<Widget>[
      ListTile(
        leading: Icon(Achievements.icons[achievement.shortTitle]),
        title: Text(achievement.title),
        subtitle: Text("(${achievement.text})", style: TextStyle(fontStyle: FontStyle.italic),),
        trailing: IconButton(
          icon: Icon(McIcons.restart),
          onPressed: () => stage.showAlert(
            ConfirmAlert(
              action: () => bloc.achievements.reset(achievement.shortTitle, force: true),
              warningText: "Reset this achievement's progress?",
            ),
            size: ConfirmAlert.height,
          ),
        ),
      ),
    ],);
  }

}