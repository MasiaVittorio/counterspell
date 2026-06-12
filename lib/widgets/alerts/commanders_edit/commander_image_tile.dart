import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/commander_damage_settings.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/alerts/card_alignment/card_alignment_alert.dart';
import 'package:counter_spell/widgets/alerts/image_search/components/card_tile.dart';
import 'package:counter_spell/widgets/alerts/image_search/image_search_alert.dart';
import 'package:counter_spell/widgets/components/common/small_progress_indicator.dart';
import 'package:counter_spell/widgets/components/project/artist_row.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CommanderImageTile extends StatelessWidget {
  const CommanderImageTile({
    super.key,
    required this.onChanged,
    required this.playerSettings,
    required this.partnerA,
    required this.card,
    required this.isLoading,
    required this.error,
    required this.dense,
  });

  final ValueChanged<PlayerSettings>? onChanged;
  final PlayerSettings playerSettings;
  final bool partnerA;

  final MtgCard? card;
  final bool isLoading;
  final String? error;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final frame = context.panelFrame;
    final onChanged = this.onChanged;

    final cardsLogic = context.counterSpell.cardsLogic;

    final title = AnimatedText(
      switch ((card?.name, isLoading, error)) {
        (null, true, _) => 'Loading',
        (null, false, null) => dense ? 'No image' : 'Commander image',
        (null, false, final String _) => 'Error',
        (final String name, _, _) => name,
      },
      style: TextStyle(
        color: switch (playerSettings.damageSettingsOf(partnerA)) {
          const CommanderDamageSettings() => null,
          _ => theme.colorScheme.primary,
        },
      ),
    );

    final subtitle = AnimatedListed(
      listed: !dense,
      duration: Motion.beginAndEndOnScreenEmphasized.duration,
      curve: Motion.beginAndEndOnScreenEmphasized.curve,
      child: Row(
        children: [
          Expanded(
            child: switch ((card, isLoading, error)) {
              (null, true, _) => const Text('...'),
              (null, false, null) => const Text('Not set'),
              (null, false, final String error) => Text(error),
              (final MtgCard card, _, _) => ArtistRow(card: card),
            },
          ),
        ],
      ),
    );

    final trailing = switch ((card, isLoading, error)) {
      (null, true, _) => null,
      (null, false, null) => null,
      (null, false, final String _) => null,
      (final MtgCard card, _, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () =>
                frame.showAlert(CardAlignmentAlert(id: card.id, card: card)),
            icon: const Icon(Icons.crop),
          ),
          IconButton(
            onPressed: onChanged == null
                ? null
                : () => onChanged(
                    playerSettings.removeCommander(partnerA: partnerA),
                  ),
            icon: Icon(
              Icons.delete_forever_outlined,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    };

    final leading = switch ((card?.imageUrl(), isLoading, error)) {
      (null, true, _) => const SmallProgressIndicator(),
      (null, false, null) => Icon(MdiIcons.cardsOutline),
      (null, false, _) => Icon(MdiIcons.alertCircleOutline),
      (final String url, _, _) => CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(url),
        maxRadius: (dense ? 30 : 36) / 2,
      ),
    };

    VoidCallback? onTap = onChanged == null
        ? null
        : () => frame.showAlert(
            ImageSearchAlert(
              playerName: playerSettings.name,
              onSelect: (card) {
                cardsLogic.cachedCards.value[card.id] = card.deepCopy();
                cardsLogic.cachedCards.refresh();
                cardsLogic.playerCards.value[playerSettings.name] = {
                  for (final String old
                      in cardsLogic.playerCards.value[playerSettings.name] ??
                          {})
                    // so it goes to the end of the list
                    if (old != card.id) old,
                  card.id,
                };
                cardsLogic.playerCards.refresh();
                onChanged(
                  playerSettings.updateCommander(
                    partnerA: partnerA,
                    card: card,
                  ),
                );
              },
            ),
          );
    final VoidCallback? onLongPress = switch (card) {
      null => null,
      final MtgCard card => () => frame.showAlert(CardAlert(card)),
    };

    final layout = theme.layout;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedPadding(
        duration: Motion.beginAndEndOnScreenEmphasized.duration,
        curve: Motion.beginAndEndOnScreenEmphasized.curve,
        padding: EdgeInsets.symmetric(
          vertical: dense ? layout.padding.tiny : layout.padding.smaller,
          horizontal: dense ? layout.padding.tiny : layout.padding.smaller,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Motion.beginAndEndOnScreenEmphasized.duration,
              curve: Motion.beginAndEndOnScreenEmphasized.curve,
              width: dense ? 40 : 54,
              height: dense ? 40 : 54,
              child: Center(child: leading),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [title, subtitle],
              ),
            ),
            if (trailing case final Widget trailing)
              AnimatedContainer(
                duration: Motion.beginAndEndOnScreenEmphasized.duration,
                curve: Motion.beginAndEndOnScreenEmphasized.curve,
                constraints: BoxConstraints(
                  minWidth: dense ? 40 : 54,
                  minHeight: dense ? 40 : 54,
                  maxHeight: dense ? 40 : 54,
                ),
                child: trailing,
              ),
          ].separateWith(Space.horizontal(layout.spacing.medium)),
        ),
      ),
    );
  }
}
