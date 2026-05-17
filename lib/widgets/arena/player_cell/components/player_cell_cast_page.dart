import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/partner_vectors.dart';
import 'package:counter_spell/models/game/player_state.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/arena/player_cell/components/player_cell_icon_value.dart';
import 'package:flutter/material.dart';

class PlayerCellCastPage extends StatelessWidget {
  const PlayerCellCastPage({
    super.key,
    required this.playerIndex,
    required this.partnerA,
    required this.state,
  });

  final int playerIndex;
  final bool partnerA;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final value = state.commanderCasts.of(partnerA);

    return InkResponse(
      onLongPress: () => counterSpell.gameLogic.editGame(
        (game) => game.castCommander(
          playerIndex: playerIndex,
          partnerA: partnerA,
          times: -1,
        ),
      ),
      onTap: () => counterSpell.gameLogic.editGame(
        (game) => game.castCommander(
          playerIndex: playerIndex,
          partnerA: partnerA,
          times: 1,
        ),
      ),
      child: PlayerCellIconValue(
        icon: BodyPage.cast.filledIcon,
        value: value == 0
            ? const SizedBox.expand()
            : AutoSizeText(value.toString(), maxLines: 1),
      ),
    );
  }
}
