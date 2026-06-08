import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/scryfall/card.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CardAlignmentAlert extends StatelessWidget {
  const CardAlignmentAlert({super.key, required this.id, required this.card});

  final String id;
  final MtgCard card;

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final cardsLogic = counterSpell.cardsLogic;
    return cardsLogic.cardsAlignments.build((context, value) {
      return _CardAlignmentAlert(
        card: card,
        alignment: value[id] ?? Alignment.center,
        onAlignmentChanged: (value) {
          cardsLogic.cardsAlignments.value[id] = value;
          cardsLogic.cardsAlignments.refresh();
        },
      );
    });
  }
}

class _CardAlignmentAlert extends StatelessWidget {
  const _CardAlignmentAlert({
    required this.card,
    required this.alignment,
    required this.onAlignmentChanged,
  });

  final MtgCard card;
  final Alignment alignment;
  final ValueChanged<Alignment> onAlignmentChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final safe = context.safe;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PanelHeader(title: Text("${card.name}'s image alignment")),
        Space.vertical(safe.top + layout.margin.medium),
        IntrinsicHeight(
          child: Row(
            children: [
              Space.horizontal(layout.margin.medium),
              Expanded(
                child: Stack(
                  children: [
                    switch (card.imageUrl()) {
                      null || '' => Container(
                        height: 300,
                        color: theme.colorScheme.surfaceContainerHigh,
                      ),
                      final String imageUrl => CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                      ),
                    },
                    Positioned.fill(
                      child: Align(
                        alignment: alignment,
                        child: const Icon(
                          Icons.circle,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: alignment,
                        child: const Icon(
                          Icons.circle_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Space.horizontal(layout.spacing.medium),
              RotatedBox(
                quarterTurns: 1,
                child: Slider(
                  value: alignment.y,
                  onChanged: (value) =>
                      onAlignmentChanged(Alignment(alignment.x, value)),
                  min: -1,
                  max: 1,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                ),
              ),
              Space.horizontal(layout.margin.medium),
            ],
          ),
        ),
        Space.vertical(layout.spacing.medium),
        Pad(
          right: layout.spacing.medium + layout.margin.medium + 40,
          child: Slider(
            value: alignment.x,
            onChanged: (value) =>
                onAlignmentChanged(Alignment(value, alignment.y)),
            min: -1,
            max: 1,
            allowedInteraction: SliderInteraction.tapAndSlide,
          ),
        ),
        Space.vertical(layout.spacing.medium),
        CallToAction(
          action: () => onAlignmentChanged(Alignment.center),
          label: const Text('Reset'),
          icon: const Icon(Icons.restart_alt),
        ),
        Space.vertical(safe.bottom),
      ],
    );
  }
}
