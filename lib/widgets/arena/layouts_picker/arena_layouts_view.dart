import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/interaction/arena_layout_mode.dart';
import 'package:counter_spell/widgets/arena/layouts_picker/arena_layout_example.dart';
import 'package:counter_spell/widgets/components/common/extra_note.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ArenaLayoutsView extends StatefulWidget
    with PanelAlert, FullScreenPanelAlert {
  const ArenaLayoutsView({
    super.key,
    this.filterForPlayerCount,
    this.initialMode,
  });

  final int? filterForPlayerCount;
  final ArenaLayoutMode? initialMode;

  @override
  State<ArenaLayoutsView> createState() => _ArenaLayoutsViewState();
}

class _ArenaLayoutsViewState extends State<ArenaLayoutsView> {
  late PageController pageController;
  late final List<ArenaLayoutMode> modes;

  @override
  void initState() {
    super.initState();
    modes = [
      for (final mode in ArenaLayoutMode.values)
        if (widget.filterForPlayerCount == null ||
            mode.playerCount == widget.filterForPlayerCount)
          mode,
    ];
    pageController = PageController(
      viewportFraction: 0.85,
      initialPage: switch (widget.initialMode) {
        null => 0,
        final mode => switch (modes.indexOf(mode)) {
          -1 => 0,
          final int i => i,
        },
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final safe = context.safe;
    final counterSpell = context.counterSpell;
    final arenaLogic = counterSpell.arenaLogic;
    return (arenaLogic.flipHorizontal, arenaLogic.flipVertical).build((
      context,
      flipHorizontal,
      flipVertical,
    ) {
      final children = <ArenaLayoutExample>[
        for (final mode in modes)
          ArenaLayoutExample(
            mode: mode,
            horizontalFlip: flipHorizontal,
            verticalFlip: flipVertical,
          ),
      ];

      return Column(
        children: [
          const PanelHeader(),
          Pad(
            horizontal: layout.margin.medium,
            bottom: layout.spacing.small,
            child: PageIndexReactor(
              controller: pageController,
              builder: (context, child, page) {
                final mode = children[page].mode;
                final (bool horizontally, bool vertically) usefulToFlip =
                    switch (mode) {
                      ArenaLayoutMode.twoTall => (false, false),
                      ArenaLayoutMode.twoWide => (false, false),
                      ArenaLayoutMode.threeFFA => (false, true),
                      ArenaLayoutMode.three2v1 => (true, false),
                      ArenaLayoutMode.fourFFA => (false, false),
                      ArenaLayoutMode.four2v2 => (false, false),
                      ArenaLayoutMode.four1v2v1 => (true, true),
                      ArenaLayoutMode.five1v2v2 => (false, true),
                      ArenaLayoutMode.five1v2v1v1 => (true, false),
                      ArenaLayoutMode.five3v2 => (true, false),
                      ArenaLayoutMode.six3v3 => (false, false),
                      ArenaLayoutMode.sixFFA => (false, false),
                    };
                return Row(
                  children: [
                    Expanded(
                      child: CallToAction.secondary.filled(
                        action: usefulToFlip.$1
                            ? () => arenaLogic.flipHorizontal.update(
                                !flipHorizontal,
                              )
                            : null,
                        icon: Icon(MdiIcons.flipHorizontal),
                        label: const Text('Horizontal flip'),
                        horizontalMargin: 0,
                      ),
                    ),
                    Space.horizontal(layout.spacing.medium),
                    Expanded(
                      child: CallToAction.secondary.filled(
                        action: usefulToFlip.$2
                            ? () =>
                                  arenaLogic.flipVertical.update(!flipVertical)
                            : null,
                        icon: Icon(MdiIcons.flipVertical),
                        label: const Text('Vertical flip'),
                        horizontalMargin: 0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: PageView(controller: pageController, children: children),
          ),
          ExtraNote(
            overrideTopPadding: layout.spacing.small,
            note: 'Drag players to different cells to swap them.',
          ),
          Pad(
            horizontal: layout.margin.medium,
            bottom: layout.spacing.medium,
            child: PageIndexReactor(
              controller: pageController,
              builder: (context, child, page) {
                return Row(
                  children: [
                    Expanded(
                      child: CallToAction.secondary.filled(
                        action: page > 0
                            ? () => pageController.previousPage(
                                duration: Motion
                                    .beginAndEndOnScreenEmphasized
                                    .duration,
                                curve:
                                    Motion.beginAndEndOnScreenEmphasized.curve,
                              )
                            : null,
                        label: const Text('Previous layout'),
                        icon: const Icon(Icons.keyboard_arrow_left),
                        iconOnTheRight: false,
                        horizontalMargin: 0,
                      ),
                    ),
                    Space.horizontal(layout.spacing.medium),
                    Expanded(
                      child: CallToAction.secondary.filled(
                        action: page < children.length - 1
                            ? () => pageController.nextPage(
                                duration: Motion
                                    .beginAndEndOnScreenEmphasized
                                    .duration,
                                curve:
                                    Motion.beginAndEndOnScreenEmphasized.curve,
                              )
                            : null,
                        label: const Text('Next layout'),
                        icon: const Icon(Icons.keyboard_arrow_right),
                        horizontalMargin: 0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          CallToAction(
            action: () {
              final mode = children[pageController.page?.round() ?? 0].mode;
              arenaLogic.preferredLayouts.value[mode.playerCount] = mode;
              counterSpell.arenaLogic.preferredLayouts.refresh();
              context.panelFrame.closePanel();
            },
            label: const Text('Confirm'),
            icon: const Icon(Icons.check),
          ),
          Space.vertical(safe.bottom > 0 ? safe.bottom : layout.margin.medium),
        ],
      );
    });
  }
}
