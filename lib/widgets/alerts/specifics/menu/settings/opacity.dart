import 'package:counter_spell_new/core.dart';
import 'opacity_components/all.dart';

enum _OpacityPage{
  regular,
  arena,
}

class ImageOpacity extends StatelessWidget {
  const ImageOpacity([this.initialArena]);
  final bool initialArena;

  static const double height = 440;

  @override
  Widget build(BuildContext context) {
    return RadioHeaderedAlert<_OpacityPage>(
      canvasBackground: true,
      orderedValues: _OpacityPage.values, 
      initialValue: (initialArena ?? false) ? _OpacityPage.arena : _OpacityPage.regular, 
      accentSelected: true,
      items: const <_OpacityPage,RadioHeaderedItem>{
        _OpacityPage.regular: const RadioHeaderedItem(
          child: const ImageOpacityRegular(),
          icon: Icons.format_list_bulleted,
          longTitle: "Commander image opacity",
          title: "Regular",
        ),
        _OpacityPage.arena: RadioHeaderedItem(
          child: const ImageOpacitySimple(),
          icon: CSIcons.counterSpell,
          longTitle: "Commander image opacity",
          title: "Arena",
          // iconSize: 21,
        ),
      },
    );
  }
}