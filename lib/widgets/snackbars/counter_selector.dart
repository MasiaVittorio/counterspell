import 'package:counter_spell_new/core.dart';

class SnackCounterSelector extends StatelessWidget {
  const SnackCounterSelector();
  @override
  Widget build(BuildContext context) {
    final CSBloc bloc = CSBloc.of(context)!;
    // final StageData stage = Stage.of(context);
    final CSGameAction gameAction = bloc.game!.gameAction!;
    final List<Counter> ordered = gameAction.counterSet.list;

    return gameAction.counterSet.build((_, current) => SelectSnackbar(
      autoClose: false,
      initialIndex: ordered.indexOf(current),
      children: <Widget>[
        for(final counter in ordered)
          Icon(counter.icon)
      ], 
      onTap: (i) => gameAction.chooseCounterByLongName(ordered[i].longName),
    ),);

}
}

