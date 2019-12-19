import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';
import 'winner_selector.dart';

class PastGameTile extends StatelessWidget {

  final PastGame game;
  final int index;

  PastGameTile(this.game, this.index);

  static const double subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final states = game.state.players.values.first.states;
    final duration = states.first.time.difference(states.last.time).abs();
    final day = game.dateTime.day;
    final month = monthsShort[game.dateTime.month];
    final hour = game.dateTime.hour.toString().padLeft(2, '0');
    final minute = game.dateTime.minute.toString().padLeft(2, '0');
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return Section([
      ListTile(
        onTap: () => showInfo(stage),
        // leading: const Icon(Icons.timelapse),
        title: Text("$month $day, $hour:$minute"),
        subtitle: Text("lasted ${duration.inMinutes} minutes"),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => stage.showAlert(
            ConfirmAlert(
              action: () => CSBloc.of(context).pastGames.removeGameAt(index),
              warningText: "Delete game played $month $day, $hour:$minute?",
              confirmColor: CSColors.delete,
              confirmText: "Yes, delete",
              confirmIcon: Icons.delete_forever,
            ),
            size: ConfirmAlert.height,
          ),
        ),
      ),
      CSWidgets.divider,
      ListTile(
        leading: const Icon(McIcons.trophy),
        title: Text("Winner: ${game.winner}"),
        onTap: () => stage.showAlert(
          WinnerSelector(
            game.state.names, 
            initialSelected: game.winner, 
            onConfirm: (selected){
              bloc.pastGames.pastGames.value[this.index].winner = selected;
              bloc.pastGames.pastGames.refresh();
            },
          ),
          size: WinnerSelector.heightCalc(game.state.players.length),
        ),
      ),
      SubSection([
        SectionTitle("${game.state.players.length} players"),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            for(final player in game.state.players.values)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text("${player.name}"),
                  Text("(${player.states.last.life})"),
                ],),
              ),
          ]),
        ),),
      ], onTap: () => showInfo(stage),),
      BottomExtra(
        const Text("Commanders"), 
        onTap: () => showInfo(stage),
      ),
    ], stretch: true,);
  }

  void showInfo(StageData stage) => stage.showAlert(
    PastGameScreen(),
    size: PastGameScreen.height
  );

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
