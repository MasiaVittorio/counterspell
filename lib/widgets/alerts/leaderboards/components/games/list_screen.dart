import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PastGamesList extends StatelessWidget {

  const PastGamesList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){
      if(pastGames.isEmpty) return Container();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(int i = pastGames.length - 1; i >= 0; --i)
            PastGameTile(pastGames[i], i),
        ],
      );

    });
  }

}
