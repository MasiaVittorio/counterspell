import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/leaderboards/stats/stats.dart';

import 'all.dart';

enum _LeadType {
  history,
  stats,
  info,
}

class Leaderboards extends StatelessWidget {
  const Leaderboards({super.key});

  static const double height = 800.0;

  static const String pageKey = "leaderboardsAlert";
  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context)!;
    return RadioHeaderedAlert<_LeadType>(
      initialValue:
          stage.panelController.alertController.savedStates[pageKey] ??
              _LeadType.history,
      onPageChanged: (p) =>
          stage.panelController.alertController.savedStates[pageKey] = p,
      orderedValues: const [_LeadType.stats, _LeadType.history, _LeadType.info],
      items: const <_LeadType, RadioHeaderedItem>{
        _LeadType.stats: RadioHeaderedItem(
          longTitle: "Statistics",
          title: "Stats",
          icon: Icons.timeline,
          child: LeaderboardsStats(),
          alreadyScrollableChild: true,
        ),
        _LeadType.history: RadioHeaderedItem(
          longTitle: "Past games",
          title: "Games",
          icon: Icons.history,
          child: PastGamesList(),
          alreadyScrollableChild: true,
        ),
        _LeadType.info: RadioHeaderedItem(
          longTitle: "Leaderboards info",
          title: "Info",
          icon: Icons.info,
          unselectedIcon: Icons.info_outline,
          child: LeaderboardsSettings(),
        ),
      },
      // animationType: RadioAnimation.none,
    );
  }
}
