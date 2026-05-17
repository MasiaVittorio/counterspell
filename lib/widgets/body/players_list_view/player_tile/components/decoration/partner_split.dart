import 'package:counter_spell/widgets/body/players_list_view/components/split/gradient_split.dart';
import 'package:counter_spell/widgets/components/builders/partner_focus_builder.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PartnerSplit extends StatelessWidget {
  const PartnerSplit({
    super.key,
    required this.partnerA,
    required this.partnerB,
    required this.partnerFocus,
    required this.parallax,
    required this.shrinking,
  });

  final Widget partnerA;
  final Widget? partnerB;
  final PartnerFocus partnerFocus;
  final double parallax;
  final double shrinking;

  @override
  Widget build(BuildContext context) {
    if (partnerB == null) return partnerA;

    return AnimatedGradientSplit(
      duration: Motion.beginAndEndOnScreenEmphasized.duration,
      curve: Motion.beginAndEndOnScreenEmphasized.curve,
      value: switch (partnerFocus) {
        PartnerFocus.both => 0.5,
        PartnerFocus.partnerA => 1,
        PartnerFocus.partnerB => 0,
      },
      leftChild: partnerA,
      rightChild: partnerB,
      parallax: parallax,
      shrinking: shrinking,
    );
  }
}
