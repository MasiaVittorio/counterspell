import 'package:counter_spell_new/core.dart';
import 'opacity_components/all.dart';

enum _OpacityPage{
  regular,
  simple,
}

class ImageOpacity extends StatelessWidget {
  const ImageOpacity();

  static const double height = 440;

  @override
  Widget build(BuildContext context) {
    return RadioHeaderedAlert<_OpacityPage>(
      orderedValues: _OpacityPage.values, 
      initialValue: _OpacityPage.regular, 
      accentSelected: true,
      items: const <_OpacityPage,RadioHeaderedItem>{
        _OpacityPage.regular: const RadioHeaderedItem(
          child: const ImageOpacityRegular(),
          icon: Icons.format_list_bulleted,
          longTitle: "Commander image opacity",
          title: "Regular",
        ),
        _OpacityPage.simple: RadioHeaderedItem(
          child: const ImageOpacitySimple(),
          icon: CSIcons.counterSpell,
          longTitle: "Commander image opacity",
          title: "Simple",
          iconSize: 21,
        ),
      },
    );
  }
}