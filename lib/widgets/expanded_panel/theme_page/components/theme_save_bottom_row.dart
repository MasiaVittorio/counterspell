import 'package:call_to_action/call_to_action.dart';
import 'package:counter_spell/logic/theme_logic.dart';
import 'package:counter_spell/models/theme/saved_theme.dart';
import 'package:counter_spell/widgets/alerts/themes/saved_themes_alert.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ThemeSaveBottomRow extends StatelessWidget {
  const ThemeSaveBottomRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;

    final logic = context.themeLogic;
    final frame = context.panelFrame;

    return IsCurrentThemeSavedBuilder(
      builder: (context, isSaved, child) {
        return Pad(
          horizontal: layout.margin.medium,
          child: Row(
            children: <Widget>[
              AnimatedListed(
                listed: isSaved,
                direction: Axis.horizontal,
                child: Pad(
                  right: layout.spacing.medium,
                  child: SizedBox(
                    width: 56,
                    child: CallToAction(
                      theme: CallToActionTheme.high,
                      action: logic.unsaveCurrentTheme,
                      label: Icon(
                        Icons.delete_forever_outlined,
                        color: theme.colorScheme.error,
                      ),
                      horizontalMargin: 0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CallToAction(
                  action: logic.saveCurrentTheme,
                  iconOnTheRight: false,
                  horizontalMargin: 0,
                  label: Text(isSaved ? 'Saved' : 'Save'),
                  icon: Icon(
                    isSaved ? MdiIcons.contentSaveCheck : Icons.save_outlined,
                  ),
                ),
              ),
              Space.horizontal(layout.spacing.medium),
              Expanded(
                child: CallToAction.secondary.filled(
                  action: () {
                    if (logic.savedThemes.value.isEmpty) {
                      frame.showAlert(
                        const AlternativesPanelAlert(
                          title: Text('No saved themes'),
                          content: Text(
                            "Save a couple of themes and you'll find a list of all of your saved themes here.",
                          ),
                          alternatives: [
                            PanelAlternative(
                              value: null,
                              label: Text('Ok'),
                              icon: Icon(Icons.check),
                            ),
                          ],
                        ),
                      );
                    } else {
                      frame.showAlert(const SavedThemesAlert());
                    }
                  },
                  horizontalMargin: 0,
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text('Load'),
                  iconOnTheRight: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
