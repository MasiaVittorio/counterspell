import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';
import 'winner_selector.dart';

class PastGameTile extends StatelessWidget {

  final PastGame game;
  final int index;

  PastGameTile(this.game, this.index);

  static const double height = 262.0;

  // static const double _subsectionHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    final VoidCallback show = () => stage.showAlert(
      PastGameScreen(index: index,),
      size: PastGameScreen.height
    );

    return Section([
      GameTimeTile(game, index: index,),
      CSWidgets.divider,
      ListTile(
        leading: const Icon(McIcons.trophy),
        title: Text("Winner: ${game.winner ?? "not detected"}"),
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
      ], onTap: show,),
      BottomExtra(
        const Text("Commanders"), 
        onTap: show,
      ),
    ], stretch: true,);
  }


}


class GameTimeTile extends StatelessWidget {
  final PastGame game;
  final int index;
  final bool delete;

  const GameTimeTile(this.game, {@required this.index, this.delete = true});

  @override
  Widget build(BuildContext context) {
    final states = game.state.players.values.first.states;
    final duration = game.state.startingTime.difference(states.last.time).abs();
    final day = game.dateTime.day;
    final month = monthsShort[game.dateTime.month];
    final hour = game.dateTime.hour.toString().padLeft(2, '0');
    final minute = game.dateTime.minute.toString().padLeft(2, '0');
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return ListTile(
      onTap: () => stage.showAlert(
        PastGameScreen(index: index,),
        size: PastGameScreen.height
      ),
      // leading: const Icon(Icons.timelapse),
      title: Text("$month $day, $hour:$minute"),
      subtitle: Text("Lasted ${duration.inMinutes} minutes"),
      trailing: delete ? IconButton(
        icon: const Icon(Icons.delete_forever, color: CSColors.delete),
        onPressed: () => stage.showAlert(
          ConfirmAlert(
            action: () => bloc.pastGames.removeGameAt(index),
            warningText: "Delete game played $month $day, $hour:$minute?",
            confirmColor: CSColors.delete,
            confirmText: "Yes, delete",
            confirmIcon: Icons.delete_forever,
          ),
          size: ConfirmAlert.height,
        ),
      ) : null,
    );
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