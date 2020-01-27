import 'package:counter_spell_new/core.dart';

class LeaderboardsSettings extends StatelessWidget {
  const LeaderboardsSettings();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Section([
        const SectionTitle("Information"),
        CSWidgets.heigth10,
        const SubSection([
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Past games"),
            subtitle: const Text("CounterSpell automatically saves information about the games you play."),
          ),
        ]),
        const SubSection([
          ListTile(
            leading: const Icon(McIcons.pencil_outline),
            title: const Text("Edit past games"),
            subtitle: const Text("You can delete a single game at any time or manually set its winner and commanders used."),
          ),
        ], margin: const EdgeInsets.all(10.0),),
        const SubSection([
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text("Statistics"),
            subtitle: const Text("All the statistics are derived from the information saved in the list of past games."),
          ),
        ]),
        CSWidgets.heigth10,
      ]),
      ListTile(
        leading: const Icon(Icons.delete_forever, color: CSColors.delete,),
        title: const Text("Delete ALL history",),
        trailing: const Icon(Icons.warning),
        onTap: () => Stage.of(context).showAlert(
          ConfirmAlert(
            action: () => CSBloc.of(context).pastGames.pastGames.set(<PastGame>[]),
            warningText: "Delete ALL the past games? This cannot be undone",
            confirmColor: CSColors.delete,
            confirmIcon: Icons.delete_forever,
            confirmText: "I'm sure. Delete ALL history",
          ),
          size: ConfirmAlert.height,
        ),
      ),
    ],);
  }
}