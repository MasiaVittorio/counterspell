import 'package:counter_spell_new/core.dart';
import 'list_element.dart';


class PastGamesList extends StatelessWidget {

  const PastGamesList();

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.pastGames.build((_, pastGames){

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for(final game in pastGames)
            PastGameTile(game),
        ],
      );

    });
  }

}
