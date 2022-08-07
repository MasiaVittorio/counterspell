import 'package:counter_spell_new/core.dart';
import 'components/all.dart';

class CustomStatSingleScreen extends StatelessWidget {

  static const double height = 575.0;

  final CustomStat stat;

  const CustomStatSingleScreen(this.stat);

  @override
  Widget build(BuildContext context) {
    return RadioHeaderedAlert<String>(
      initialValue: "stats",
      customBackground: (theme) => theme.canvasColor,
      items: {
        "stats": RadioHeaderedItem(
          title: "Stats", 
          longTitle: stat.title,
          child: Stats(stat), 
          icon: Icons.timeline,
        ),
        "players": RadioHeaderedItem(
          longTitle: stat.title, 
          title: "Players",
          child: Players(stat), 
          icon: McIcons.account_multiple,
          unselectedIcon: McIcons.account_multiple_outline,
          alreadyScrollableChild: true,
        ),
        "commanders": RadioHeaderedItem(
          title: "Commanders", 
          longTitle: stat.title,
          child: Commanders(stat), 
          icon: CSIcons.damageFilled,
          unselectedIcon: CSIcons.damageOutlined,
          alreadyScrollableChild: true,
        ),
      },
    );
  }
}



