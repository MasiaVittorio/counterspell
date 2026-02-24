// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/alerts/specifics/game/image_search/image_search_alert.dart';

class ImageSearchCommanderFilterToggle extends StatelessWidget {
  const ImageSearchCommanderFilterToggle({
    super.key,
    required this.filterForCommanders,
    required this.onChanged,
  });

  final bool filterForCommanders;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ImageSearchAlert.sliderHeight,
      alignment: Alignment.center,
      child: RadioSlider(
        selectedIndex: filterForCommanders ? 0 : 1,
        onTap: (i) => onChanged(i == 0),
        items: const [
          RadioSliderItem(
            icon: Icon(CSIcons.damageOutlined),
            selectedIcon: Icon(CSIcons.damageFilled),
            title: Text("Commanders"),
          ),
          RadioSliderItem(
            icon: Icon(McIcons.cards_outline),
            selectedIcon: Icon(McIcons.cards),
            title: Text("Any card"),
          ),
        ],
      ),
    );
  }
}
