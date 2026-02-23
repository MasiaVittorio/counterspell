import 'package:counter_spell/core.dart';

//UI for changing the default starting life total
class StartingLifeTile extends StatelessWidget {
  const StartingLifeTile({super.key});

  static const Map<int, String> lifeNames = {
    20: 'Regular',
    30: 'Two Headed Giants',
    40: 'Commander',
  };
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = CSBloc.of(context);
    final gameSettings = bloc.settings.gameSettings;

    final stage = Stage.of(context)!;

    return BlocVar.build2(
      gameSettings.startingLifeBlocVar,
      stage.themeController.derived.mainPageToPrimaryColor,
      builder: (_, dynamic life, dynamic colorMap) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle("Starting Life: ${lifeNames[life] ?? life}",
              animated: true),
          Row(
            children: <Widget>[
              for (final n in [20, 30, 40])
                _buildButton(n, life, bloc, colorMap[CSPage.life]),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: Material(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => stage.showAlert(
                            CustomStartingLife(),
                            size: InsertAlert.height,
                          ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(McIcons.pencil_outline),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int value, int? current, CSBloc bloc, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => bloc.settings.gameSettings.changeStartingLife(value),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 3.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RadioIcon(
                value: value == current,
                inactiveIcon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                activeColor: color,
              ),
              Text('$value'),
            ],
          ),
        ),
      ),
    );
  }
}
