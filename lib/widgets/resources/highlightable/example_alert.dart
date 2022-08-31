import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/resources/highlightable/highlightable.dart';


class HighlightAlert extends StatefulWidget {

  const HighlightAlert({Key? key}) : super(key: key);

  static const double height = 500;

  @override
  State<HighlightAlert> createState() => _HighlightAlertState();
}

class _HighlightAlertState extends State<HighlightAlert> {

  late final HighlightController one;
  late final HighlightController two;
  late final HighlightController three;
  late final HighlightController all;

  @override
  void initState() {
    super.initState();
    one = HighlightController("");
    two = HighlightController("");
    three = HighlightController("");
    all = HighlightController("");
  }

  @override
  Widget build(BuildContext context) {
    return HeaderedAlert(
      "Highlight",
      alreadyScrollableChild: true,
      bottom: controls, 
      child: content,
    );
  }

  Column get content => Column(children: [
    const Spacer(),
    Highlightable(
      controller: all,
      borderRadius: 10,
      child: ButtonTilesRow(children: [
        Highlightable(
          controller: one,
          borderRadius: 10,
          child: ButtonTile(
            icon: Icons.person, 
            text: "Example one", 
            onTap: (){},
          ),
        ),
        Highlightable(
          controller: two,
          borderRadius: 10,
          showOverlay: true,
          child: ButtonTile(
            icon: Icons.people, 
            text: "Example two", 
            onTap: (){},
          ),
        ),
        Highlightable(
          controller: three,
          borderRadius: 10,
          child: ButtonTile(
            icon: Icons.alarm, 
            text: "Example three", 
            onTap: (){},
          ),
        ),
      ],),
    ),
    const Spacer(),
  ],);

  Column get controls => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(children: [
        Expanded(child: ListTile(
          onTap: one.launch,
          title: const Text("One"),
        ),),
        Expanded(child: ListTile(
          onTap: two.launch,
          title: const Text("Two"),
        ),),
        Expanded(child: ListTile(
          onTap: three.launch,
          title: const Text("Three"),
        ),),
      ],),
      ListTile(
        title: const Text("All"),
        onTap: all.launch,
      ),
    ],
  );
}