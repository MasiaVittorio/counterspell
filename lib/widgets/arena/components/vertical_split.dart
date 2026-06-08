// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:counter_spell/widgets/arena/components/open_side.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class VerticalSplit extends StatelessWidget {
  const VerticalSplit.opposing({
    super.key,
    this.ratios = const (1, 1),
    required this.spacing,
    required this.flip,
    required this.top,
    required this.bottom,
  }) : opposing = true;

  final Widget top;
  final Widget bottom;
  final (int top, int bottom) ratios;
  final double spacing;
  final bool flip;
  final bool opposing;

  @override
  Widget build(BuildContext context) {
    final Widget? spacer = spacing > 0 ? Space.vertical(spacing) : null;

    return switch (opposing) {
      true => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: flip ? ratios.$2 : ratios.$1,
            child: RotatedBox(
              quarterTurns: 2,
              child: OpenSide.rotate(
                quarterTurns: 2,
                child: OpenSide.remove(top: true, child: flip ? bottom : top),
              ),
            ),
          ),
          ?spacer,
          Expanded(
            flex: flip ? ratios.$1 : ratios.$2,
            child: OpenSide.remove(top: true, child: flip ? top : bottom),
          ),
        ],
      ),
      false => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: flip ? ratios.$2 : ratios.$1,
            child: RotatedBox(
              quarterTurns: 1,
              child: OpenSide.rotate(
                quarterTurns: 1,
                child: OpenSide.remove(right: true, child: flip ? bottom : top),
              ),
            ),
          ),
          ?spacer,
          Expanded(
            flex: flip ? ratios.$1 : ratios.$2,
            child: RotatedBox(
              quarterTurns: 1,
              child: OpenSide.rotate(
                quarterTurns: 1,
                child: OpenSide.remove(left: true, child: flip ? top : bottom),
              ),
            ),
          ),
        ],
      ),
    };
  }
}

class VerticalThreewaySplit extends StatelessWidget {
  const VerticalThreewaySplit({
    super.key,
    required this.flip,
    required this.spacing,
    required this.ratios,
    required this.top,
    required this.middle,
    required this.bottom,
  });

  final Widget top;
  final Widget middle;
  final Widget bottom;

  final (int top, int middle, int bottom) ratios;
  final bool flip;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final spacer = spacing > 0 ? Space.vertical(spacing) : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: flip ? ratios.$3 : ratios.$1,
          child: RotatedBox(
            quarterTurns: 2,
            child: OpenSide.rotate(
              quarterTurns: 2,
              child: OpenSide.remove(top: true, child: flip ? bottom : top),
            ),
          ),
        ),
        ?spacer,
        Expanded(
          flex: ratios.$2,
          child: OpenSide.remove(top: true, bottom: true, child: middle),
        ),
        ?spacer,
        Expanded(
          flex: flip ? ratios.$1 : ratios.$3,
          child: OpenSide.remove(top: true, child: flip ? top : bottom),
        ),
      ],
    );
  }
}
