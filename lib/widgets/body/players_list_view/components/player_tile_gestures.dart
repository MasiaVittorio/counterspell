import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/body/players_list_view/components/advanced_view_player_scroller.dart';
import 'package:counter_spell/widgets/components/builders/is_anybody_attacking_builder.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';

class PlayerTileGestures extends StatelessWidget {
  const PlayerTileGestures({
    super.key,
    required this.child,
    required this.page,
    required this.index,
    required this.screenWidth,
  });

  final Widget child;
  final BodyPage page;
  final int index;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final interactionLogic = context.counterSpell.interactionLogic;
    final delay = context.delay;
    void onTap() {
      interactionLogic.advancedViewTapPlayer(index);
      delay.extend();
    }

    return IsAnybodyAttackingBuilder(
      child: InkWell(onTap: onTap, child: child),
      builder: (context, isAnybodyAttacking, child) {
        return AdvancedViewPlayerScroller(
          ignoreDrag:
              page == BodyPage.history ||
              (page == BodyPage.damage && !isAnybodyAttacking),
          index: index,
          screenWidth: screenWidth,
          child: child!,
        );
      },
    );
  }
}
