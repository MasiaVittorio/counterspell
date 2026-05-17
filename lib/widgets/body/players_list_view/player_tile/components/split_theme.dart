import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class SplitTheme {
  final ThemeData leftTheme;
  final ThemeData rightTheme;

  SplitTheme({required this.leftTheme, required this.rightTheme});
}

extension SplitThemesExtension on BuildContext {
  ThemeData get leftTheme => provide<SplitTheme>().leftTheme;
  ThemeData get rightTheme => provide<SplitTheme>().rightTheme;
}

class SplitThemesProvider extends StatelessWidget {
  const SplitThemesProvider({
    super.key,
    required this.child,
    required this.cardA,
    required this.cardB,
    required this.themeA,
    required this.themeB,
    required this.partnerFocus,
    required this.runsTwoPartners,
  });

  final Widget child;
  final MtgCard? cardA;
  final MtgCard? cardB;
  final ThemeData themeA;
  final ThemeData themeB;
  final PartnerFocus partnerFocus;
  final bool runsTwoPartners;

  @override
  Widget build(BuildContext context) {
    if (!runsTwoPartners) {
      return CleanProvider(
        data: SplitTheme(leftTheme: themeA, rightTheme: themeA),
        child: Theme(data: themeA, child: child),
      );
    }

    return CleanProvider(
      data: switch (partnerFocus) {
        PartnerFocus.both => SplitTheme(leftTheme: themeA, rightTheme: themeB),
        PartnerFocus.partnerA => SplitTheme(
          leftTheme: themeA,
          rightTheme: themeA,
        ),
        PartnerFocus.partnerB => SplitTheme(
          leftTheme: themeB,
          rightTheme: themeB,
        ),
      },
      child: Theme(
        data: partnerFocus != PartnerFocus.partnerB ? themeA : themeB,
        child: child,
      ),
    );
  }
}
