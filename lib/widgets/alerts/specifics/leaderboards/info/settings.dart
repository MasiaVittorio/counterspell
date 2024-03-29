import 'package:counter_spell_new/core.dart';

class LeaderboardsSettings extends StatelessWidget {
  const LeaderboardsSettings();

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context);
    final stage = Stage.of(context);

    return Column(children: <Widget>[
      Section(<Widget>[
        const SectionTitle("Information"),
        const SubSection([
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Past games"),
            subtitle: Text("CounterSpell automatically saves information about the games you play."),
          ),
        ]),
        const SubSection([
          ListTile(
            leading: Icon(McIcons.pencil_outline),
            title: Text("Edit past games"),
            subtitle: Text("You can delete a single game at any time or manually set its winner and commanders used."),
          ),
        ]),
        const SubSection([
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text("Statistics"),
            subtitle: Text("All the statistics are derived from the information saved in the list of past games."),
          ),
        ]),
        const SubSection([
          ListTile(
            leading: Icon(McIcons.trophy),
            title: Text("Select a winner!"),
            subtitle: Text("Every game where a winner cannot be automatically detected and it's not specified will not count for any statistics."),
          ),
        ], margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),),
      ].separateWith(CSWidgets.height10)),

      ListTile(
        leading: const Icon(Icons.delete_forever, color: CSColors.delete,),
        title: const Text("Delete ALL history",),
        trailing: const Icon(Icons.warning),
        onTap: () => stage!.showAlert(
          ConfirmAlert(
            action: () => logic.pastGames.pastGames.set(<PastGame>[]),
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