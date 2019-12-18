import 'package:counter_spell_new/core.dart';


class PastGameTile extends StatelessWidget {

  final PastGame game;

  PastGameTile(this.game);

  static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final states = game.state.players.values.first.states;
    final duration = states.first.time.difference(states.last.time).abs();
    final day = game.dateTime.day;
    final month = monthsShort[game.dateTime.month];
    final hour = game.dateTime.hour.toString().padLeft(2, '0');
    final minute = game.dateTime.minute.toString().padLeft(2, '0');

    return Section([
      SectionTitle("$month $day, $hour:$minute (lasted ${duration.inMinutes} minutes)"),
      ListTile(
        leading: const Icon(McIcons.trophy),
        title: Text("Winner: ${game.winner}"),
      ),
      SubSection([
        const SectionTitle("Commanders"),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: subsectionHeight),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for(final entry in game.commandersA.entries)
                if(entry.value != null)
                  CardTile(
                    entry.value, 
                    callback: (_){}, 
                    autoClose: false,
                    trailing: Text(entry.key),
                  )
                else 
                  ListTile(
                    title: Text("${entry.key}"),
                    subtitle: const Text("null"),
                  ),
            ],
          ),),
        ),
      ]),
    ]);
  }

  static const Map<int,String> months = <int,String>{
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };
  static const Map<int,String> monthsShort = <int,String>{
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };

}
