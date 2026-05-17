import 'package:counter_spell/models/game/counter.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_casts_page.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_counters_page.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlayerCellAdvancedBody extends StatelessWidget {
  const PlayerCellAdvancedBody({
    super.key,
    required this.playerIndex,
    required this.onChangeOrientation,
    required this.pageController,
    required this.physics,
  });

  final int playerIndex;
  final ValueChanged<bool> onChangeOrientation;
  final PageController pageController;
  final ScrollPhysics physics;
  static int get pageCount => 3;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    return Stack(
      children: [
        Positioned.fill(
          child: PageView(
            controller: pageController,
            physics: physics,
            children: [
              PlayerCellCastsPage(playerIndex: playerIndex),
              PlayerCellCountersPage(
                playerIndex: playerIndex,
                title: 'Counters',
                counters: [
                  Counter.poison,
                  Counter.energy,
                  Counter.rad,
                  Counter.experience,
                ],
              ),
              PlayerCellCountersPage(
                playerIndex: playerIndex,
                title: 'Status',
                counters: [
                  Counter.monarch,
                  Counter.initiative,
                  Counter.citysBlessing,
                  Counter.stormCount,
                ],
              ),
            ],
          ),
        ),
        Positioned.fill(
          bottom: layout.padding.small,
          child: Al.bottomCenter(
            child: SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                activeDotColor: theme.brightness.contrast,
                dotColor: theme.brightness.contrast.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
