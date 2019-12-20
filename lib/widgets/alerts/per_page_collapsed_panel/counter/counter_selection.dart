import 'package:counter_spell_new/core.dart';


class CounterSelector extends StatelessWidget {
  const CounterSelector();
  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);
    final counterSet = bloc.game.gameAction.counterSet;
    final theme = Theme.of(context);

    return Stage.of(context).themeController.primaryColorsMap.build((_,map)
      => Material(
        child: SingleChildScrollView(
          physics: Stage.of(context).panelScrollPhysics(),
          child: counterSet.build((context, current)
            => IconTheme.merge(
              data: const IconThemeData(opacity: 1.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const AlertTitle("Pick counter"),
                    for(final counter in counterSet.list)
                      SidRadioListTile<String>(
                        activeColor: theme.accentColor,
                        groupValue: current.longName,
                        value: counter.longName,
                        onChanged: (name) => counterSet.choose(
                          counterSet.list.indexWhere((c) => c.longName == name),
                        ),
                        title: Text(counter.longName),
                        secondary: Icon(
                          counter.icon, 
                          color: counter.longName == current.longName 
                            ? theme.accentColor
                            : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
  }
}