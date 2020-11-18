import 'package:counter_spell_new/core.dart';
import 'all.dart';

class LeaderboardsStats extends StatelessWidget {

  const LeaderboardsStats();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    const pageKey = "leaderboards_stats_page_key"; 
    return RadioHeaderedAlert<String>(
      initialValue: stage.panelController.alertController.savedStates[pageKey] ?? "commanders",
      onPageChanged: (p) => stage.panelController.alertController.savedStates[pageKey] = p,
      items: const <String,RadioHeaderedItem>{
        "players": RadioHeaderedItem(
          longTitle: "Players", 
          child: PlayerStatsList(),
          icon: McIcons.account_multiple,
          unselectedIcon: McIcons.account_multiple_outline,
          alreadyScrollableChild: true,
        ),
        "commanders": RadioHeaderedItem(
          longTitle: "Commanders", 
          child: CommandersLeaderboards(),
          icon: CSIcons.damageFilled,
          unselectedIcon: CSIcons.damageOutlined,
          alreadyScrollableChild: true,
        ), 
        "custom": RadioHeaderedItem(
          longTitle: "Customs", 
          child: CustomStatsList(),
          icon: McIcons.cards,
          unselectedIcon: McIcons.cards_outline,
          alreadyScrollableChild: true,
        ), 
      },
      withoutHeader: true,
    );
  }
}