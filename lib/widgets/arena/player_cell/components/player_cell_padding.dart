import 'package:counter_spell/widgets/arena/player_cell/builders/padding_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:sid_base/sid_base.dart';

class PlayerCellPadding extends StatelessWidget {
  const PlayerCellPadding({
    super.key,
    required this.child,
    required this.playerIndex,
  });

  final Widget child;
  final int playerIndex;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final p = layout.padding.smaller;

    return ArenaPlayerCellPaddingBuilder(
      playerIndex: playerIndex,
      child: child,
      builder: (context, isPadded, child) => AnimatedPadding(
        padding: isPadded ? EdgeInsets.fromLTRB(p, p, p, 0) : EdgeInsets.zero,
        duration: Motion.beginAndEndOnScreenEmphasized.duration,
        curve: Motion.beginAndEndOnScreenEmphasized.curve,
        child: child,
      ),
    );
  }
}
