import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class CustomPopScope extends StatelessWidget {
  const CustomPopScope({super.key});

  @override
  Widget build(BuildContext context) {
    final frame = context.panelFrame;
    final counterSpell = context.counterSpell;
    final pagesLogic = counterSpell.pagesLogic;
    final arenaLogic = counterSpell.arenaLogic;
    return frame.buildWithIsPanelOpen(
      builder: (context, isPanelOpen) => frame.buildWithAlertsCount(
        builder: (context, alertsCount) {
          return (
            pagesLogic.bodyPage,
            pagesLogic.panelPage,
            arenaLogic.isMenuOpen,
          ).build((context, bodyPage, panelPage, arenaMenu) {
            return PopScope(
              canPop: switch ((alertsCount, isPanelOpen)) {
                (> 0, _) => false,
                (_, true) => false,
                (_, false) => bodyPage == BodyPage.life,
              },
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (arenaMenu) {
                  if (alertsCount == 1) {
                    arenaLogic.isMenuOpen.update(false);
                    if (arenaLogic.isArenaViewOpen) {
                      return;
                    }
                  } else if (alertsCount == 0) {
                    arenaLogic.isMenuOpen.update(false);
                    arenaLogic.isArenaViewOpen = false;
                  }
                }
                if (alertsCount > 0) {
                  context.panelFrame.previousAlert();
                  return;
                }
                if (isPanelOpen) {
                  if (panelPage != PanelPage.game) {
                    pagesLogic.panelPage.update(PanelPage.game);
                    return;
                  }
                  context.panelFrame.closePanel();
                  return;
                }
                if (bodyPage != BodyPage.life) {
                  pagesLogic.bodyPage.update(BodyPage.life);
                  return;
                }
              },
              child: const SizedBox.shrink(),
            );
          });
        },
      ),
    );
  }
}
