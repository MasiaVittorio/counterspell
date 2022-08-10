// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:counter_spell_new/core.dart';

class Hint {

  const Hint({
    required this.text,
    required this.page,
    this.icon,
    this.autoHighlight,
    this.manualHighlight,
    this.selfHighlight = false,
    this.repeatAuto = 2,
    this.getCustomColor,
  });

  final String text;
  final CSPage? page;
  final Widget? icon;
  final Future<void> Function(CSBloc)? autoHighlight;
  final void Function(CSBloc)? manualHighlight;
  final bool selfHighlight;
  final int repeatAuto;
  final Color Function(CSBloc)? getCustomColor;

  @override
  String toString() {
    return 'Hint(text: $text, page: $page, icon: $icon, autoHighlight: $autoHighlight, manualHighlight: $manualHighlight, selfHighlight: $selfHighlight, getCustomColor: $getCustomColor)';
  }

  @override
  bool operator ==(covariant Hint other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.page == page &&
      other.icon == icon &&
      other.autoHighlight == autoHighlight &&
      other.manualHighlight == manualHighlight &&
      other.selfHighlight == selfHighlight;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      page.hashCode ^
      icon.hashCode ^
      autoHighlight.hashCode ^
      manualHighlight.hashCode ^
      selfHighlight.hashCode;
  }
}


class HintIcon extends StatelessWidget {

  const HintIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color contrast = DefaultTextStyle.of(context).style.color!;
    return Material(
      color: contrast.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(builder: (_, c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          icon, 
          color: contrast,
          size: min(40, c.maxHeight - 8), 
        ),
      )),
    );  
  }
}