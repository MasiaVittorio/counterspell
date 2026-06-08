import 'package:counter_spell/widgets/arena/player_cell/arena_player_cell.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_advanced_body.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_basic_body.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_more_button.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellBody extends StatefulWidget {
  const PlayerCellBody({
    super.key,
    required this.playerIndex,
    required this.avoidMenuButton,
  });

  final int playerIndex;
  final bool avoidMenuButton;

  @override
  State<PlayerCellBody> createState() => _PlayerCellBodyState();
}

class _PlayerCellBodyState extends State<PlayerCellBody> {
  bool toTheLeft = true;

  PageController advancedPageController = PageController();

  @override
  void dispose() {
    advancedPageController.dispose();
    super.dispose();
  }

  void onChangeOrientation(bool value) => setState(() {
    toTheLeft = value;
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.arenaPlayerController;
    final delay = context.delay;

    void open() {
      controller.increment.update(0);
      delay.cancel();
      controller.cachedAttackerIndex.update(null);
      controller.advanced.update(true);
    }

    void close() => controller.advanced.update(false);

    final basicScrollPhysics = CallbackScrollPhysics(
      onlyFromEdges: false,
      topBounceCallback: () {
        open();
        onChangeOrientation(false);
        advancedPageController.jumpToPage(PlayerCellAdvancedBody.pageCount - 1);
      },
      bottomBounceCallback: () {
        onChangeOrientation(true);
        advancedPageController.jumpToPage(0);
        open();
      },
      topBounce: true,
      bottomBounce: true,
      alwaysScrollable: true,
    );

    final advancedScrollPhysics = CallbackScrollPhysics(
      onlyFromEdges: false,
      topBounceCallback: () {
        close();
        onChangeOrientation(true);
      },
      bottomBounceCallback: () {
        close();
        onChangeOrientation(false);
      },
      topBounce: true,
      bottomBounce: true,
      alwaysScrollable: true,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: toTheLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: controller.advanced.buildWithStaticChild(
              child: PageView(
                physics: basicScrollPhysics,
                children: [
                  PlayerCellBasicBody(
                    playerIndex: widget.playerIndex,
                    avoidMenuButton: widget.avoidMenuButton,
                    open: open,
                  ),
                ],
              ),
              builder: (context, value, child) => NewAnimatedListed(
                listed: !value,
                direction: Axis.horizontal,
                axisAlignment: toTheLeft ? 1 : -1,
                fadeFirstFraction: 1,
                child: child,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: toTheLeft ? Alignment.centerRight : Alignment.centerLeft,
            child: controller.advanced.buildWithStaticChild(
              child: PlayerCellAdvancedBody(
                playerIndex: widget.playerIndex,
                onChangeOrientation: onChangeOrientation,
                pageController: advancedPageController,
                physics: advancedScrollPhysics,
              ),
              builder: (context, value, child) => NewAnimatedListed(
                listed: value,
                direction: Axis.horizontal,
                fadeFirstFraction: 1,
                axisAlignment: toTheLeft ? -1 : 1,
                child: child,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: PlayerCellMoreButton(
            open: () {
              onChangeOrientation(true);
              advancedPageController.jumpToPage(0);
              open();
            },
            close: close,
          ),
        ),
      ],
    );
  }
}
