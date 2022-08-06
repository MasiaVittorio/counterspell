import 'package:counter_spell_new/core.dart';
import '../../../models/extra_info.dart';

class AptInfo extends StatelessWidget {

  const AptInfo({
    required this.pageColors,
    required this.name,
    required this.bloc,
    required this.gameState,
    required this.defenceColor,
  });

  //Theming
  final Map<CSPage,Color?>? pageColors;
  final Color? defenceColor;

  //Business Logic
  final CSBloc? bloc;

  //Actual Game State
  final GameState? gameState;
  final String name;


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return StageBuild.offMainEnabledPages<CSPage>((_, enabledPages) 
      => bloc!.game.gameAction.counterSet.variable.build((context, _){

        final List<ExtraInfo> list = ExtraInfo.fromPlayer(name,
          ofGroup: gameState!.lastPlayerStates,
          pageColors: pageColors,
          havingPartnerB: <String,bool?>{
            for(final entry in gameState!.players.entries)
              entry.key: entry.value.havePartnerB,
          },
          defenceColor: defenceColor,
          types: DamageTypes.fromPages(enabledPages),
          counterMap: bloc!.game.gameAction.currentCounterMap,
        );

        if(list.isEmpty) return const SizedBox();

        final children = <Widget>[
          for(final info in list)
            SidChip(
              icon: info.icon,
              text: info.value.toString(),
              subText: info.note,
              color: info.color,
            ),
        ];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SidChip.height/2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: children.separateWith(const SizedBox(height: 4,)),
            ),
          ),
        );
      },),
    );
  }
}