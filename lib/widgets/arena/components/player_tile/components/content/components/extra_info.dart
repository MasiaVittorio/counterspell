import 'package:counter_spell_new/core.dart';
import '../../../models/extra_info.dart';

class AptInfo extends StatelessWidget {

  const AptInfo({
    @required this.pageColors,
    @required this.name,
    @required this.bloc,
    @required this.gameState,
  });

  //Theming
  final Map<CSPage,Color> pageColors;

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final GameState gameState;
  final String name;


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final StageData<CSPage,SettingsPage> stage = Stage.of<CSPage,SettingsPage>(context);

    return BlocVar.build3(
      bloc.themer.defenceColor,
      bloc.game.gameAction.counterSet.variable,
      stage.pagesController.enabledPages,
      builder: (context, defenceColor, _, enabledPages){

        final List<ExtraInfo> list = ExtraInfo.fromPlayer(name,
          ofGroup: gameState.lastPlayerStates,
          pageColors: pageColors,
          havingPartnerB: <String,bool>{
            for(final entry in this.gameState.players.entries)
              entry.key: entry.value.havePartnerB,
          },
          defenceColor: defenceColor,
          types: DamageTypes.fromPages(enabledPages),
          counterMap: bloc.game.gameAction.currentCounterMap,
        );

        if(list.isEmpty) return SizedBox();

        final children = <Widget>[
          for(final info in list)
            SidChip(
              icon: info.icon,
              text: info.value.toString(),
              subText: info.note,
              color: info.color,
            ),
        ];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SidChip.height/2),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: children.separateWith(SizedBox(height: 4,)),
              ),
            ),
          ),
        );
      }
    );
  }
}