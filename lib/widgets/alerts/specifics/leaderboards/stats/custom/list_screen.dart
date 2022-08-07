import 'package:counter_spell_new/core.dart';
import 'list_element.dart';

class CustomStatsList extends StatelessWidget {

  const CustomStatsList();

  @override
  Widget build(BuildContext context) {
    return _CustomStatsList(Stage.of(context));
  }
}

class _CustomStatsList extends StatefulWidget {

  const _CustomStatsList(this.stage);
  final StageData? stage;

  @override
  _CustomStatsListState createState() => _CustomStatsListState();
}

class _CustomStatsListState extends State<_CustomStatsList> {

  ScrollController? controller;

  static const key = "custom stats list scroll controller position";

  @override
  void initState() {
    super.initState();
    var saved = widget.stage!.panelController
        .alertController.savedStates[key];
    controller = ScrollController(
      initialScrollOffset: ((saved is double) ? saved : null ) ?? 0.0,
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

    return bloc.pastGames.customStats.build((_, map){
      final list = [...map.values]
        ..sort((one,two) => two.appearances.compareTo(one.appearances));

      return ListView.builder(
        controller: controller,
        physics: Stage.of(context)!.panelController.panelScrollPhysics(),
        itemBuilder: (_, index)
          => CustomStatWidget(list[index], 
            // pastGames: bloc.pastGames.pastGames.value,
            //commanderStats is updated whenever pastGames is updated
            //so it is safe to access that value brutally
            onSingleScreenCallback: (){
              widget.stage!.panelController.alertController.savedStates[key] = controller!.offset;
            },
          ),
        padding: const EdgeInsets.only(top: PanelTitle.height),
        itemCount: list.length,
        itemExtent: CustomStatWidget.heigth,
      );
    },
    );
  }
}
