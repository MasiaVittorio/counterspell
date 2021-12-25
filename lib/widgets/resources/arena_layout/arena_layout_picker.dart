import 'package:counter_spell_new/core.dart';

class ArenaLayoutAlert extends StatefulWidget {
  const ArenaLayoutAlert();

  static const double height = 700.0;

  @override
  _ArenaLayoutAlertState createState() => _ArenaLayoutAlertState();
}

class _ArenaLayoutAlertState extends State<ArenaLayoutAlert> {
  int len = 3;

  Map<ArenaLayoutType,bool> flipped = {
    ArenaLayoutType.ffa: false,
    ArenaLayoutType.squad: false,
  };

  ArenaLayoutType type = ArenaLayoutType.ffa;

  static const Set<String> names6 = <String>{
    "Tony",
    "Stan",
    "Peter",
    "Bruce",
    "Natasha",
    "Logan",
  };
  static const Set<String> names5 = <String>{
    "Tony",
    "Stan",
    "Peter",
    "Bruce",
    "Natasha",
  };
  static const Set<String> names4 = <String>{
    "Tony",
    "Stan",
    "Peter",
    "Bruce",
  };
  static const Set<String> names3 = <String>{
    "Tony",
    "Stan",
    "Peter",
  };
  static const Set<String> names2 = <String>{
    "Tony",
    "Stan",
  };

  Map<int,String> positions6 = <int,String>{
    0: "Tony",
    1: "Stan",
    2: "Peter",
    3: "Bruce",
    4: "Natasha",
    5: "Logan",
  };
  Map<int,String> positions5 = <int,String>{
    0: "Tony",
    1: "Stan",
    2: "Peter",
    3: "Bruce",
    4: "Natasha",
  };
  Map<int,String> positions4 = <int,String>{
    0: "Tony",
    1: "Stan",
    2: "Peter",
    3: "Bruce",
  };
  Map<int,String> positions3 = <int,String>{
    0: "Tony",
    1: "Stan",
    2: "Peter",
  };
  Map<int,String> positions2 = <int,String>{
    0: "Tony",
    1: "Stan",
  };

  Set<String>? get realNames => <int,Set<String>>{
    2: names2,
    3: names3,
    4: names4,
    5: names5,
    6: names6,
  }[len];

  Map<int,String>? get realPositions => <int,Map<int,String>>{
    2: positions2,
    3: positions3,
    4: positions4,
    5: positions5,
    6: positions6,
  }[len];

  void changePositions(Map<int,String> newMap) => setState((){
    switch (len) {
      case 2:
        positions2 = newMap;
        break;
      case 3:
        positions3 = newMap;
        break;
      case 4:
        positions4 = newMap;
        break;
      case 5:
        positions5 = newMap;
        break;
      case 6:
        positions6 = newMap;
        break;
      default:
    }
  });


  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Arena Layout Example",
      alreadyScrollableChild: true,
      canvasBackground: true,
      child: Column(children: <Widget>[
        const SizedBox(height: PanelTitle.height,),

        Expanded(child: ArenaLayoutPicker(
          names: realNames,
          positions: realPositions,
          onPositionsChange: changePositions,
          type: type, 
          onTypeChanged: (t) => this.setState(() {
            type = t;
          }),
          flipped: flipped, 
          onFlippedChanged: (t,f) => this.setState(() {
            flipped[t] = f;
          }), 
        ),),

        ToggleButtons(
          isSelected: [
            len==2,
            len==3,
            len==4,
            len==5,
            len==6,
          ], 
          children: [
            for(final l in [2,3,4,5,6])
              Text("$l")
          ], 
          onPressed: (i) => setState((){
            len = [2,3,4,5,6][i];
          }),
        ),

      ],),
    );
  }
}


class ArenaLayoutPicker extends StatefulWidget {
  const ArenaLayoutPicker({
    required this.type,
    required this.onTypeChanged,
    required this.flipped,
    required this.onFlippedChanged,
    required this.names,
    required this.positions,
    required this.onPositionsChange,
  });

  final Set<String>? names;
  final Map<int,String?>? positions;
  final void Function(Map<int,String?>) onPositionsChange;
  final ArenaLayoutType? type;
  final void Function(ArenaLayoutType) onTypeChanged;

  final Map<ArenaLayoutType?,bool> flipped;
  final void Function(ArenaLayoutType, bool) onFlippedChanged;

  @override
  _ArenaLayoutPickerState createState() => _ArenaLayoutPickerState();
}

class _ArenaLayoutPickerState extends State<ArenaLayoutPicker> {

  PageController? controller;

  @override
  void initState(){
    super.initState();
    controller = PageController(
      viewportFraction: 0.8,
      initialPage: ArenaLayoutType.values.indexOf(widget.type!),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ArenaLayoutPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.type != widget.type){
      final int target = ArenaLayoutType.values.indexOf(widget.type!);
      if(controller!.page != target.toDouble()){
        controller!.animateToPage(
          target,
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOut,
        );
      }
    }
  } 

  Map<int,String?>? get positions => widget.positions;

  bool unpositionedName(Map<int,String?> map, String name) => !map.containsValue(name);

  List<String> unpositionedNames(Map<int,String?>? map) => [
    for(final name in widget.names!)
      if(unpositionedName(map!,name))
        name,
  ];

  bool unpositionedKey(int key, Map<int,String?> map) => map[key] == null;

  
  Map<int,String?> positionName(String name, int key, Map<int,String?> oldMap){
    Map<int,String?> newMap = <int,String?>{
      for(final e in oldMap.entries)
        e.key: e.value,
    };
    newMap[key] = name;
    
    newMap = checkAutoChoice(newMap);

    return newMap;
  }

  Map<int,String?> checkAutoChoice(Map<int,String?> oldMap){
    final List<String> unn = unpositionedNames(oldMap);
    if(unn.length == 1){
      for(final k in oldMap.keys)
        if(unpositionedKey(k, oldMap))
          return positionName(unn.first, k, oldMap);
    }
    return oldMap;
  }

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    final List<String> _unpositionedNames = unpositionedNames(positions);
    final bool mustPosition = _unpositionedNames.isNotEmpty;

    final List<Widget> layouts = <Widget>[
      for(final type in ArenaLayoutType.values)
        InkWell(
          onTap: type == widget.type ? null : () => widget.onTypeChanged(type),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ArenaLayout(
              animateCenterWidget: false,
              layoutType: type, 
              flipped: widget.flipped[type],
              centerChildBuilder: (_,__) => FloatingActionButton(
                onPressed: () => widget.onFlippedChanged(type, !widget.flipped[type]!),
                backgroundColor: theme.canvasColor,
                child: Icon(Icons.rotate_right, color: theme.colorScheme.onSurface),
              ),
              childBuilder: (_, i, __) => AnimatedContainer(
                margin: const EdgeInsets.all(6.0),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: widget.type == type 
                    ? theme.colorScheme.secondary.withOpacity(0.35)
                    : SubSection.getColor(theme),
                  borderRadius: BorderRadius.circular(10),                          
                ),
                child: InkWell(
                  onTap: widget.type == type && mustPosition
                    ? () => widget.onPositionsChange(
                      positionName(_unpositionedNames.first, i, positions!)
                    )
                    : null,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Center(child: Text("$i. ${positions![i] ?? "-"}"),),
                  ),
                ),
              ),
              howManyChildren: widget.names!.length,
            ),
          ),
        ),
    ];

    return Material(
      child: Column(children: <Widget>[
        
        Expanded(child: PageView(
          controller: controller,
          onPageChanged: (page) => widget.onTypeChanged(
            ArenaLayoutType.values[page]
          ),
          children: layouts
        ),),

        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 14),
          child: IconTheme.merge(
            data: IconThemeData(
              color: theme.colorScheme.onSurface,
              opacity: 1.0,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: widget.type == ArenaLayoutType.values[0] 
                      ? null
                      : () => widget.onTypeChanged(
                        ArenaLayoutType.values[0],
                      ),
                  ),
                ),

                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: mustPosition 
                      ? theme.canvasColor
                      : theme.scaffoldBackgroundColor.withOpacity(0.9),
                    child: ListTile(
                      title: Text(mustPosition 
                        ? "Place ${_unpositionedNames.first}"
                        : "Reorder players",
                      ),
                      leading: Icon(mustPosition
                        ? Icons.person_outline
                        : Icons.people_outline
                      ),
                      onTap: mustPosition
                        ? null
                        : () => widget.onPositionsChange(<int,String?>{
                          for(final key in positions!.keys)
                            key: null,
                        }),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: widget.type == ArenaLayoutType.values[1] 
                      ? null
                      : () => widget.onTypeChanged(
                        ArenaLayoutType.values[1],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],),
    );
  }
}


