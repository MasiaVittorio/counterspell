import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter_spell/logic/interaction_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/split_theme.dart';
import 'package:counter_spell/widgets/body/players_list_view/player_tile/components/trailing_type_builder.dart';
import 'package:counter_spell/widgets/components/builders/card_theme_builder.dart';
import 'package:counter_spell/widgets/components/common/new_animated_listed.dart';
import 'package:counter_spell/widgets/components/project/delay_provider.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class PlayerTileTrailing extends StatelessWidget {
  const PlayerTileTrailing({
    super.key,
    required this.index,
    required this.playerSettings,
    required this.page,
    required this.dense,
  });

  final int index;
  final PlayerSettings playerSettings;
  final BodyPage page;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final cardsLogic = counterSpell.cardsLogic;

    return cardsLogic.cardsAlignments.build((context, alignments) {
      return CardIdThemeBuilder(
        id: playerSettings.commanders.partnerA,
        builder: (context, cardA, themeA, _) {
          return CardIdThemeBuilder(
            id: playerSettings.commanders.partnerB,
            builder: (context, cardB, themeB, _) {
              return TrailingTypeBuilder(
                index: index,
                playerSettings: playerSettings,
                page: page,
                builder: (context, type, p, i, _) {
                  return _PlayerTileTrailing(
                    index: index,
                    cardsAlignments: alignments,
                    page: page,
                    cardA: cardA,
                    cardB: cardB,
                    usingPartnerA: p,
                    isInverted: i,
                    type: type,
                    dense: dense,
                    interactionLogic: counterSpell.interactionLogic,
                    themeA: themeA,
                    themeB: themeB,
                  );
                },
              );
            },
          );
        },
      );
    });
  }
}

class _PlayerTileTrailing extends StatelessWidget {
  const _PlayerTileTrailing({
    required this.page,
    required this.cardA,
    required this.cardB,
    required this.usingPartnerA,
    required this.isInverted,
    required this.type,
    required this.cardsAlignments,
    required this.dense,
    required this.interactionLogic,
    required this.index,
    required this.themeA,
    required this.themeB,
  });

  final int index;
  final bool dense;
  final BodyPage page;
  final MtgCard? cardA;
  final MtgCard? cardB;
  final ThemeData themeA;
  final ThemeData themeB;
  final bool usingPartnerA;
  final bool isInverted;
  final PlayerTileTrailingType type;
  final Map<String, Alignment> cardsAlignments;
  final InteractionLogic interactionLogic;

  @override
  Widget build(BuildContext context) {
    final delay = context.delay;

    final theme = context.theme;
    final layout = theme.layout;

    final otherCard = switch (usingPartnerA) {
      true => cardB,
      false => cardA,
    };

    final ThemeData rightTheme = context.rightTheme;

    final Color background = switch (type) {
      PlayerTileTrailingType.partnerSwap => switch (usingPartnerA) {
        true => themeB,
        false => themeA,
      }.colorScheme.primaryContainer,
      PlayerTileTrailingType.incrementInversion =>
        isInverted
            ? rightTheme.colorScheme.primaryContainer
            : rightTheme.colorScheme.secondaryContainer,
      PlayerTileTrailingType.none => rightTheme.colorScheme.secondaryContainer,
    };
    final imageUrl = otherCard?.imageUrl();

    final Color foreground = switch (type) {
      PlayerTileTrailingType.partnerSwap => switch (imageUrl) {
        null => switch (usingPartnerA) {
          true => themeB,
          false => themeA,
        }.colorScheme.onPrimaryContainer,
        String _ => rightTheme.colorScheme.primaryContainer.contrast,
      },
      PlayerTileTrailingType.incrementInversion =>
        isInverted
            ? rightTheme.colorScheme.onPrimaryContainer
            : rightTheme.colorScheme.onSecondaryContainer,
      PlayerTileTrailingType.none =>
        rightTheme.colorScheme.onSecondaryContainer,
    };

    final swapped = switch (type) {
      PlayerTileTrailingType.partnerSwap => !usingPartnerA,
      _ => false,
    };

    return AnimatedOpacity(
      opacity: type == PlayerTileTrailingType.none ? 0 : 1,
      duration: Motion.beginAndEndOnScreenEmphasized.duration,
      curve: Motion.beginAndEndOnScreenEmphasized.curve,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          image: switch ((type, imageUrl)) {
            (PlayerTileTrailingType.partnerSwap, String url) => DecorationImage(
              image: CachedNetworkImageProvider(url),
              alignment: cardsAlignments[otherCard!.id] ?? Alignment.center,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                background.withValues(alpha: 0.5),
                BlendMode.srcOver,
              ),
            ),
            _ => null,
          },
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: switch (type) {
              PlayerTileTrailingType.incrementInversion => () {
                if (isInverted) {
                  interactionLogic.selectPlayer(playerIndex: index);
                } else {
                  interactionLogic.antiSeselectPlayer(playerIndex: index);
                }
                delay.extend();
              },
              PlayerTileTrailingType.partnerSwap => () {
                interactionLogic.updatePartnerA(index, !usingPartnerA);
                delay.cancel();
                interactionLogic.cancelOngoingInteractionButKeepSelections();
              },
              PlayerTileTrailingType.none => null,
            },
            child: Pad(
              horizontal: layout.padding.medium,
              vertical: layout.padding.small,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NewAnimatedListed(
                    listed: !swapped,
                    direction: Axis.horizontal,
                    curve: Motion.beginAndEndOnScreenEmphasized.curve,
                    duration: Motion.beginAndEndOnScreenEmphasized.duration,
                    child: Pad(
                      right: layout.spacing.small,
                      child: CachedBuilder(
                        value: switch (type) {
                          PlayerTileTrailingType.partnerSwap =>
                            Icons.people_outline_outlined,
                          PlayerTileTrailingType.incrementInversion =>
                            Icons.swap_horiz,
                          PlayerTileTrailingType.none => null,
                        },
                        builder: (context, icon) {
                          return Icon(
                            icon ?? Icons.swap_horiz,
                            size: 22,
                            color: foreground,
                          );
                        },
                      ),
                    ),
                  ),
                  Pad(
                    horizontal: layout.spacing.tiny,
                    child: AnimatedText(
                      switch (type) {
                        PlayerTileTrailingType.partnerSwap => switch (dense) {
                          true => 'Swap',
                          false => 'Swap partner',
                        },
                        PlayerTileTrailingType.incrementInversion =>
                          switch (isInverted) {
                            true => 'Inverted',
                            false => 'Invert',
                          },
                        PlayerTileTrailingType.none => '',
                      },
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: foreground,
                      ),
                    ),
                  ),
                  NewAnimatedListed(
                    curve: Motion.beginAndEndOnScreenEmphasized.curve,
                    duration: Motion.beginAndEndOnScreenEmphasized.duration,
                    direction: Axis.horizontal,
                    listed: swapped,
                    child: Pad(
                      left: layout.spacing.small,
                      child: Transform.flip(
                        flipX: true,
                        flipY: false,
                        child: Icon(
                          Icons.people_outline_outlined,
                          size: 22,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CachedBuilder<T> extends StatefulWidget {
  const CachedBuilder({super.key, this.value, required this.builder});

  final T? value;
  final ValueBuilder<T?> builder;

  @override
  State<CachedBuilder<T>> createState() => _CachedBuilderState<T>();
}

class _CachedBuilderState<T> extends State<CachedBuilder<T>> {
  T? cachedValue;
  @override
  void initState() {
    super.initState();
    cachedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant CachedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      cachedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, cachedValue);
  }
}
