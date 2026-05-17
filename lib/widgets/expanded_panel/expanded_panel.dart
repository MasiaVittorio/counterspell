import 'package:counter_spell/logic/pages_logic.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:counter_spell/widgets/components/builders/can_use_arena_view_builder.dart';
import 'package:counter_spell/widgets/components/project/custom_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class ExpandedPanel extends StatelessWidget {
  const ExpandedPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final pagesLogic = context.pagesLogic;
    return pagesLogic.panelPage.build((context, value) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              removeTop: false,
              child: UsesArenaViewBuilder(
                child: AnimatedPagedView(
                  value: value,
                  pages: PanelPage.viewPages,
                ),
                builder: (context, usesArenaView, child) {
                  return Stack(
                    children: [
                      Positioned.fill(child: child!),
                      if (usesArenaView)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: PanelHeader(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          HorizontalNavigationBar(
            height: 64,
            value: value,
            onChanged: pagesLogic.panelPage.update,
            items: PanelPage.navigationItems,
          ),
          const CustomPopScope(),
        ],
      );
    });
  }
}
