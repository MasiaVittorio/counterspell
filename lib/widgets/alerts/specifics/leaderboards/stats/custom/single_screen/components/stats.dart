import 'package:counter_spell_new/core.dart';


class Stats extends StatelessWidget {
  final CustomStat stat;

  Stats(this.stat);

  @override
  Widget build(BuildContext context) {

    final logic = CSBloc.of(context)!;

    final cmdrs = logic.pastGames.commanderStats.value;
    final players = logic.pastGames.playerStats.value;

    final plTot = stat.playersApplicable.isNotEmpty 
      ? stat.playersApplicable.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      ) : null;
    final plFreq = stat.playersApplicable.isNotEmpty 
      ? stat.playersApplicable.entries.reduce(
        (a,b) => (a.value/players![a.key]!.games) > (b.value/players[b.key]!.games)
          ? a : b,
      ) : null;
    final int? plFreqGames = plFreq != null 
      ? players![plFreq.key]!.games : null;
    final double? plFreqValue = plFreq != null 
      ? plFreq.value / plFreqGames! : null;

    final cmdrTot = stat.commandersApplicable.isNotEmpty 
      ? stat.commandersApplicable.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      ) : null;
    final cmdrTotCard = cmdrTot != null 
      ? cmdrs![cmdrTot.key!]?.card : null;

    final cmdrFreq = stat.commandersApplicable.isNotEmpty 
      ? stat.commandersApplicable.entries.reduce(
        (a, b) => (a.value/cmdrs![a.key!]!.games) > (b.value/cmdrs[b.key!]!.games)
          ? a : b,
      ) : null;
    final cmdrFreqCard = cmdrFreq != null 
      ? cmdrs![cmdrFreq.key!]!.card : null;
    final int? cmdrFreqGames = cmdrFreq != null 
      ? cmdrs![cmdrFreq.key!]!.games : null;
    final double? cmdrFreqValue = cmdrFreq != null 
      ? cmdrFreq.value / cmdrFreqGames! : null;

    final double rate = stat.appearances == 0 
      ? 0 : 100 * stat.wins/stat.appearances;

    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SubSection([
          const SectionTitle("Stats"),
          ExtraButtons(children: [
            InfoDisplayer(
              title: const Text("Appearances"), 
              background: const Icon(McIcons.cards), 
              value: Text("${stat.appearances}"),
              detail: const Text("(Total)"),
            ),
            InfoDisplayer(
              title: const Text("Wins"), 
              background: const Icon(McIcons.trophy), 
              value: Text("${InfoDisplayer.getString(rate)}%"),
              detail: Text("Overall: ${stat.wins}"),
              color: CSColors.gold,
            ),
          ]),
        ], margin: margin,),

        if(plTot != null || plFreq != null || cmdrTot != null || cmdrFreq != null)
        SubSection([
          const SectionTitle("Honorable mentions"),
          if(plTot != null)
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(plTot.key),
            subtitle: const Text("Most times overall"),
            trailing: Text("${plTot.value}"),
          ),
          if(plFreq != null)
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(plFreq.key),
            subtitle: Text("Most frequent (${plFreq.value} over $plFreqGames games)"),
            trailing: Text("${InfoDisplayer.getString(plFreqValue! * 100)}%"),
          ),
          if(cmdrTot != null)
          ListTile(
            leading: const Icon(CSIcons.damageOutlined),
            title: Text(cmdrTotCard!.name),
            subtitle: const Text("Most times overall"),
            trailing: Text("${cmdrTot.value}"),
          ),
          if(cmdrFreq != null)
          ListTile(
            leading: const Icon(CSIcons.damageOutlined),
            title: Text(cmdrFreqCard!.name),
            subtitle: Text("Most frequent (${cmdrFreq.value} over $cmdrFreqGames games)"),
            trailing: Text("${InfoDisplayer.getString(cmdrFreqValue! * 100)}%"),
          ),
        ], margin: margin,),

      ],
    );
  }

  static const margin = EdgeInsets.fromLTRB(10, 0, 10, 10);
}