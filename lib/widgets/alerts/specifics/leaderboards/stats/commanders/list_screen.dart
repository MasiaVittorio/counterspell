import 'package:counter_spell/core.dart';

import 'list_element.dart';

class CommandersLeaderboards extends StatelessWidget {
  const CommandersLeaderboards({super.key});

  @override
  Widget build(BuildContext context) {
    return _CommandersLeaderboards(Stage.of(context));
  }
}

class _CommandersLeaderboards extends StatefulWidget {
  const _CommandersLeaderboards(this.stage);
  final StageData? stage;

  @override
  _CommandersLeaderboardsState createState() => _CommandersLeaderboardsState();
}

class _CommandersLeaderboardsState extends State<_CommandersLeaderboards> {
  ScrollController? controller;

  static const key = "commanders leaderboards scroll controller position";

  @override
  void initState() {
    super.initState();
    var saved = widget.stage!.panelController.alertController.savedStates[key];
    controller = ScrollController(
      initialScrollOffset: ((saved is double) ? saved : null) ?? 0.0,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = CSBloc.of(context);

    return bloc.pastGames.commanderStats.build(
      (_, map) {
        final list = [...map.values]
          ..sort((one, two) => two.games.compareTo(one.games));

        return ListView.builder(
          controller: controller,
          physics: Stage.of(context)!.panelController.panelScrollPhysics(),
          itemBuilder: (_, index) => CommanderStatWidget(
            list[index],
            pastGames: bloc.pastGames.pastGames.value,
            //commanderStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
            onSingleScreenCallback: () {
              widget.stage!.panelController.alertController.savedStates[key] =
                  controller!.offset;
            },
          ),
          padding: const EdgeInsets.only(top: PanelTitle.height),
          itemCount: list.length,
          itemExtent: CommanderStatWidget.height,
        );
      },
    );
  }
}
