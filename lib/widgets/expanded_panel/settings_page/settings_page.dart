import 'package:counter_spell/logic/settings_logic.dart';
import 'package:counter_spell/main.dart';
import 'package:counter_spell/widgets/body/history_view/player_delta_cell.dart';
import 'package:counter_spell/widgets/expanded_panel/game_page/expanded_page_list.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/always_on_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/backup_cta.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/cached_cards_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/haptic_feedback_tile.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/prefer_list_view.dart';
import 'package:counter_spell/widgets/expanded_panel/settings_page/restore_cta.dart';
import 'package:flutter/material.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    return ExpandedPageList(
      bottom: Pad(
        horizontal: layout.margin.medium,
        child: Row(
          children: <Widget>[
            const Expanded(child: BackupCallToAction()),
            Space.horizontal(layout.spacing.medium),
            const Expanded(child: RestoreCallToAction()),
          ],
        ),
      ),
      children: [
        const SectionTitle(
          title: Text('Settings'),
          leading: Icon(Icons.settings_outlined),
        ),
        ...[
          const AlwaysOnTile(),
          const HapticFeedbackTile(),
          const PreferListViewTile(),
        ].groupedCards(lastPadding: layout.spacing.smaller),
        SectionTitle(
          title: const Text('History timestamp mode'),
          leading: const Icon(Icons.history),
          trailing: HistoryTimeStamp.builder(
            DateTime.now().subtract(3.minutes),
            builder: (context, formattedText) =>
                Text('Example: $formattedText'),
          ),
        ),
        const HistoryTimeStampModeSlider(),
        SectionTitle(
          title: const Text('Cached data'),
          leading: Icon(MdiIcons.memory),
        ),
        ...[
          const CachedCardsTile(),
          // LATER: add cached images tile to manage cached network images
        ].groupedCards(lastPadding: layout.spacing.smaller),
      ],
    );
  }
}

class HistoryTimeStampModeSlider extends StatelessWidget {
  const HistoryTimeStampModeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.counterSpell.settingsLogic;
    return logic.historyTimeStampMode.build((context, value) {
      var layout = context.theme.layout;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedSlider(
            segments: [
              SliderSegment(
                value: HistoryTimeStampMode.time,
                label: logic.force24H.build(
                  (context, value) => Text(value ? 'HH:mm' : 'hh:mm'),
                ),
              ),
              const SliderSegment(
                value: HistoryTimeStampMode.timeAgo,
                label: Text('Time ago'),
              ),
            ],
            value: value,
            allowDeselectOnTap: false,
            onSelect: (value) => logic.historyTimeStampMode.update(value!),
          ),
          AnimatedListed(
            listed: value == HistoryTimeStampMode.time,
            child: Pad(
              top: layout.spacing.smaller,
              child: const GroupedCard(
                isFirst: false,
                isLast: true,
                child: HistoryTimeForce24HToggle(),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class HistoryTimeForce24HToggle extends StatelessWidget {
  const HistoryTimeForce24HToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.counterSpell.settingsLogic;
    return logic.force24H.build((context, value) {
      return SwitchListTile(
        title: const Text('24H format'),
        value: value,
        onChanged: (value) => logic.force24H.update(value),
      );
    });
  }
}
