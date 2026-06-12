import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/game/game_settings.dart';
import 'package:counter_spell/models/game/player_settings.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/player_commander_card.dart';
import 'package:counter_spell/widgets/alerts/commanders_edit/player_partners_toggle.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:segmented_slider/segmented_slider.dart';
import 'package:sid_base/sid_base.dart';

class EditCommandersAlert extends StatelessWidget
    with PanelAlert, FullScreenPanelAlert {
  const EditCommandersAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final counterSpell = context.counterSpell;
    final gameLogic = counterSpell.gameLogic;
    final playgroupLogic = counterSpell.playgroupLogic;
    return (gameLogic.gameReactive, playgroupLogic.listSeatOrder).build(
      (context, game, seatOrder) => RawEditCommandersAlert(
        seatOrder: seatOrder,
        gameSettings: game.settings,
        onChanged: (newSettings) {
          gameLogic.editGame((game) => game.copyWith(settings: newSettings));
        },
      ),
    );
  }
}

class RawEditCommandersAlert extends StatefulWidget {
  const RawEditCommandersAlert({
    super.key,
    required this.gameSettings,
    required this.onChanged,
    required this.seatOrder,
  });

  final List<int> seatOrder;
  final GameSettings gameSettings;
  final ValueChanged<GameSettings> onChanged;

  @override
  State<RawEditCommandersAlert> createState() => _RawEditCommandersAlertState();
}

class _RawEditCommandersAlertState extends State<RawEditCommandersAlert> {
  bool focusSettings = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final layout = theme.layout;
    final interactionLogic = context.counterSpell.interactionLogic;
    return PanelList.expand(
      title: const Text('Edit commanders'),
      bottom: Pad(
        bottom: layout.padding.smaller,
        top: layout.padding.tiny,
        child: SegmentedSlider<bool>(
          segments: [
            SliderSegment(
              value: false,
              label: const Text('Images'),
              unselectedIcon: Icon(MdiIcons.cardsOutline),
              selectedIcon: Icon(MdiIcons.cards),
            ),
            const SliderSegment(
              value: true,
              label: Text('Damage settings'),
              selectedIcon: Icon(Icons.settings),
              unselectedIcon: Icon(Icons.settings_outlined),
            ),
          ],
          value: focusSettings,
          allowDeselectOnTap: false,
          onSelect: (value) => setState(() {
            focusSettings = value ?? false;
          }),
        ),
      ),
      children: [
        for (int i = 0; i < widget.gameSettings.playerSettings.length; i++)
          if (widget.seatOrder[i] case int playerIndex)
            if (widget.gameSettings.playerSettings[playerIndex]
                case final PlayerSettings playerSettings)
              if ((PlayerSettings s) {
                    widget.onChanged(
                      widget.gameSettings.updatePlayerSettings(
                        playerIndex: playerIndex,
                        editor: (_) => s,
                      ),
                    );
                    if (playerSettings.runsTwoPartners && !s.runsTwoPartners) {
                      interactionLogic.usePartnerA(playerIndex);
                    }
                  }
                  case ValueChanged<PlayerSettings> update) ...[
                SectionTitle(
                  title: Text(playerSettings.name),
                  trailing: PlayerPartnersToggle(
                    playerSettings: playerSettings,
                    update: update,
                  ),
                ),
                PlayerCommanderCard(
                  playerSettings: playerSettings,
                  partnerA: true,
                  onChanged: update,
                  focusSettings: focusSettings,
                ),
                AnimatedListed(
                  listed: playerSettings.runsTwoPartners,
                  child: PlayerCommanderCard(
                    playerSettings: playerSettings,
                    partnerA: false,
                    onChanged: update,
                    focusSettings: focusSettings,
                  ),
                ),
              ],
        Space.vertical(context.theme.layout.margin.medium - 6),
      ],
    );
  }
}
