import 'package:counter_spell_new/core.dart';

class CSWidgets{
  static const Widget divider = Divider(height: 2.0, endIndent: 16, indent: 16);

  static const Widget collapsedPanelDivider = _CollapsedPanelDivider();
  static const Icon deleteIcon = Icon(CSIcons.delete, color: CSColors.delete,);
  static const Widget height5 = SizedBox(height: 5.0, width: 0.0,);
  static const Widget width5 = SizedBox(width: 5.0, height: 0.0,);
  static const Widget height10 = SizedBox(height: 10.0, width: 0.0,);
  static const Widget width10 = SizedBox(width: 10.0, height: 0.0,);
  static const Widget height12 = SizedBox(height: 12.0, width: 0.0,);
  static const Widget width12 = SizedBox(width: 12.0, height: 0.0,);
  static const Widget height15 = SizedBox(height: 15.0, width: 0.0,);
  static const Widget width15 = SizedBox(width: 15.0, height: 0.0,);
  static const Widget height20 = SizedBox(height: 20.0, width: 0.0,);
  static const Widget width20 = SizedBox(width: 20.0, height: 0.0,);
  static const Widget extraButtonsDivider = ButtonTilesRow.divider;
  static const Widget verticalDivider = _VerticalDivider();
}



class _CollapsedPanelDivider extends StatelessWidget {

  const _CollapsedPanelDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CSSizes.collapsedPanelSize * 0.65,
      width: 1.0,
      color: Theme.of(context).textTheme.bodyLarge!.color!
        .withOpacity(0.5),
    );
  }
}


class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: 1.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}