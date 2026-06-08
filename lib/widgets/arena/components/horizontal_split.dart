import 'package:counter_spell/widgets/arena/components/open_side.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class HorizontalSplit extends StatelessWidget {
  const HorizontalSplit.opposing({
    super.key,
    this.ratios = const (1, 1),
    required this.spacing,
    required this.flip,
    required this.left,
    required this.right,
  }) : opposing = true;

  const HorizontalSplit.team({
    super.key,
    this.ratios = const (1, 1),
    required this.spacing,
    required this.flip,
    required this.left,
    required this.right,
  }) : opposing = false;

  final Widget left;
  final Widget right;
  final (int left, int right) ratios;
  final double spacing;
  final bool flip;
  final bool opposing;

  @override
  Widget build(BuildContext context) {
    final Widget? spacer = spacing > 0 ? Space.horizontal(spacing) : null;

    return switch (opposing) {
      true => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: flip ? ratios.$2 : ratios.$1,
            child: RotatedBox(
              quarterTurns: 1,
              child: OpenSide.rotate(
                quarterTurns: 1,
                child: OpenSide.remove(top: true, child: flip ? right : left),
              ),
            ),
          ),
          ?spacer,
          Expanded(
            flex: flip ? ratios.$1 : ratios.$2,
            child: RotatedBox(
              quarterTurns: 3,
              child: OpenSide.rotate(
                quarterTurns: 3,
                child: OpenSide.remove(top: true, child: flip ? left : right),
              ),
            ),
          ),
        ],
      ),
      false => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: flip ? ratios.$2 : ratios.$1,
            child: OpenSide.remove(right: true, child: flip ? right : left),
          ),
          ?spacer,
          Expanded(
            flex: flip ? ratios.$1 : ratios.$2,
            child: OpenSide.remove(left: true, child: flip ? left : right),
          ),
        ],
      ),
    };
  }
}

class HorizontalThreewaySplit extends StatelessWidget {
  const HorizontalThreewaySplit({
    super.key,
    required this.flip,
    required this.spacing,
    required this.ratios,
    required this.left,
    required this.middle,
    required this.right,
  });

  final Widget left;
  final Widget middle;
  final Widget right;

  final (int left, int middle, int right) ratios;
  final bool flip;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final spacer = spacing > 0 ? Space.horizontal(spacing) : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: flip ? ratios.$3 : ratios.$1,
          child: OpenSide.remove(right: true, child: flip ? right : left),
        ),
        ?spacer,
        Expanded(
          flex: ratios.$2,
          child: OpenSide.remove(right: true, left: true, child: middle),
        ),
        ?spacer,
        Expanded(
          flex: flip ? ratios.$1 : ratios.$3,
          child: OpenSide.remove(left: true, child: flip ? left : right),
        ),
      ],
    );
  }
}
