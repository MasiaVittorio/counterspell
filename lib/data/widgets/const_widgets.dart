import 'package:counter_spell_new/core.dart';
import 'package:flutter/material.dart';

class CSWidgets{
  static const Widget divider = const Padding(
    padding: const EdgeInsets.symmetric(horizontal:16.0),
    child: const Divider(height: 2.0,),
  );
  static const Icon deleteIcon = Icon(Icons.delete_forever, color: CSColors.delete,);
  static const Widget height10 = SizedBox(height: 10.0,);
  static const Widget width10 = SizedBox(width: 10.0,);
  static const Widget height5 = SizedBox(height: 5.0,);
  static const Widget extraButtonsDivider = _ExtraButtonDivider();
}

class _ExtraButtonDivider extends StatelessWidget {
  const _ExtraButtonDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 1.0,
        height: 44.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
    );
  }
}