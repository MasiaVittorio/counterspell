import 'package:counter_spell_new/core.dart';
import 'single_screen.dart';
import 'winner_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PastGameTile extends StatelessWidget {

  final PastGame game;
  final int index;

  PastGameTile(this.game, this.index);

  static const double height = 182.0;

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);

    final VoidCallback show = () => stage.showAlert(
      PastGameScreen(index: index,),
      size: PastGameScreen.height
    );

    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Section([
        GameTimeTile(game, index: index,),
        Expanded(child: SubSection(
          <Widget>[
            SectionTitle("Winner: ${game.winner ?? 'not detected'}"),
            Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, 
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 2.0, 8.0, 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  for(final player in game.state.players.values)
                    (){
                      final name = player.name;
                      final commanders = game.commandersPlayedBy(name);
                      return SidChip(
                        color: theme.accentColor,
                        text: "$name",
                        icon: game.winner == name ? McIcons.trophy : null,
                        forceTextColor: commanders.isNotEmpty ? Colors.white : null,
                        subText: commanders.isNotEmpty 
                          ? safeSubString(
                            untilSpaceOrComma(commanders.first.name),
                            8,
                          )
                          : null,
                        image: commanders.isNotEmpty 
                          ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              commanders.first.imageUrl()
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              (theme.brightness.isDark 
                                ? theme.canvasColor
                                : Colors.black
                              ).withOpacity(0.2), 
                              BlendMode.srcOver,
                            ),
                          )
                          : null,
                      );
                    }()
                ].separateWith(CSWidgets.width10),),
              ),
            ),),
          ], 
          onTap: show,
          mainAxisAlignment: MainAxisAlignment.center,
        ),),
        CSWidgets.height10,
      ], stretch: true,),
    );
  }

  static String safeSubString(String start, int len){
    if(start.length >  len) return start.substring(0,len-1)+'.';
    else return start; 
  }

  static String untilSpaceOrComma(String from){
    return from.split(" ").first.split(",").first;
  }


  void insertNotes(PastGame game, StageData stage, CSBloc bloc){
    stage.showAlert(
      InsertAlert(
        hintText: "This game I comboed off...",
        labelText: "Insert notes",
        initialText: game.notes ?? "",
        textCapitalization: TextCapitalization.sentences,
        maxLenght: null,
        onConfirm: (notes){
          bloc.pastGames.pastGames.value[this.index].notes = notes;
          bloc.pastGames.pastGames.refresh(index: this.index);
        },
      ),
      size: InsertAlert.height,
    );    
  }

  void selectWinner(PastGame game, StageData stage, CSBloc bloc){
    stage.showAlert(
      WinnerSelector(
        game.state.names, 
        initialSelected: game.winner, 
        onConfirm: (selected){
          bloc.pastGames.pastGames.value[this.index].winner = selected;
          bloc.pastGames.pastGames.refresh(index: this.index);
        },
      ),
      size: WinnerSelector.heightCalc(game.state.players.length),
    );    
  }

}


class GameTimeTile extends StatelessWidget {
  final PastGame game;
  final int index;
  final bool delete;
  final bool openable;

  const GameTimeTile(this.game, {@required this.index, this.delete = true, this.openable = true});

  @override
  Widget build(BuildContext context) {
    final duration = game.duration;
    final day = game.startingDateTime.day;
    final month = monthsShort[game.startingDateTime.month];
    final hour = game.startingDateTime.hour.toString().padLeft(2, '0');
    final minute = game.startingDateTime.minute.toString().padLeft(2, '0');
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);

    return ListTile(
      onTap: openable ? () => stage.showAlert(
        PastGameScreen(index: index,),
        size: PastGameScreen.height
      ) : null,
      leading: const Icon(Icons.timelapse),
      title: Text("$month $day, $hour:$minute"),
      subtitle: Text("Lasted ${duration.inMinutes} minutes"),
      trailing: delete ? IconButton(
        icon: const Icon(Icons.delete_forever, color: CSColors.delete),
        onPressed: () => stage.showAlert(
          ConfirmAlert(
            action: () => bloc.pastGames.pastGames.removeAt(index),
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