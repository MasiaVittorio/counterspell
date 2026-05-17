import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/logic/theme_logic.dart';
import 'package:counter_spell/models/theme/saved_theme.dart';
import 'package:counter_spell/widgets/components/common/my_chip.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class SavedThemesAlert extends StatelessWidget {
  const SavedThemesAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final logic = context.themeLogic;
    return MyDynamicThemeBuilder(
      builder: (context, seed) {
        return context.themeLogic.savedThemes.build((context, savedThemes) {
          return PanelList.expand(
            title: const Text('Saved themes'),
            bottom: CallToAction.filled.danger(
              action: savedThemes.isEmpty
                  ? null
                  : () {
                      frame.showAlert(
                        ConfirmPanelAlert.delete(
                          title: const Text('Delete all saved themes?'),
                          onConfirmed: () {
                            logic.savedThemes.value.clear();
                            logic.savedThemes.refresh();
                          },
                        ),
                      );
                    },
              label: const Text('Delete all'),
              icon: const Icon(Icons.delete_forever_outlined),
            ),
            children: [
              for (int i = 0; i < savedThemes.length; i++)
                SavedThemeCard(
                  savedTheme: savedThemes[i],
                  isFirst: i == 0,
                  isLast: i == savedThemes.length - 1,
                  dynamicSeed: seed,
                ),
            ],
          );
        });
      },
    );
  }
}

class SavedThemeCard extends StatelessWidget {
  const SavedThemeCard({
    super.key,
    required this.savedTheme,
    required this.isFirst,
    required this.isLast,
    required this.dynamicSeed,
  });

  final SavedTheme savedTheme;
  final bool isFirst;
  final bool isLast;
  final Color? dynamicSeed;

  @override
  Widget build(BuildContext context) {
    final layout = context.theme.layout;
    final logic = context.themeLogic;
    final frame = context.panelFrame;

    return IsSavedThemeSelectedBuilder(
      savedTheme: savedTheme,
      builder: (context, isSelected, child) {
        final theme = context.themeLogic.computeThemeData(
          customScheme: savedTheme.customScheme,
          useDynamic: savedTheme.useDynamicColor,
          brightness: context.theme.brightness,
          dynamicSeed: dynamicSeed,
        );
        final colorScheme = theme.colorScheme;

        return Theme(
          data: theme,
          child: GroupedCard(
            isFirst: isFirst,
            isLast: isLast,
            borderSide: isSelected
                ? BorderSide(color: colorScheme.primary)
                : BorderSide.none,
            backgroundColor: isSelected
                ? colorScheme.surfaceContainerHighest
                : colorScheme.surfaceContainer,
            child: ListTile(
              onTap: () => logic.loadSavedTheme(savedTheme),
              trailing: IconButton(
                onPressed: () {
                  frame.showAlert(
                    ConfirmPanelAlert.delete(
                      title: const Text('Delete saved theme?'),
                      onConfirmed: () => logic.unsaveTheme(savedTheme),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: colorScheme.error,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: savedTheme.useDynamicColor
                    ? colorScheme.primaryContainer
                    : savedTheme.customScheme.seedColor,
                child: savedTheme.useDynamicColor
                    ? Icon(
                        Icons.palette_outlined,
                        color: colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              title: Text(
                savedTheme.useDynamicColor
                    ? 'Dynamic color'
                    : 'Seed color: #${savedTheme.customScheme.seedColor.toARGB32().toRadixString(16).toUpperCase().substring(2, 8)}',
              ),
              subtitle: Wrap(
                spacing: layout.spacing.medium,
                runSpacing: layout.spacing.small,
                children: [
                  MyChip(
                    label: savedTheme
                        .customScheme
                        .dynamicSchemeVariant
                        .name
                        .capitalizeFirst,
                    onPressed: null,
                  ),
                  MyChip(
                    label:
                        'contrast: ${savedTheme.customScheme.contrastLevel.toStringAsFixed(3)}',
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
